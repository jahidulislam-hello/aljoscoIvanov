// ============================================
// CONTROLLER CLASS
// ============================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../meal_planner_all_model/meal_planner_all_model.dart';
import '../meal_planner_service/meal_planner_service.dart';
import 'package:freshbite/features/shopping_list/shopping/shopping_service/shopping_service.dart';
import 'package:freshbite/features/recepies/recipes_details/recipes_details_service/recipes_details_service.dart';

class MealPlanController extends GetxController {
  var meals = <MealSection>[].obs;
  var nutritionExpanded = true.obs;
  var prepListComments = <Comment>[].obs;
  var prepListItems = <PrepListApiModel>[].obs;
  var isLoading = false.obs;
  var isCreatingMealPlan = false.obs;

  // Track if shopping list exists for current prep list
  var prepListHasShoppingList = false.obs;
  var currentPrepListShoppingListId = ''.obs;

  // Track dates with meal plans, shopping lists, and prep lists
  var datesWithMealPlans = <String>{}.obs; // Stores date strings (YYYY-MM-DD)
  var datesWithShoppingLists = <String>{}.obs;
  var datesWithPrepLists = <String>{}.obs;

  // Store all meal plans by date
  var mealPlansByDate = <String, List<MealPlanApiModel>>{}.obs;

  String? selectedRecipeId;

  @override
  void onInit() {
    super.onInit();
    _initializeMeals();
    // Load meal plans from local storage first
    loadMealPlansFromLocalStorage().then((_) {
      // After loading from storage, refresh the UI with the stored data
      // Load the current date's meal plans to update the UI
      final today = _toDateString(DateTime.now().toIso8601String());
      loadMealPlansForDate(today);
    });
    // Don't auto-fetch on init to avoid unnecessary API calls
    // Meal plans will be fetched when specific dates are requested
  }

  void _initializeMeals() {
    // Initialize with default meal sections only if meals list is empty
    if (meals.isEmpty) {
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

  /// Fetch meal plans for a specific date from API
  Future<void> fetchMealPlansForDate(String dateStr) async {
    try {
      isLoading.value = true;

      final normalizedDateStr = _toDateString(dateStr);
      print("═══════════════════════════════════════════");
      print("📅 Fetching meal plans for date: $normalizedDateStr");
      print("   Input date string: $dateStr");

      // Fetch from API
      final response = await MealPlannerService.getMealPlan(normalizedDateStr);

      print("📥 API Response received:");
      print("   success: ${response['success']}");
      print("   data type: ${response['data']?.runtimeType}");
      print("   data length: ${(response['data'] as List?)?.length ?? 0}");

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> mealPlansJson = response['data'];

        if (mealPlansJson.isNotEmpty) {
          final mealPlans = mealPlansJson
              .map((json) => MealPlanApiModel.fromJson(json))
              .toList();

          // Store in cache
          mealPlansByDate[normalizedDateStr] = mealPlans;
          datesWithMealPlans.add(normalizedDateStr);

          print("✅ Fetched ${mealPlans.length} meal plans for $normalizedDateStr");
          for (var plan in mealPlans) {
            print("   - ${plan.mealTime}: ${plan.recipes.length} recipes, ${plan.serving} servings");
          }
        } else {
          print("ℹ️ No meal plans found for $normalizedDateStr");
          mealPlansByDate[normalizedDateStr] = [];
          // Remove from datesWithMealPlans since there are no meal plans
          datesWithMealPlans.remove(normalizedDateStr);
        }

        mealPlansByDate.refresh();
        datesWithMealPlans.refresh();

        // Save to local storage
        await saveMealPlansToLocalStorage();
      } else {
        print("⚠️ API returned no success: ${response['message']}");
        // Still try to clear old data for this date
        mealPlansByDate[normalizedDateStr] = [];
        datesWithMealPlans.remove(normalizedDateStr);
        mealPlansByDate.refresh();
        datesWithMealPlans.refresh();
      }

      // Load into UI sections
      print("📊 Loading meal plans into UI sections...");
      loadMealPlansForDate(normalizedDateStr);
      print("═══════════════════════════════════════════");

    } catch (e, stackTrace) {
      print("❌ Error fetching meal plans: $e");
      print("   Stack trace: $stackTrace");
      // Try to load from cache on error
      loadMealPlansForDate(_toDateString(dateStr));
    } finally {
      isLoading.value = false;
    }
  }

  /// Load meal plans for a specific date into the meal sections (from cache)
  void loadMealPlansForDate(String dateStr) {
    final normalizedDateStr = _toDateString(dateStr);
    print("📅 Loading meal plans into UI for: $normalizedDateStr");

    // Debug: Show all cached dates
    print("   📦 Cached dates: ${mealPlansByDate.keys.toList()}");

    // Initialize meal sections if they're empty
    _initializeMeals();

    // Get meal plans for this date
    final plansForDate = mealPlansByDate[normalizedDateStr] ?? [];

    // Create new meal sections list with cleared recipes
    final updatedMeals = <MealSection>[];
    for (var meal in meals) {
      updatedMeals.add(MealSection(
        id: meal.id,
        title: meal.title,
        tags: meal.tags,
        recipe: null, // Clear recipe
        comments: meal.comments,
        isExpanded: meal.isExpanded,
      ));
    }

    if (plansForDate.isEmpty) {
      print("ℹ️ No meal plans to display for $normalizedDateStr");
      meals.assignAll(updatedMeals);
      return;
    }

    print("✅ Loading ${plansForDate.length} meal plans into UI");

    // Update meal sections with data for this date
    for (var mealPlan in plansForDate) {
      final mealTime = mealPlan.mealTime.toLowerCase().trim();
      print("   🍽️ Processing: meal_time='$mealTime', serving=${mealPlan.serving}");

      // Find matching meal section (breakfast, lunch, dinner, snack)
      int index = -1;
      if (mealTime == 'breakfast') {
        index = updatedMeals.indexWhere((m) => m.id == 'breakfast');
      } else if (mealTime == 'lunch') {
        index = updatedMeals.indexWhere((m) => m.id == 'lunch');
      } else if (mealTime == 'dinner') {
        index = updatedMeals.indexWhere((m) => m.id == 'dinner');
      } else if (mealTime == 'snack') {
        // Find first empty snack slot
        index = updatedMeals.indexWhere((m) => m.id.startsWith('snack') && m.recipe == null);
        if (index == -1) {
          index = updatedMeals.indexWhere((m) => m.id == 'snack1');
        }
      }

      print("   🔍 Found index: $index for meal_time: $mealTime");

      if (index != -1) {
        // Get recipe details from the populated recipes array
        String recipeName = 'Meal Plan';
        String? imageUrl;
        int servings = mealPlan.serving;

        print("   📋 Recipes count: ${mealPlan.recipes.length}");
        print("   📋 Recipes data: ${mealPlan.recipes}");

        if (mealPlan.recipes.isNotEmpty) {
          final recipe = mealPlan.recipes[0];
          print("   📋 Recipe type: ${recipe.runtimeType}");

          if (recipe is Map<String, dynamic>) {
            // Full recipe data from API
            recipeName = recipe['title']?.toString() ?? 'Recipe';

            // Get image from images array
            if (recipe['images'] != null && recipe['images'] is List) {
              final images = recipe['images'] as List;
              if (images.isNotEmpty) {
                imageUrl = images[0]?.toString();
              }
            }

            print("   ✅ Setting ${updatedMeals[index].title}: $recipeName (image: ${imageUrl != null})");
          } else if (recipe is String) {
            // Just recipe ID
            recipeName = 'Recipe';
            print("   ✅ Setting ${updatedMeals[index].title}: Recipe ID $recipe");
          } else {
            // Try to cast to Map in case it's a different Map type
            try {
              final recipeMap = recipe as Map;
              recipeName = recipeMap['title']?.toString() ?? 'Recipe';
              if (recipeMap['images'] != null && recipeMap['images'] is List) {
                final images = recipeMap['images'] as List;
                if (images.isNotEmpty) {
                  imageUrl = images[0]?.toString();
                }
              }
              print("   ✅ Setting ${updatedMeals[index].title}: $recipeName (cast from Map)");
            } catch (e) {
              print("   ⚠️ Could not parse recipe: $e");
            }
          }
        }

        // Create new MealSection with recipe
        updatedMeals[index] = MealSection(
          id: updatedMeals[index].id,
          title: updatedMeals[index].title,
          tags: updatedMeals[index].tags,
          recipe: MealRecipe(
            name: recipeName,
            servings: '$servings servings',
            imageUrl: imageUrl,
          ),
          comments: updatedMeals[index].comments,
          isExpanded: updatedMeals[index].isExpanded,
        );
      } else {
        print("   ⚠️ No matching section found for meal_time: $mealTime");
      }
    }

    print("   🔄 Updating meals list with ${updatedMeals.length} sections...");
    meals.assignAll(updatedMeals);
    print("   ✅ Done loading meal plans into UI");
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

        // Track this date as having a prep list
        datesWithPrepLists.add(normalizedDateStr);
        datesWithPrepLists.refresh();

        print("✅ Loaded prep list for $normalizedDateStr");
        print("   Serving: ${prepList.serving}");
        print("   Cooker: ${prepList.cooker}");
        print("   Recipes count: ${prepList.recipes.length}");

        // Print recipe details
        for (var i = 0; i < prepList.recipes.length; i++) {
          final recipe = prepList.recipes[i];
          print("   Recipe ${i + 1}: ${recipe.recipeTitle ?? recipe.recipeId ?? 'Unknown'} (Done: ${recipe.isDone})");
        }

        // Check if shopping list exists for this date
        await checkShoppingListForDate(normalizedDateStr);
      } else {
        print("⚠️ No prep list found for $normalizedDateStr");
        prepListItems.clear();
        datesWithPrepLists.remove(normalizedDateStr);
        datesWithPrepLists.refresh();
        prepListHasShoppingList.value = false;
        currentPrepListShoppingListId.value = '';
      }
    } catch (e) {
      print("❌ Error fetching prep list: $e");
      prepListItems.clear();
      prepListHasShoppingList.value = false;
      currentPrepListShoppingListId.value = '';
    }
  }
  /// Check if shopping list exists for a specific date
  Future<void> checkShoppingListForDate(String dateStr) async {
    try {
      final response = await ShoppingService.getMyShoppingLists();

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> shoppingLists = response['data'];

        // Check if any shopping list matches this date
        for (var list in shoppingLists) {
          final listDate = list['date'] ?? '';
          final normalizedListDate = _toDateString(listDate);

          if (normalizedListDate == dateStr) {
            prepListHasShoppingList.value = true;
            currentPrepListShoppingListId.value = list['_id'] ?? '';
            print("✅ Found existing shopping list for $dateStr: ${currentPrepListShoppingListId.value}");
            return;
          }
        }

        prepListHasShoppingList.value = false;
        currentPrepListShoppingListId.value = '';
        print("ℹ️ No shopping list found for $dateStr");
      }
    } catch (e) {
      print("⚠️ Error checking shopping list: $e");
      prepListHasShoppingList.value = false;
      currentPrepListShoppingListId.value = '';
    }
  }

  /// Helper function to parse date string to ISO 8601 format with 08:00:00 UTC
  /// Supports formats like: "17.12.2025", "Mo, 22.1.26", "2025-12-17"
  String _parseToIso8601(String dateStr) {
    try {
      // Remove day names like "Mo, ", "Tu, " etc
      String cleanDate = dateStr.replaceAll(RegExp(r'^[A-Za-z]+,?\s*'), '').trim();

      int? day, month, year;

      // Format: "17.12.2025" or "22.1.26"
      if (cleanDate.contains('.')) {
        final parts = cleanDate.split('.');
        if (parts.length >= 3) {
          day = int.tryParse(parts[0]);
          month = int.tryParse(parts[1]);
          final yearStr = parts[2];

          // Handle 2-digit year (e.g., "26" -> "2026")
          if (yearStr.length == 2) {
            year = 2000 + int.parse(yearStr);
          } else {
            year = int.tryParse(yearStr);
          }
        }
      }
      // Format: "2025-12-17"
      else if (cleanDate.contains('-')) {
        final parsed = DateTime.tryParse(cleanDate);
        if (parsed != null) {
          day = parsed.day;
          month = parsed.month;
          year = parsed.year;
        }
      }

      if (day != null && month != null && year != null) {
        // Create UTC time directly to avoid timezone conversion issues
        return DateTime.utc(year, month, day, 8, 0, 0).toIso8601String();
      }

      // Fallback: use current date with 08:00:00 UTC
      print("⚠️ Could not parse date '$dateStr', using current date");
      final now = DateTime.now();
      return DateTime.utc(now.year, now.month, now.day, 8, 0, 0).toIso8601String();
    } catch (e) {
      print("⚠️ Error parsing date '$dateStr': $e, using current date");
      final now = DateTime.now();
      return DateTime.utc(now.year, now.month, now.day, 8, 0, 0).toIso8601String();
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

      // Convert to API format with proper date strings (ISO 8601 with 08:00:00 UTC)
      final now = DateTime.now();
      final defaultDate = DateTime.utc(now.year, now.month, now.day, 8, 0, 0).toIso8601String();
      final prepListDate = prepItems.isNotEmpty && prepItems[0].day.isNotEmpty
          ? _parseToIso8601(prepItems[0].day)
          : defaultDate;

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

        // Refresh from API to get full recipe data
        if (mealItems.isNotEmpty && mealItems[0].day.isNotEmpty) {
          final firstDateStr = _parseToIso8601(mealItems[0].day);

          // Fetch fresh data from API with full recipe details
          await fetchMealPlansForDate(firstDateStr);

          print("✅ Refreshed meal plans for $firstDateStr");
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
      // Create new MealSection with toggled expansion to trigger UI update
      final oldMeal = meals[index];
      meals[index] = MealSection(
        id: oldMeal.id,
        title: oldMeal.title,
        tags: oldMeal.tags,
        recipe: oldMeal.recipe,
        comments: oldMeal.comments,
        isExpanded: !oldMeal.isExpanded,
      );
      meals.refresh();
    }
  }

  void toggleNutritionExpansion() {
    nutritionExpanded.value = !nutritionExpanded.value;
  }

  void addRecipeToMeal(String mealId, MealRecipe recipe) {
    final index = meals.indexWhere((meal) => meal.id == mealId);
    if (index != -1) {
      // Create new MealSection with recipe to trigger UI update
      final oldMeal = meals[index];
      meals[index] = MealSection(
        id: oldMeal.id,
        title: oldMeal.title,
        tags: oldMeal.tags,
        recipe: recipe,
        comments: oldMeal.comments,
        isExpanded: oldMeal.isExpanded,
      );
      meals.refresh();
    }
  }

  void addPrepListComment(Comment comment) {
    prepListComments.add(comment);
  }

  /// Add comment to meal plan via API
  Future<bool> addCommentToMealPlan({
    required String mealPlanId,
    required String comment,
  }) async {
    try {
      print("📤 Adding comment to meal plan: $mealPlanId");

      final response = await MealPlannerService.addCommentToMealPlan(
        mealPlanId: mealPlanId,
        comment: comment,
      );

      if (response['success'] == true) {
        print("✅ Comment added successfully");

        // Refresh the meal plans to get updated comments
        final today = _toDateString(DateTime.now().toIso8601String());
        await fetchMealPlansForDate(today);

        return true;
      } else {
        print("❌ Failed to add comment: ${response['message']}");
        return false;
      }
    } catch (e) {
      print("❌ Error adding comment: $e");
      return false;
    }
  }

  /// Get meal plan ID for a specific meal section on current date
  String? getMealPlanIdForSection(String mealSectionId, String dateStr) {
    final normalizedDateStr = _toDateString(dateStr);
    final plansForDate = mealPlansByDate[normalizedDateStr] ?? [];

    // Find the meal plan that matches the meal section's meal time
    final mealSection = meals.firstWhereOrNull((m) => m.id == mealSectionId);
    if (mealSection == null) return null;

    final mealTime = mealSection.title.toLowerCase();
    final matchingPlan = plansForDate.firstWhereOrNull(
      (plan) => plan.mealTime.toLowerCase() == mealTime,
    );

    return matchingPlan?.id;
  }

  /// Get comments for a specific meal plan
  List<Comment> getCommentsForMealPlan(String mealPlanId) {
    // Search through all meal plans to find the one with matching ID
    for (var entry in mealPlansByDate.entries) {
      for (var mealPlan in entry.value) {
        if (mealPlan.id == mealPlanId) {
          return mealPlan.comments.map((c) {
            if (c is Map<String, dynamic>) {
              return Comment(
                userName: c['userName'] ?? c['user'] ?? 'User',
                date: c['date'] ?? c['createdAt'] ?? '',
                message: c['comment'] ?? c['message'] ?? c['text'] ?? '',
                avatarUrl: c['avatar'] ?? c['avatarUrl'],
              );
            }
            return Comment(
              userName: 'User',
              date: '',
              message: c.toString(),
            );
          }).toList();
        }
      }
    }
    return [];
  }

  /// Toggle prep list item done state
  void togglePrepItemDone(int index) {
    if (prepListItems.isNotEmpty && index < prepListItems.first.recipes.length) {
      prepListItems.first.recipes[index].isDone = !prepListItems.first.recipes[index].isDone;
      prepListItems.refresh();
      print("✅ Toggled prep item $index: isDone = ${prepListItems.first.recipes[index].isDone}");
    }
  }

  /// Check if all prep list items are done
  bool areAllPrepItemsDone() {
    if (prepListItems.isEmpty || prepListItems.first.recipes.isEmpty) {
      return false;
    }
    return prepListItems.first.recipes.every((recipe) => recipe.isDone);
  }

  /// Check if a date has a meal plan
  bool dateHasMealPlan(String dateStr) {
    final normalizedDateStr = _toDateString(dateStr);
    return datesWithMealPlans.contains(normalizedDateStr);
  }

  /// Check if a date has a prep list
  bool dateHasPrepList(String dateStr) {
    final normalizedDateStr = _toDateString(dateStr);
    return datesWithPrepLists.contains(normalizedDateStr);
  }

  /// Fetch prep list status for multiple dates (for calendar icons)
  Future<void> fetchPrepListStatusForDates(List<DateTime> dates) async {
    print("📅 Fetching prep list status for ${dates.length} dates...");

    for (var date in dates) {
      final dateStr = _toDateString(date.toIso8601String());

      // Skip if already fetched
      if (datesWithPrepLists.contains(dateStr)) {
        continue;
      }

      try {
        final response = await MealPlannerService.getPrepList(dateStr);

        if (response['success'] == true && response['data'] != null) {
          datesWithPrepLists.add(dateStr);
          print("   ✅ $dateStr: has prep list");
        } else {
          print("   ⭕ $dateStr: no prep list");
        }
      } catch (e) {
        print("   ❌ Error fetching $dateStr: $e");
      }
    }

    datesWithPrepLists.refresh();
    print("✅ Done fetching prep list status for all dates");
  }

  /// Fetch meal plan status for multiple dates (for calendar icons)
  Future<void> fetchMealPlanStatusForDates(List<DateTime> dates) async {
    print("📅 Fetching meal plan status for ${dates.length} dates...");

    for (var date in dates) {
      final dateStr = _toDateString(date.toIso8601String());

      // Skip if already fetched
      if (mealPlansByDate.containsKey(dateStr)) {
        print("   ⏭️ Skipping $dateStr (already cached)");
        continue;
      }

      try {
        final response = await MealPlannerService.getMealPlan(dateStr);

        if (response['success'] == true && response['data'] != null) {
          final List<dynamic> mealPlansJson = response['data'];

          if (mealPlansJson.isNotEmpty) {
            final mealPlans = mealPlansJson
                .map((json) => MealPlanApiModel.fromJson(json))
                .toList();

            mealPlansByDate[dateStr] = mealPlans;
            datesWithMealPlans.add(dateStr);
            print("   ✅ $dateStr: ${mealPlans.length} meal plans");
          } else {
            mealPlansByDate[dateStr] = [];
            datesWithMealPlans.remove(dateStr);
            print("   ⭕ $dateStr: no meal plans");
          }
        }
      } catch (e) {
        print("   ❌ Error fetching $dateStr: $e");
      }
    }

    mealPlansByDate.refresh();
    datesWithMealPlans.refresh();
    await saveMealPlansToLocalStorage();
    print("✅ Done fetching meal plan status for all dates");
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
            '_id': plan.id,
            'userId': plan.userId,
            'date': plan.date,
            'serving': plan.serving,
            'meal_time': plan.mealTime,  // Use underscore to match API format
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

      // Refresh the UI with the loaded data
      final today = _toDateString(DateTime.now().toIso8601String());
      loadMealPlansForDate(today);
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

  /// Create shopping list from prep list
  Future<bool> createShoppingListFromPrepList(DateTime selectedDate) async {
    try {
      if (prepListItems.isEmpty || prepListItems.first.recipes.isEmpty) {
        Get.snackbar(
          'Error',
          'No prep list available for this date',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      isLoading.value = true;
      final prepList = prepListItems.first;
      final dateStr = selectedDate.toUtc().toIso8601String();
      final formattedDate = '${selectedDate.day}.${selectedDate.month}.${selectedDate.year.toString().substring(2)}';

      print("📤 Creating shopping list from prep list...");
      print("   Date: $dateStr");
      print("   Recipes: ${prepList.recipes.length}");
      print("   Cooker: ${prepList.cooker}");

      // Get recipe IDs from prep list
      final recipeIds = prepList.recipes
          .where((r) => r.recipeId != null && r.recipeId!.isNotEmpty)
          .map((r) => r.recipeId!)
          .toList();

      if (recipeIds.isEmpty) {
        Get.snackbar(
          'Error',
          'No valid recipes found in prep list',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      print("   Recipe IDs: $recipeIds");

      // Fetch recipe details for all recipes to get ingredients
      List<Map<String, dynamic>> allSections = [];
      List<String> recipeNames = [];

      for (var recipeId in recipeIds) {
        try {
          print("📤 Fetching recipe details for: $recipeId");
          final recipeResponse = await RecipesDetailsService.getSingleRecipe(recipeId);

          if (recipeResponse['success'] == true && recipeResponse['data'] != null) {
            final recipeData = recipeResponse['data'];
            final recipeName = recipeData['title'] ?? 'Recipe';
            recipeNames.add(recipeName);

            // Get ingredients from recipe
            final ingredients = recipeData['ingredients'] as List<dynamic>? ?? [];

            if (ingredients.isNotEmpty) {
              // Transform ingredients to shopping list format
              List<Map<String, dynamic>> ingredientList = [];

              for (var ing in ingredients) {
                // Parse amount value
                final value = ing['value']?.toString() ?? '1';
                final parsedAmount = double.tryParse(value) ?? 1.0;
                final singleVal = parsedAmount / 2;
                final householdVal = parsedAmount * 100;
                final householdSingleVal = householdVal * singleVal / parsedAmount;

                // Get unit and map to household unit
                final unit = ing['unit']?.toString() ?? 'pcs';
                String houseHoldUnit = 'g';
                switch (unit.toLowerCase()) {
                  case 'l':
                    houseHoldUnit = 'ml';
                    break;
                  case 'kg':
                    houseHoldUnit = 'g';
                    break;
                  case 'lb':
                    houseHoldUnit = 'oz';
                    break;
                  default:
                    houseHoldUnit = 'g';
                }

                ingredientList.add({
                  'name': ing['name'] ?? '',
                  'unit': unit,
                  'value': value,
                  'singleValue': singleVal.toString(),
                  'categories': ing['categories'] ?? 'Convenience',
                  'houseHoldUnit': houseHoldUnit,
                  'householdValue': householdVal.toString(),
                  'houseHoldForSingleValue': householdSingleVal.toString(),
                });
              }

              allSections.add({
                'name': recipeName,
                'ingredient': ingredientList,
              });

              print("✅ Added ${ingredientList.length} ingredients from $recipeName");
            }
          }
        } catch (e) {
          print("⚠️ Failed to fetch recipe $recipeId: $e");
        }
      }

      if (allSections.isEmpty) {
        Get.snackbar(
          'Error',
          'Could not fetch recipe ingredients',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // Create shopping list title
      final title = recipeNames.length == 1
          ? '${recipeNames.first} Shopping List'
          : 'Prep List Shopping - $formattedDate';

      final description = recipeNames.length == 1
          ? 'Ingredients for ${recipeNames.first}'
          : 'Ingredients for: ${recipeNames.join(", ")}';

      print("📤 Creating shopping list:");
      print("   Title: $title");
      print("   Sections: ${allSections.length}");

      // Create proper shopping list using ShoppingService
      final response = await ShoppingService.createShoppingList(
        title: title,
        description: description,
        date: dateStr,
        list: allSections,
        coocker: prepList.cooker.isNotEmpty ? prepList.cooker : 'me',
      );

      if (response['success'] == true) {
        print("✅ Shopping list created successfully from prep list");

        // Mark the date as having a shopping list
        markDateWithShoppingList(_toDateString(dateStr));

        // Update the prep list shopping list flag
        prepListHasShoppingList.value = true;
        if (response['data'] != null && response['data']['_id'] != null) {
          currentPrepListShoppingListId.value = response['data']['_id'];
        }

        Get.snackbar(
          'Success',
          'Shopping list created for $formattedDate',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        return true;
      } else {
        print("❌ Failed to create shopping list: ${response['message']}");
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to create shopping list',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      print("❌ Error creating shopping list from prep list: $e");
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
