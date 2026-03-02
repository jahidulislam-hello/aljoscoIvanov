
// ================= CONTROLLER =================
import 'package:flutter/material.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/meal_planner_service/meal_planner_service.dart';
import 'package:freshbite/features/meal_planner/reused_meal_plan/reused_meal_plan_model.dart';
import 'package:get/get.dart';

class ReusedMealPlanController extends GetxController {
  var mealPlans = <MealPlanModel>[].obs;
  var isCreatingSequenceMeal = false.obs;
  var isLoadingMealPlans = false.obs;

  // Data for creating sequence meal plan
  String sequenceTitle = '';
  String sequenceDescription = '';
  List<Map<String, dynamic>> sequencePlansData = [];

  @override
  void onInit() {
    super.onInit();
    // Fetch saved sequence meals from API
    fetchSavedSequenceMeals();
  }

  /// Fetch saved sequence meals from API
  Future<void> fetchSavedSequenceMeals() async {
    try {
      isLoadingMealPlans.value = true;

      final response = await MealPlannerService.getSequenceMeals();

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        mealPlans.value = data
            .map((json) => MealPlanModel.fromJson(json))
            .toList();

        print("✅ Loaded ${mealPlans.length} saved meal plans from API");
      } else {
        print("⚠️ No saved meal plans found");
        mealPlans.clear();
      }
    } catch (e) {
      print("❌ Error fetching saved meal plans: $e");
      // Keep empty list on error
      mealPlans.clear();
    } finally {
      isLoadingMealPlans.value = false;
    }
  }

  // Set sequence meal data from MultipleDialogSheet
  void setSequenceMealData(String title, String description, List<Map<String, dynamic>> plansData) {
    sequenceTitle = title;
    sequenceDescription = description;
    sequencePlansData = plansData;
    print("📋 Sequence meal data set:");
    print("   Title: $sequenceTitle");
    print("   Description: $sequenceDescription");
    print("   Plans: $sequencePlansData");
  }

  // Create sequence meal plan via API
  Future<void> createSequenceMealPlan() async {
    print("🚀 createSequenceMealPlan called");
    print("   Title: $sequenceTitle");
    print("   Description: $sequenceDescription");
    print("   PlansData: $sequencePlansData");

    if (sequenceTitle.isEmpty || sequenceDescription.isEmpty) {
      Get.snackbar(
        "Error",
        "Missing title or description",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // If no plans data from selected dates, use today's date as default
    List<Map<String, dynamic>> plansToSend = sequencePlansData;
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

    print("📤 Sending to API: title=$sequenceTitle, plans=$plansToSend");

    try {
      isCreatingSequenceMeal.value = true;

      final response = await MealPlannerService.createSequenceMeal(
        title: sequenceTitle,
        description: sequenceDescription,
        plans: plansToSend,
      );

      print("📥 API Response: $response");

      if (response['success'] == true) {
        print("✅ Sequence meal created successfully!");

        // Clear the data first
        sequenceTitle = '';
        sequenceDescription = '';
        sequencePlansData = [];

        // Refresh the list to show the new meal plan
        print("🔄 Refreshing meal plans list...");
        await fetchSavedSequenceMeals();
        print("✅ Meal plans list refreshed, count: ${mealPlans.length}");

        // Show success message
        Get.snackbar(
          "Success",
          response['messaage'] ?? "Saved Meal Plan Created Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Don't navigate back - stay on the screen to see the new plan
      } else {
        print("❌ API returned error: ${response['message']}");
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to create meal plan",
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
      isCreatingSequenceMeal.value = false;
    }
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

  // Get selected meal plan IDs
  List<String> getSelectedMealPlanIds() {
    return mealPlans
        .where((plan) => plan.isSelected && plan.id.isNotEmpty)
        .map((plan) => plan.id)
        .toList();
  }

  // Create nested meal from multiple selected saved meal plans
  var isCreatingNestedMeal = false.obs;

  Future<bool> createNestedMeal() async {
    final selectedPlans = getSelectedMealPlans();
    if (selectedPlans.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select at least one meal plan",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Collect all meal IDs from selected plans
    List<String> allMealIds = [];
    for (var plan in selectedPlans) {
      for (var seqPlan in plan.plans) {
        allMealIds.addAll(seqPlan.mealIds);
      }
    }

    // If no meal IDs found, use the plan IDs as fallback
    if (allMealIds.isEmpty) {
      allMealIds = getSelectedMealPlanIds();
    }

    if (allMealIds.isEmpty) {
      Get.snackbar(
        "Error",
        "No meals found in selected plans",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      isCreatingNestedMeal.value = true;

      // Use the first selected plan's title and description
      final firstPlan = selectedPlans.first;
      final now = DateTime.now();
      final isoDate = DateTime.utc(now.year, now.month, now.day, 8, 0, 0).toIso8601String();

      final response = await MealPlannerService.createNestedMeal(
        title: firstPlan.title,
        description: firstPlan.description,
        date: isoDate,
        mealsId: allMealIds,
      );

      if (response['success'] == true) {
        Get.snackbar(
          "Success",
          response['messaage'] ?? "Nested Meal Plan Created Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to create nested meal",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
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
      return false;
    } finally {
      isCreatingNestedMeal.value = false;
    }
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
