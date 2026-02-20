
// ================= CONTROLLER =================
import 'package:freshbite/features/meal_planner/reused_meal_plan/reused_meal_plan_model.dart';
import 'package:freshbite/features/meal_planner/save_meal_plan_details/save_meal_plan_details_model.dart';
import 'package:get/get.dart';

class SavedMealPlanDetailsController extends GetxController {
  var dailyPlans = <DailyMealPlanModel>[].obs;
  var selectedMealPlans = <MealPlanModel>[].obs;

  void setSelectedMealPlans(List<MealPlanModel> plans) {
    selectedMealPlans.value = plans;
    _generateDailyPlansFromSelected();
  }

  void _generateDailyPlansFromSelected() {
    // Generate daily plans based on selected meal plans
    List<DailyMealPlanModel> generatedPlans = [];

    for (var plan in selectedMealPlans) {
      generatedPlans.add(
        DailyMealPlanModel(
          date: plan.date,
          planTitle: plan.title,
          meals: [
            MealItemModel(mealType: "Breakfast", title: "Tomato Soup", servings: "4 Servings"),
            MealItemModel(mealType: "Lunch", title: "Grilled Chicken", servings: "2 Servings"),
            MealItemModel(mealType: "Dinner", title: "Pasta Primavera", servings: "4 Servings"),
          ],
        ),
      );
    }

    dailyPlans.value = generatedPlans;
  }

  // Get app bar title based on selected plans
  String getAppBarTitle() {
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
    // Initialize with dummy data if no plans are passed
    if (dailyPlans.isEmpty) {
      dailyPlans.value = [
        DailyMealPlanModel(
          date: "Sunday 18, January",
          planTitle: "My meal plan",
          meals: [
            MealItemModel(mealType: "Breakfast", title: "Tomato Soup", servings: "4 Servings"),
            MealItemModel(mealType: "Lunch", title: "Tomato Soup", servings: "4 Servings"),
            MealItemModel(mealType: "Dinner", title: "Tomato Soup", servings: "4 Servings"),
          ],
        ),
        DailyMealPlanModel(
          date: "Monday 19, January",
          planTitle: "My meal plan",
          meals: [
            MealItemModel(mealType: "Breakfast", title: "Tomato Soup", servings: "4 Servings"),
            MealItemModel(mealType: "Lunch", title: "Tomato Soup", servings: "4 Servings"),
            MealItemModel(mealType: "Dinner", title: "Tomato Soup", servings: "4 Servings"),
          ],
        ),
      ];
    }
    super.onInit();
  }
}
