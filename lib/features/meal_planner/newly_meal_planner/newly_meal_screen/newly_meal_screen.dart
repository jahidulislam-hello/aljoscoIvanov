import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/features/meal_planner/newly_meal_planner/add_edit_recipe_dialog.dart';
import 'package:freshbite/features/meal_planner/newly_meal_planner/meal_section.dart';
import 'package:freshbite/features/meal_planner/newly_meal_planner/message_bottom_sheet.dart';
import 'package:freshbite/features/meal_planner/newly_meal_planner/model.dart';
import 'package:freshbite/features/meal_planner/newly_meal_planner/newly_meal_controller/newly_meal_controller.dart';
import 'package:get/get.dart';


class NewlyMealScreen extends StatelessWidget {
  NewlyMealScreen({Key? key}) : super(key: key);
  final NewlyMealController ctrl = Get.put(NewlyMealController());

  final List<Map<String, String>> order = [
    {'key': 'breakfast', 'label': 'Breakfast'},
    {'key': 'snack1', 'label': 'Snack'},
    {'key': 'lunch', 'label': 'Lunch'},
    {'key': 'snack2', 'label': 'Snack'},
    {'key': 'dinner', 'label': 'Dinner'},
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Meal Plan')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: order
              .map((m) => Obx(() {
            final key = m['key']!;
            return NewMealSection(
              title: m['label']!,
              isExpanded: ctrl.expanded[key]!.value,
              onEyeTap: () => ctrl.toggleExpand(key),
              recipes: ctrl.meals[key]!.toList(),
              onAdd: () async {
                // open add dialog -> returns MealModel
                final result = await showDialog<NewMealModel>(
                  context: context,
                  builder: (_) => AddEditRecipeDialog(
                    initial: ctrl.createNewRecipe(title: '', subtitle: '', imageAsset: 'assets/tomato_soup.jpg'),
                    isEditing: false,
                  ),
                );
                if (result != null) {
                  ctrl.addRecipe(key, result);
                }
              },
              onEdit: (recipe) async {
                final edited = await showDialog<NewMealModel>(
                  context: context,
                  builder: (_) => AddEditRecipeDialog(initial: recipe, isEditing: true),
                );
                if (edited != null) {
                  ctrl.editRecipe(key, recipe.id, edited);
                }
              },
              onMessage: (recipe) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => MessageBottomSheet(recipeTitle: recipe.title),
                );
              },
              onRemove: (recipe) {
                ctrl.removeRecipe(key, recipe.id);
              },
            );
          }))
              .toList(),
        ),
      ),
    );
  }
}
