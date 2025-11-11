import 'package:get/get.dart';
import '../model/meal_planner_model.dart';

class MealPlannerController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var selectedTab = 0.obs; // 0 = Meal Plan, 1 = Prep List
  var mealPlans = <MealPlannerModel>[].obs;

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void switchTab(int index) {
    selectedTab.value = index;
  }

  void addMealPlan(MealPlannerModel plan) {
    mealPlans.add(plan);
  }

  List<MealPlannerModel> getPlansForSelectedDate() {
    return mealPlans.where((e) =>
    e.date.year == selectedDate.value.year &&
        e.date.month == selectedDate.value.month &&
        e.date.day == selectedDate.value.day).toList();
  }
}
