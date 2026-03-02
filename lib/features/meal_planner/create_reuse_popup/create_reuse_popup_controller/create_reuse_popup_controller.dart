import 'package:flutter/material.dart';
import 'package:freshbite/features/meal_planner/create_reuse_popup/create_reuse_popup_model.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/meal_planner_service/meal_planner_service.dart';
import 'package:freshbite/features/meal_planner/reused_meal_plan/reused_meal_plan_controller/reused_meal_plan_controller.dart';
import 'package:get/get.dart';


class CreateReuseController extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Store selected meal IDs for nested meal creation
  List<String> selectedMealIds = [];
  bool isLoading = false;

  void setSelectedMealIds(List<String> ids) {
    selectedMealIds = ids;
  }

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

  Future<void> applyMealPlan() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedMealIds.isEmpty) {
      Get.snackbar(
        "Error",
        "No meals selected",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      // Format date to ISO 8601 UTC
      final isoDate = DateTime.utc(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        8, 0, 0,
      ).toIso8601String();

      print("📤 Creating nested meal:");
      print("   Title: $title");
      print("   Description: $description");
      print("   Date: $isoDate");
      print("   Meals IDs: $selectedMealIds");

      final response = await MealPlannerService.createNestedMeal(
        title: title,
        description: description,
        date: isoDate,
        mealsId: selectedMealIds,
      );

      if (response['success'] == true) {
        print("✅ Nested meal created successfully!");

        // Close the dialog first using Navigator to avoid GetX snackbar issue
        if (Get.context != null) {
          Navigator.of(Get.context!).pop();
        }

        // Refresh the ReusedMealPlanController to show the new meal plan
        if (Get.isRegistered<ReusedMealPlanController>()) {
          final reusedController = Get.find<ReusedMealPlanController>();
          reusedController.deselectAll(); // Clear selections
          await reusedController.fetchSavedSequenceMeals(); // Refresh the list
          print("✅ ReusedMealPlanScreen refreshed with new data");
        }

        // Show success message after dialog is closed
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.snackbar(
            "Success",
            response['messaage'] ?? "Nested Meal Plan Created Successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        });
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to create nested meal",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Error creating nested meal: $e");
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
