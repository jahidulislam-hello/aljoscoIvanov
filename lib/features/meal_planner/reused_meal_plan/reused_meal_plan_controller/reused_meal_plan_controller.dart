
// ================= CONTROLLER =================
import 'package:freshbite/features/meal_planner/reused_meal_plan/reused_meal_plan_model.dart';
import 'package:get/get.dart';

class ReusedMealPlanController extends GetxController {
  var mealPlans = <MealPlanModel>[].obs;

  @override
  void onInit() {
    mealPlans.value = [
      MealPlanModel(
        title: "My Monday Menu",
        description:
        "Lorem Ipsum is simply dump text of the Lorem Ipsum is simply dump text of the...",
        createdBy: "Abc",
        date: "January 18, 2025",
        isSelected: true,
      ),
      MealPlanModel(
        title: "My meal plan for this week",
        description:
        "Lorem Ipsum is simply dump text of the Lorem Ipsum is simply dump text of the...",
        createdBy: "Abc",
        date: "January 15, 2025",
      ),
      MealPlanModel(
        title: "My meal plan for this week",
        description:
        "Lorem Ipsum is simply dump text of the Lorem Ipsum is simply dump text of the...",
        createdBy: "Abc",
        date: "January 12, 2025",
      ),
    ];
    super.onInit();
  }

  void selectMeal(int index) {
    for (var i = 0; i < mealPlans.length; i++) {
      mealPlans[i].isSelected = i == index;
    }
    mealPlans.refresh();
  }
}
