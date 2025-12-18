// ============================================
// CONTROLLER CLASS
// ============================================

import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../meal_planner_all_model/meal_planner_all_model.dart';
import '../meal_planner_service/meal_planner_service.dart';

class MealPlanController extends GetxController {
  var meals = <MealSection>[].obs;
  var nutritionExpanded = true.obs;
  var prepListComments = <Comment>[].obs;
  var prepListItems = <PrepListApiModel>[].obs;
  var isLoading = false.obs;
  var isCreatingMealPlan = false.obs;

  // Track dates with meal plans and shopping lists
  var datesWithMealPlans = <String>{}.obs; // Stores date strings (YYYY-MM-DD)
  var datesWithShoppingLists = <String>{}.obs;

  // Store all meal plans by date
  var mealPlansByDate = <String, List<MealPlanApiModel>>{}.obs;

  String? selectedRecipeId;

  @override
  void onInit() {
    super.onInit();
    _initializeMeals();
    // Load meal plans from local storage first
    loadMealPlansFromLocalStorage();
    // Don't auto-fetch on init to avoid unnecessary API calls
    // Meal plans will be fetched when specific dates are requested
  }

  void _initializeMeals() {
    // Initialize with default meal sections
    meals.value = [
      MealSection(
        id: 'breakfast',
        title: 'Breakfast',
        tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
        isExpanded: true,
      ),
      MealSection(
        id: 'snack1',
        title: 'Snack',
        tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
        isExpanded: true,
      ),
      MealSection(
        id: 'lunch',
        title: 'Lunch',
        tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
        isExpanded: true,
      ),
      MealSection(
        id: 'snack2',
        title: 'Snack',
        tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
        isExpanded: false,
      ),
      MealSection(
        id: 'dinner',
        title: 'Dinner',
        tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
        isExpanded: true,
      ),
    ];
  }

  /// Helper to convert any date to YYYY-MM-DD format
  String _toDateString(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      print("⚠️ Error parsing date '$dateStr': $e");
      return dateStr;
    }
  }

  /// Fetch ALL meal plans from API and organize by date
  Future<void> fetchAllMealPlansFromAPI() async {
    print("📥 Fetching ALL meal plans from API...");
    final response = await MealPlannerService.getAllMealPlans();

    if (response['success'] == true && response['data'] != null) {
      final List<dynamic> allMealPlansJson = response['data'];
      final allMealPlans = allMealPlansJson
          .map((json) => MealPlanApiModel.fromJson(json))
          .toList();

      print("✅ Fetched ${allMealPlans.length} total meal plans from API");

      // Clear existing data
      mealPlansByDate.clear();
      datesWithMealPlans.clear();

      // Group by date
      for (var mealPlan in allMealPlans) {
        final planDateStr = _toDateString(mealPlan.date);

        if (!mealPlansByDate.containsKey(planDateStr)) {
          mealPlansByDate[planDateStr] = [];
        }
        mealPlansByDate[planDateStr]!.add(mealPlan);
        datesWithMealPlans.add(planDateStr);
      }

      print("📊 Organized meal plans into ${mealPlansByDate.length} unique dates");
      print("📅 Dates with meal plans: ${datesWithMealPlans.toList()}");

      mealPlansByDate.refresh();
      datesWithMealPlans.refresh();

      // Save to local storage for persistence
      await saveMealPlansToLocalStorage();
    } else {
      throw Exception("Failed to fetch all meal plans: ${response['message'] ?? 'Unknown error'}");
    }
  }

  /// Fetch meal plans for a specific date from API (optional - for targeted refresh)
  Future<void> fetchMealPlansForDate(String dateStr) async {
    try {
      isLoading.value = true;

      final normalizedDateStr = _toDateString(dateStr);
      print("📅 Loading meal plans for date: $normalizedDateStr");

      // First, load from cache if available
      loadMealPlansForDate(normalizedDateStr);

      // Try to fetch fresh data from API (try all meal plans first, then fallback to date-specific)
      bool apiSuccess = false;

      try {
        // Try fetching all meal plans
        await fetchAllMealPlansFromAPI();
        apiSuccess = true;
        print("✅ Successfully refreshed all meal plans from API");
      } catch (e) {
        print("⚠️ Failed to fetch all meal plans, trying date-specific fetch: $e");

        // Fallback: try date-specific endpoint
        try {
          final response = await MealPlannerService.getMealPlan(normalizedDateStr);

          if (response['success'] == true && response['data'] != null) {
            final List<dynamic> mealPlansJson = response['data'];

            if (mealPlansJson.isNotEmpty) {
              final mealPlans = mealPlansJson
                  .map((json) => MealPlanApiModel.fromJson(json))
                  .toList();

              mealPlansByDate[normalizedDateStr] = mealPlans;
              datesWithMealPlans.add(normalizedDateStr);

              mealPlansByDate.refresh();
              datesWithMealPlans.refresh();

              await saveMealPlansToLocalStorage();

              apiSuccess = true;
              print("✅ Successfully fetched meal plans for $normalizedDateStr from date-specific API");
            } else {
              print("ℹ️ No meal plans found on API for $normalizedDateStr");
              mealPlansByDate[normalizedDateStr] = [];
              datesWithMealPlans.remove(normalizedDateStr);
            }
          }
        } catch (e2) {
          print("⚠️ Date-specific fetch also failed: $e2");
          print("ℹ️ Using cached data only");
        }
      }

      // Reload the UI with potentially updated data
      loadMealPlansForDate(normalizedDateStr);

      if (apiSuccess) {
        print("✅ Meal plans refreshed and loaded for $normalizedDateStr");
      } else {
        print("ℹ️ Displaying cached meal plans for $normalizedDateStr");
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Load meal plans for a specific date into the meal sections (from cache)
  void loadMealPlansForDate(String dateStr) {
    final normalizedDateStr = _toDateString(dateStr);
    print("📅 Loading meal plans for date: $normalizedDateStr");

    // Reset all meal sections
    _initializeMeals();

    // Get meal plans for this date
    final plansForDate = mealPlansByDate[normalizedDateStr] ?? [];

    if (plansForDate.isEmpty) {
      print("ℹ️ No meal plans for $normalizedDateStr");
      meals.refresh();
      return;
    }

    print("✅ Found ${plansForDate.length} meal plans for $normalizedDateStr");

    // Update meal sections with data for this date
    for (var mealPlan in plansForDate) {
      final mealTime = mealPlan.mealTime.toLowerCase();
      final index = meals.indexWhere(
          (meal) => meal.title.toLowerCase() == mealTime);

      if (index != -1) {
        // Get recipe details if available
        String recipeName = 'Meal Plan';
        String? imageUrl;
        int servings = mealPlan.serving;

        // Try to extract recipe info from the recipes array
        if (mealPlan.recipes.isNotEmpty) {
          final recipe = mealPlan.recipes[0];
          if (recipe is Map<String, dynamic>) {
            recipeName = recipe['title'] ?? 'Recipe';
            if (recipe['images'] != null && (recipe['images'] as List).isNotEmpty) {
              imageUrl = recipe['images'][0];
            }
          } else if (recipe is String) {
            // Just an ID, keep default name
            recipeName = 'Recipe ${recipe.substring(0, 8)}...';
          }
        }

        meals[index].recipe = MealRecipe(
          name: recipeName,
          servings: '$servings servings',
          imageUrl: imageUrl,
        );

        print("   ✓ Updated ${meals[index].title} section: $recipeName ($servings servings)");
      }
    }

    meals.refresh();
  }

  /// Fetch prep list from API
  Future<void> fetchPrepList(String date) async {
    try {
      final normalizedDateStr = _toDateString(date);

      print("📤 Fetching prep list for date: $normalizedDateStr");

      final response = await MealPlannerService.getPrepList(normalizedDateStr);

      if (response['success'] == true && response['data'] != null) {
        final prepList = PrepListApiModel.fromJson(response['data']);
        prepListItems.value = [prepList];

        print("✅ Loaded prep list for $normalizedDateStr");
        print("   Serving: ${prepList.serving}");
        print("   Cooker: ${prepList.cooker}");
        print("   Recipes count: ${prepList.recipes.length}");

        // Print recipe details
        for (var i = 0; i < prepList.recipes.length; i++) {
          final recipe = prepList.recipes[i];
          print("   Recipe ${i + 1}: ${recipe.recipeTitle ?? recipe.recipeId ?? 'Unknown'} (Done: ${recipe.isDone})");
        }
      } else {
        print("⚠️ No prep list found for $normalizedDateStr");
        prepListItems.clear();
      }
    } catch (e) {
      print("❌ Error fetching prep list: $e");
      prepListItems.clear();
    }
  }

  /// Helper function to parse date string to ISO 8601 format
  /// Supports formats like: "17.12.2025", "Mo, 22.1.26", "2025-12-17"
  String _parseToIso8601(String dateStr) {
    try {
      // Remove day names like "Mo, ", "Tu, " etc
      String cleanDate = dateStr.replaceAll(RegExp(r'^[A-Za-z]+,?\s*'), '').trim();

      // Try parsing different formats
      DateTime? dateTime;

      // Format: "17.12.2025" or "22.1.26"
      if (cleanDate.contains('.')) {
        final parts = cleanDate.split('.');
        if (parts.length >= 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final yearStr = parts[2];

          // Handle 2-digit year (e.g., "26" -> "2026")
          int? year;
          if (yearStr.length == 2) {
            year = 2000 + int.parse(yearStr);
          } else {
            year = int.tryParse(yearStr);
          }

          if (day != null && month != null && year != null) {
            dateTime = DateTime(year, month, day);
          }
        }
      }
      // Format: "2025-12-17"
      else if (cleanDate.contains('-')) {
        dateTime = DateTime.tryParse(cleanDate);
      }

      if (dateTime != null) {
        return _toDateString(dateTime.toIso8601String());
      }

      // Fallback: use current date
      print("⚠️ Could not parse date '$dateStr', using current date");
      return _toDateString(DateTime.now().toIso8601String());
    } catch (e) {
      print("⚠️ Error parsing date '$dateStr': $e, using current date");
      return _toDateString(DateTime.now().toIso8601String());
    }
  }

  /// Create meal plan
  Future<bool> createMealPlan({
    required String recipeId,
    required List<MealPlanningItem> mealItems,
    required List<PreparationItem> prepItems,
    required String cookPerson,
  }) async {
    try {
      isCreatingMealPlan.value = true;

      // Convert to API format with proper date strings
      final prepListDate = prepItems.isNotEmpty && prepItems[0].day.isNotEmpty
          ? _parseToIso8601(prepItems[0].day)
          : _toDateString(DateTime.now().toIso8601String());

      final prepList = {
        "date": prepListDate,
        "serving": int.tryParse(prepItems.isNotEmpty ? prepItems[0].servings : "2") ?? 2,
        "cooker": cookPerson.isNotEmpty ? cookPerson : "me",
      };

      final meals = mealItems
          .where((item) => item.day.isNotEmpty && item.meal.isNotEmpty)
          .map((item) {
        return {
          "date": _parseToIso8601(item.day),
          "serving": int.tryParse(item.servings) ?? 2,
          "meal_time": item.meal.toLowerCase(),
        };
      }).toList();

      print("📋 Creating meal plan:");
      print("   Recipe ID: $recipeId");
      print("   Prep List Date: ${prepList['date']}");
      print("   Prep List Serving: ${prepList['serving']}");
      print("   Prep List Cooker: ${prepList['cooker']}");
      print("   Meals Count: ${meals.length}");
      for (var i = 0; i < meals.length; i++) {
        print("   Meal ${i + 1}: ${meals[i]['meal_time']} on ${meals[i]['date']} (${meals[i]['serving']} servings)");
      }

      final response = await MealPlannerService.createMealPlan(
        recipeId: recipeId,
        prepList: prepList,
        meals: meals,
      );

      if (response['success'] == true) {
        print("✅ Meal plan created successfully");

        // Extract the created meal plans from the response and store them locally
        if (response['data'] != null) {
          final List<dynamic> createdMealPlansJson = response['data'];
          final createdMealPlans = createdMealPlansJson
              .map((json) => MealPlanApiModel.fromJson(json))
              .toList();

          print("📦 Storing ${createdMealPlans.length} newly created meal plans");

          // Store each meal plan by date
          for (var mealPlan in createdMealPlans) {
            final dateStr = _toDateString(mealPlan.date);

            if (!mealPlansByDate.containsKey(dateStr)) {
              mealPlansByDate[dateStr] = [];
            }

            // Add to the list if not already present
            final existingIds = mealPlansByDate[dateStr]!.map((m) => m.id).toSet();
            if (!existingIds.contains(mealPlan.id)) {
              mealPlansByDate[dateStr]!.add(mealPlan);
            }

            datesWithMealPlans.add(dateStr);
            print("   ✓ Stored meal plan for $dateStr: ${mealPlan.mealTime} (${mealPlan.serving} servings)");
          }

          mealPlansByDate.refresh();
          datesWithMealPlans.refresh();

          // Save to local storage
          await saveMealPlansToLocalStorage();
        }

        // Try to refresh from API (optional, won't fail if API is down)
        try {
          await fetchAllMealPlansFromAPI();
        } catch (e) {
          print("⚠️ Could not refresh from API after creation, using local data: $e");
        }

        // Load the first affected date into the UI
        if (mealItems.isNotEmpty && mealItems[0].day.isNotEmpty) {
          final firstDateStr = _parseToIso8601(mealItems[0].day);
          loadMealPlansForDate(firstDateStr);
        }

        return true;
      } else {
        print("❌ Meal plan creation failed: ${response['message']}");
        return false;
      }
    } catch (e) {
      print("❌ Error creating meal plan: $e");
      return false;
    } finally {
      isCreatingMealPlan.value = false;
    }
  }

  void toggleMealExpansion(String mealId) {
    final index = meals.indexWhere((meal) => meal.id == mealId);
    if (index != -1) {
      meals[index].isExpanded = !meals[index].isExpanded;
      meals.refresh();
    }
  }

  void toggleNutritionExpansion() {
    nutritionExpanded.value = !nutritionExpanded.value;
  }

  void addRecipeToMeal(String mealId, MealRecipe recipe) {
    final index = meals.indexWhere((meal) => meal.id == mealId);
    if (index != -1) {
      meals[index].recipe = recipe;
      meals.refresh();
    }
  }

  void addPrepListComment(Comment comment) {
    prepListComments.add(comment);
  }

  /// Check if a date has a meal plan
  bool dateHasMealPlan(String dateStr) {
    final normalizedDateStr = _toDateString(dateStr);
    return datesWithMealPlans.contains(normalizedDateStr);
  }

  /// Check if a date has a shopping list
  bool dateHasShoppingList(String dateStr) {
    final normalizedDateStr = _toDateString(dateStr);
    return datesWithShoppingLists.contains(normalizedDateStr);
  }

  /// Mark a date as having a shopping list
  void markDateWithShoppingList(String dateStr) {
    final normalizedDateStr = _toDateString(dateStr);
    datesWithShoppingLists.add(normalizedDateStr);
    datesWithShoppingLists.refresh();
  }

  /// Save meal plans to local storage
  Future<void> saveMealPlansToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert mealPlansByDate to JSON
      final Map<String, dynamic> dataToSave = {};
      mealPlansByDate.forEach((date, mealPlans) {
        dataToSave[date] = mealPlans.map((plan) {
          return {
            'id': plan.id,
            'userId': plan.userId,
            'date': plan.date,
            'serving': plan.serving,
            'mealTime': plan.mealTime,
            'recipes': plan.recipes,
            'comments': plan.comments,
          };
        }).toList();
      });

      final jsonString = jsonEncode(dataToSave);
      await prefs.setString('meal_plans_cache', jsonString);

      print("💾 Saved ${mealPlansByDate.length} dates with meal plans to local storage");
    } catch (e) {
      print("❌ Error saving meal plans to local storage: $e");
    }
  }

  /// Load meal plans from local storage
  Future<void> loadMealPlansFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('meal_plans_cache');

      if (jsonString == null || jsonString.isEmpty) {
        print("ℹ️ No cached meal plans found in local storage");
        return;
      }

      final Map<String, dynamic> dataLoaded = jsonDecode(jsonString);

      // Clear existing data
      mealPlansByDate.clear();
      datesWithMealPlans.clear();

      // Restore meal plans
      dataLoaded.forEach((date, mealPlansJson) {
        final normalizedDate = _toDateString(date);
        final mealPlans = (mealPlansJson as List)
            .map((json) => MealPlanApiModel.fromJson(json))
            .toList();

        mealPlansByDate[normalizedDate] = mealPlans;
        datesWithMealPlans.add(normalizedDate);
      });

      print("📂 Loaded ${mealPlansByDate.length} dates with meal plans from local storage");
      print("📅 Dates: ${datesWithMealPlans.toList()}");

      mealPlansByDate.refresh();
      datesWithMealPlans.refresh();
    } catch (e) {
      print("❌ Error loading meal plans from local storage: $e");
    }
  }

  /// Refresh all data (meal plans and prep list for a specific date)
  Future<void> refreshAllData(String dateStr) async {
    final normalizedDateStr = _toDateString(dateStr);

    // Fetch meal plans and prep list concurrently
    await Future.wait([
      fetchMealPlansForDate(normalizedDateStr).catchError((e) {
        print("⚠️ Failed to refresh meal plans: $e");
      }),
      fetchPrepList(normalizedDateStr).catchError((e) {
        print("⚠️ Failed to refresh prep list: $e");
      }),
    ]);
  }
}
