import 'package:flutter/material.dart';
import 'package:freshbite/features/meal_planner/create_reuse_popup/create_reuse_popup_model.dart';


class CreateReuseController extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  MealPlanModel getMealPlan() {
    return MealPlanModel(
      title: titleController.text,
      description: descriptionController.text,
      startDate: selectedDate,
    );
  }

  void applyMealPlan() {
    final mealPlan = getMealPlan();
    // Handle save or API call here
    print('Meal Plan Saved: ${mealPlan.title}, ${mealPlan.description}, ${mealPlan.startDate}');
  }
}
