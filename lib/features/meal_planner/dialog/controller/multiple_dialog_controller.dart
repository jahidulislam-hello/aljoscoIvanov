import 'package:flutter/material.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/meal_planner_service/meal_planner_service.dart';
import 'package:freshbite/features/meal_planner/reused_meal_plan/reused_meal_plan_screen/reused_meal_plan_screen.dart';
import 'package:get/get.dart';

class MultipleDialogController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final isLoading = false.obs;

  // Selected dates with their meal IDs
  List<Map<String, dynamic>> selectedPlansData = [];

  void setSelectedPlansData(List<Map<String, dynamic>> data) {
    selectedPlansData = data;
  }

  Future<void> saveMealPlan() async {
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

    // If no plans data from selected dates, use today's date as default
    List<Map<String, dynamic>> plansToSend = selectedPlansData;
    if (plansToSend.isEmpty) {
      final now = DateTime.now();
      final isoDate = DateTime.utc(now.year, now.month, now.day, 8, 0, 0).toIso8601String();
      plansToSend = [
        {
          'date': isoDate,
          'meals': [],
        }
      ];
    }

    try {
      isLoading.value = true;

      print("🚀 Creating sequence meal from MultipleDialogSheet...");
      print("   Title: $title");
      print("   Description: $description");
      print("   Plans: $plansToSend");

      final response = await MealPlannerService.createSequenceMeal(
        title: title,
        description: description,
        plans: plansToSend,
      );

      print("📥 API Response: $response");

      if (response['success'] == true) {
        print("✅ Sequence meal created successfully!");

        // Close the bottom sheet using Navigator to avoid GetX snackbar issue
        Navigator.of(Get.context!).pop();

        // Show success message
        Get.snackbar(
          "Success",
          response['messaage'] ?? "Meal Plan Saved Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to ReusedMealPlanScreen to show the list
        Get.to(() => const ReusedMealPlanScreen());
      } else {
        print("❌ API returned error: ${response['message']}");
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to save meal plan",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Error creating sequence meal: $e");
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}