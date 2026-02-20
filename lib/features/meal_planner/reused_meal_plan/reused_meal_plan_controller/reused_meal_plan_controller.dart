
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
        isSelected: false,
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

  // Toggle selection for multiple select
  void toggleSelection(int index) {
    mealPlans[index].isSelected = !mealPlans[index].isSelected;
    mealPlans.refresh();
  }

  // Get all selected meal plans
  List<MealPlanModel> getSelectedMealPlans() {
    return mealPlans.where((plan) => plan.isSelected).toList();
  }

  // Check if any meal plan is selected
  bool hasSelection() {
    return mealPlans.any((plan) => plan.isSelected);
  }

  // Select all
  void selectAll() {
    for (var plan in mealPlans) {
      plan.isSelected = true;
    }
    mealPlans.refresh();
  }

  // Deselect all
  void deselectAll() {
    for (var plan in mealPlans) {
      plan.isSelected = false;
    }
    mealPlans.refresh();
  }
}
