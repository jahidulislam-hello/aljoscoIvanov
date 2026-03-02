
// ================= CONTROLLER =================
import 'package:freshbite/features/meal_planner/meal_planner_new/meal_planner_service/meal_planner_service.dart';
import 'package:freshbite/features/meal_planner/reused_meal_plan/reused_meal_plan_model.dart';
import 'package:freshbite/features/meal_planner/save_meal_plan_details/save_meal_plan_details_model.dart';
import 'package:get/get.dart';

class SavedMealPlanDetailsController extends GetxController {
  var dailyPlans = <DailyMealPlanModel>[].obs;
  var selectedMealPlans = <MealPlanModel>[].obs;
  var isLoading = false.obs;
  var sequenceMealDetails = Rxn<SequenceMealDetailsModel>();

  // Store the sequence meal ID for fetching details
  String? sequenceMealId;
  String appBarTitle = 'Meal Plan Details';

  void setSelectedMealPlans(List<MealPlanModel> plans) {
    selectedMealPlans.value = plans;

    // If only one plan selected, fetch its details from API
    if (plans.length == 1 && plans.first.id.isNotEmpty) {
      sequenceMealId = plans.first.id;
      appBarTitle = plans.first.title;
      fetchSequenceMealDetails(plans.first.id);
    } else {
      _generateDailyPlansFromSelected();
    }
  }

  /// Set sequence meal ID directly and fetch details
  void setSequenceMealId(String id, String title) {
    sequenceMealId = id;
    appBarTitle = title;
    fetchSequenceMealDetails(id);
  }

  /// Fetch single sequence meal details from API
  Future<void> fetchSequenceMealDetails(String id) async {
    try {
      isLoading.value = true;

      final response = await MealPlannerService.getSingleSequenceMeal(id);

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;

        // Parse the response manually for better control
        final title = data['title'] ?? '';
        final description = data['description'] ?? '';
        final plansData = data['plans'] as List? ?? [];

        // Create daily plans from the response
        List<DailyMealPlanModel> parsedPlans = [];

        for (var planData in plansData) {
          final planMap = planData as Map<String, dynamic>;

          // Format the date
          String formattedDate = '';
          if (planMap['date'] != null) {
            try {
              final date = DateTime.parse(planMap['date']);
              final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
              final months = [
                'January', 'February', 'March', 'April', 'May', 'June',
                'July', 'August', 'September', 'October', 'November', 'December'
              ];
              formattedDate = '${days[date.weekday % 7]} ${date.day}, ${months[date.month - 1]} ${date.year}';
            } catch (e) {
              formattedDate = planMap['date'] ?? '';
            }
          }

          // Parse meals
          List<MealItemModel> meals = [];
          final mealsData = planMap['meals'] as List? ?? [];

          for (var meal in mealsData) {
            if (meal is Map<String, dynamic>) {
              // Get meal type
              String mealType = meal['meal_time'] ?? 'Meal';
              mealType = mealType.isNotEmpty
                  ? mealType[0].toUpperCase() + mealType.substring(1)
                  : 'Meal';

              // Get title from recipes
              String mealTitle = 'Meal';
              final recipes = meal['recipes'] as List? ?? [];
              if (recipes.isNotEmpty) {
                final recipe = recipes[0];
                if (recipe is Map) {
                  mealTitle = recipe['title'] ?? 'Recipe';
                } else if (recipe is String) {
                  mealTitle = 'Recipe';
                }
              }

              // Get servings
              int serving = meal['serving'] ?? 2;

              meals.add(MealItemModel(
                mealType: mealType,
                title: mealTitle,
                servings: '$serving Servings',
              ));
            }
          }

          parsedPlans.add(DailyMealPlanModel(
            date: formattedDate,
            planTitle: null,
            meals: meals,
          ));
        }

        // Create sequence meal details
        sequenceMealDetails.value = SequenceMealDetailsModel(
          id: data['_id'] ?? '',
          title: title,
          description: description,
          plans: parsedPlans,
        );

        appBarTitle = title;
        dailyPlans.value = parsedPlans;

        print("✅ Loaded sequence meal details: $title");
        print("   Description: $description");
        print("   Plans count: ${parsedPlans.length}");
        for (var plan in parsedPlans) {
          print("   - Date: ${plan.date}, Meals: ${plan.meals.length}");
        }
      } else {
        print("⚠️ Failed to load sequence meal details");
        _generateDailyPlansFromSelected();
      }
    } catch (e) {
      print("❌ Error fetching sequence meal details: $e");
      _generateDailyPlansFromSelected();
    } finally {
      isLoading.value = false;
    }
  }

  void _generateDailyPlansFromSelected() {
    // Generate daily plans based on selected meal plans
    List<DailyMealPlanModel> generatedPlans = [];

    for (var plan in selectedMealPlans) {
      // If plan has plans data from API, use it
      if (plan.plans.isNotEmpty) {
        for (var seqPlan in plan.plans) {
          // Format date
          String formattedDate = '';
          try {
            final date = DateTime.parse(seqPlan.date);
            final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
            final months = [
              'January', 'February', 'March', 'April', 'May', 'June',
              'July', 'August', 'September', 'October', 'November', 'December'
            ];
            formattedDate = '${days[date.weekday % 7]} ${date.day}, ${months[date.month - 1]}';
          } catch (e) {
            formattedDate = seqPlan.date;
          }

          generatedPlans.add(
            DailyMealPlanModel(
              date: formattedDate,
              planTitle: plan.title,
              meals: seqPlan.mealIds.map((id) =>
                MealItemModel(mealType: "Meal", title: "Recipe $id", servings: "2 Servings")
              ).toList(),
            ),
          );
        }
      } else {
        // Fallback to dummy data
        generatedPlans.add(
          DailyMealPlanModel(
            date: plan.date,
            planTitle: plan.title,
            meals: [
              MealItemModel(mealType: "Breakfast", title: "Meal Plan", servings: "2 Servings"),
              MealItemModel(mealType: "Lunch", title: "Meal Plan", servings: "2 Servings"),
              MealItemModel(mealType: "Dinner", title: "Meal Plan", servings: "2 Servings"),
            ],
          ),
        );
      }
    }

    dailyPlans.value = generatedPlans;
  }

  // Get app bar title based on selected plans
  String getAppBarTitle() {
    if (sequenceMealDetails.value != null) {
      return sequenceMealDetails.value!.title;
    }
    if (appBarTitle.isNotEmpty && appBarTitle != 'Meal Plan Details') {
      return appBarTitle;
    }
    if (selectedMealPlans.isEmpty) {
      return 'Meal Plan Details';
    } else if (selectedMealPlans.length == 1) {
      return selectedMealPlans.first.title;
    } else {
      return '${selectedMealPlans.length} Meal Plans Selected';
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
