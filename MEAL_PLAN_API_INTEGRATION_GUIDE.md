# Meal Plan API Integration Guide

## Overview
This guide shows how to integrate the meal plan APIs for:
1. **GET meal plans** for a specific date
2. **POST create meal plan** from the AddPlanningPopup

## API Endpoints Already Integrated

### 1. Get Meal Plan (Already Working ✅)
**Endpoint:** `{{baseUrl}}/mealplan/get-meal-plan`
**Method:** POST
**Location:** `MealPlannerService.getMealPlan(date)`
**Controller Method:** `MealPlanController.fetchMealPlansForDate(date)`

The controller already calls this API correctly. No changes needed.

### 2. Create Meal Plan (Already Working ✅)
**Endpoint:** `{{baseUrl}}/mealplan/create-meal`
**Method:** POST
**Location:** `MealPlannerService.createMealPlan()`
**Controller Method:** `MealPlanController.createMealPlan()`

The controller already calls this API correctly. No changes needed.

## How to Add "Add Recipe" Button to Meal Sections

### Step 1: Add Button to UI

In your meal plan screen where you display `MealSection` items, add an "Add Recipe" button:

```dart
// Inside your meal section widget
Widget buildMealSection(MealSection section) {
  return Column(
    children: [
      // ... existing meal section UI ...

      // Add Recipe Button
      if (section.recipe == null)
        ElevatedButton.icon(
          onPressed: () => _showRecipeSelectionDialog(section),
          icon: Icon(Icons.add),
          label: Text('Add Recipe'),
        ),

      // Or if you want a styled button:
      if (section.recipe == null)
        GestureDetector(
          onTap: () => _showRecipeSelectionDialog(section),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF2D4A2B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Add Recipe',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}
```

### Step 2: Show Recipe Selection Dialog

```dart
import 'package:freshbite/features/meal_planner/meal_planner_new/select_meal_popup/selact_meal_popup_screen/select_meal_popup_screen.dart';

void _showRecipeSelectionDialog(MealSection section) async {
  // Get the meal plan controller
  final mealPlanController = Get.find<MealPlanController>();

  // Show recipe selection popup
  final selectedRecipe = await Get.dialog<SelectMealPopupModel>(
    SelectMealPopupScreen(),
  );

  if (selectedRecipe != null) {
    // Store the selected recipe ID
    mealPlanController.selectedRecipeId = selectedRecipe.id;

    // Show the planning popup
    _showPlanningPopup(selectedRecipe, section);
  }
}
```

### Step 3: Show Planning Popup

```dart
import 'package:freshbite/features/meal_planner/meal_planner_new/widget/meal_planner_popup_add.dart';

void _showPlanningPopup(SelectMealPopupModel recipe, MealSection section) {
  final mealPlanController = Get.find<MealPlanController>();
  final currentDate = getCurrentSelectedDate(); // Your method to get current date

  Get.dialog(
    AddPlanningPopup(
      recipeName: recipe.title,
      recipeImage: recipe.images.isNotEmpty ? recipe.images[0] : null,
      onAddToMealPlan: (mealItems, prepItems, cookPerson) async {
        // Call the controller's createMealPlan method
        final success = await mealPlanController.createMealPlan(
          recipeId: mealPlanController.selectedRecipeId!,
          mealItems: mealItems,
          prepItems: prepItems,
          cookPerson: cookPerson,
        );

        if (success) {
          // Refresh the UI for the current date
          await mealPlanController.fetchMealPlansForDate(currentDate);
        }

        return success;
      },
    ),
  );
}
```

## Complete Example Integration

Here's a complete example showing how to integrate this in your meal plan screen:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/meal_planner_all_controller/meal_planner_all_controller.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/select_meal_popup/selact_meal_popup_screen/select_meal_popup_screen.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/select_meal_popup/select_meal_popup_model/select_meal_popup_model.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/widget/meal_planner_popup_add.dart';

class MealPlanScreen extends StatelessWidget {
  final MealPlanController controller = Get.put(MealPlanController());
  final String currentDate = '2025-11-15'; // Your current selected date

  @override
  Widget build(BuildContext context) {
    // Load meal plans when screen opens
    controller.fetchMealPlansForDate(currentDate);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.meals.length,
          itemBuilder: (context, index) {
            final meal = controller.meals[index];
            return _buildMealCard(meal);
          },
        );
      }),
    );
  }

  Widget _buildMealCard(MealSection meal) {
    return Card(
      child: Column(
        children: [
          // Meal title
          Text(meal.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          // Show recipe if exists
          if (meal.recipe != null)
            ListTile(
              leading: meal.recipe!.imageUrl != null
                ? Image.network(meal.recipe!.imageUrl!, width: 60, height: 60, fit: BoxFit.cover)
                : Icon(Icons.restaurant),
              title: Text(meal.recipe!.name),
              subtitle: Text(meal.recipe!.servings),
            ),

          // Add Recipe button
          if (meal.recipe == null)
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () => _handleAddRecipe(meal),
                icon: Icon(Icons.add),
                label: Text('Add Recipe'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2D4A2B),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleAddRecipe(MealSection section) async {
    // Step 1: Show recipe selection dialog
    final selectedRecipe = await Get.dialog<SelectMealPopupModel>(
      SelectMealPopupScreen(),
    );

    if (selectedRecipe == null) return;

    // Step 2: Store selected recipe ID
    controller.selectedRecipeId = selectedRecipe.id;

    // Step 3: Show planning popup
    Get.dialog(
      AddPlanningPopup(
        recipeName: selectedRecipe.title,
        recipeImage: selectedRecipe.images.isNotEmpty ? selectedRecipe.images[0] : null,
        onAddToMealPlan: (mealItems, prepItems, cookPerson) async {
          // Create meal plan via API
          final success = await controller.createMealPlan(
            recipeId: controller.selectedRecipeId!,
            mealItems: mealItems,
            prepItems: prepItems,
            cookPerson: cookPerson,
          );

          if (success) {
            // Refresh meal plans for current date
            await controller.fetchMealPlansForDate(currentDate);

            Get.snackbar(
              'Success',
              'Meal plan created successfully!',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          }

          return success;
        },
      ),
    );
  }
}
```

## API Request/Response Flow

### 1. When User Clicks "Add Recipe"

```
User clicks "Add Recipe"
  → Show SelectMealPopupScreen
  → User selects recipe
  → Store recipe ID in controller.selectedRecipeId
  → Show AddPlanningPopup
```

### 2. When User Fills Planning Details and Clicks "ADD TO MEAL PLAN"

```
User fills:
- Meal times (day, meal, servings)
- Prep details (day, servings)
- Cook person

  → AddPlanningPopup calls onAddToMealPlan callback
  → Controller.createMealPlan() is called
  → API Request sent to /mealplan/create-meal:

{
  "recipes": "60c72b2f9a1d4e4c91c63e94",
  "prepList": {
    "date": "2025-11-15T08:00:00.000Z",
    "serving": 2,
    "cooker": "me"
  },
  "meals": [
    {
      "date": "2025-11-15T08:00:00.000Z",
      "serving": 2,
      "meal_time": "breakfast"
    }
  ]
}

  → API Response received
  → Controller stores meal plans locally
  → UI refreshes to show new meal plan
```

## Important Notes

1. **Recipe ID**: The `selectedRecipeId` must be set before calling `createMealPlan()`
2. **Date Format**: Dates are automatically converted to ISO 8601 format by the controller
3. **Meal Time**: Meal times are automatically converted to lowercase (breakfast, lunch, dinner, snack)
4. **Duplicate Prevention**: The AddPlanningPopup validates for duplicate meal times on the same day
5. **Loading States**: Both dialogs show loading indicators during API calls

## Troubleshooting

### "Recipe ID is null" Error
- Make sure to set `controller.selectedRecipeId` after selecting a recipe
- Check that `SelectMealPopupScreen` returns a `SelectMealPopupModel` with valid ID

### "Validation Error: Duplicate meal detected"
- This means user tried to add the same meal type (e.g., Breakfast) on the same day twice
- User must choose different dates or meal types

### API Returns 400 Error
- Check that all required fields are filled
- Verify date format is correct (ISO 8601)
- Ensure recipe ID exists in the database

## Summary

The meal plan API integration is **already complete** in your controller! You just need to:

1. Add an "Add Recipe" button to each meal section in your UI
2. When clicked, show `SelectMealPopupScreen` to choose a recipe
3. Store the selected recipe ID in `controller.selectedRecipeId`
4. Show `AddPlanningPopup` with the callback to `controller.createMealPlan()`
5. The controller handles all API calls and data storage automatically

Your controller already has all the necessary functionality:
- ✅ GET meal plans for a date (`fetchMealPlansForDate`)
- ✅ POST create meal plan (`createMealPlan`)
- ✅ Local storage caching
- ✅ Date normalization
- ✅ Error handling
- ✅ Loading states

You're ready to go! 🎉
