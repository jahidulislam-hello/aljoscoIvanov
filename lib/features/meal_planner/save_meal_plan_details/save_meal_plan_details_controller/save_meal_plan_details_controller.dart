
// ================= CONTROLLER =================
import 'package:freshbite/features/meal_planner/save_meal_plan_details/save_meal_plan_details_model.dart';
import 'package:get/get.dart';

class SavedMealPlanDetailsController extends GetxController {
  var dailyPlans = <DailyMealPlanModel>[].obs;

  @override
  void onInit() {
    dailyPlans.value = [
      DailyMealPlanModel(
        date: "Sunday 18, January",
        meals: [
          MealItemModel(mealType: "Breakfast", title: "Tomato Soup", servings: "4 Servings"),
          MealItemModel(mealType: "Lunch", title: "Tomato Soup", servings: "4 Servings"),
          MealItemModel(mealType: "Dinner", title: "Tomato Soup", servings: "4 Servings"),
        ],
      ),
      DailyMealPlanModel(
        date: "Monday 19, January",
        meals: [
          MealItemModel(mealType: "Breakfast", title: "Tomato Soup", servings: "4 Servings"),
          MealItemModel(mealType: "Lunch", title: "Tomato Soup", servings: "4 Servings"),
          MealItemModel(mealType: "Dinner", title: "Tomato Soup", servings: "4 Servings"),
        ],
      ),
    ];
    super.onInit();
  }
}