import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/features/new/controller/new_recipe_controller.dart';
import 'package:freshbite/features/recepies/recipes_details/recipes_details_controller/recipes_details_controller.dart';
import 'package:get/get.dart';

import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import '../../recepies/recipes_details/recipes_details_model/recipes_details_model.dart';


class IngredientItem extends StatelessWidget {
  final dynamic ingredient; // Accepts both Ingredient and IngredientDetails
  final bool isChecked;
  final ValueChanged<bool?>? onChanged;

  const IngredientItem({
    super.key,
    required this.ingredient,
    this.isChecked = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Try to find the controller, but make it optional
    // Check for both NewRecipeDetailController and RecipesDetailsRecipeController
    final newRecipeController = Get.isRegistered<NewRecipeDetailController>()
        ? Get.find<NewRecipeDetailController>()
        : null;

    final recipeDetailsController = Get.isRegistered<RecipesDetailsRecipeController>()
        ? Get.find<RecipesDetailsRecipeController>()
        : null;

    // Get the unit mode from controller if available
    RxBool? isMetricUnit;
    if (recipeDetailsController != null) {
      isMetricUnit = recipeDetailsController.isMetricUnit;
    }

    // Determine if we should show servings controls (for first ingredient only)
    bool showServingsControls = false;
    if (newRecipeController != null && newRecipeController.recipe.ingredients.first == ingredient) {
      showServingsControls = true;
    } else if (recipeDetailsController != null &&
               recipeDetailsController.recipeDetails.value != null &&
               recipeDetailsController.recipeDetails.value!.ingredients.first == ingredient) {
      showServingsControls = true;
    }

    // Get servings value and functions based on which controller is available
    RxInt? servingsValue;
    VoidCallback? increaseServings;
    VoidCallback? decreaseServings;

    if (newRecipeController != null) {
      servingsValue = newRecipeController.servings;
      increaseServings = newRecipeController.increaseServings;
      decreaseServings = newRecipeController.decreaseServings;
    } else if (recipeDetailsController != null) {
      servingsValue = recipeDetailsController.servings;
      increaseServings = recipeDetailsController.increaseServings;
      decreaseServings = recipeDetailsController.decreaseServings;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showServingsControls && servingsValue != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                "For ${servingsValue!.value} People",
                style: AppTextStyles.HeadBold.copyWith(fontSize: 14.sp),
              )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: AppColors.starYellow,
                  borderRadius: BorderRadius.circular(36.r),
                  border: Border.all(color: AppColors.grey),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: decreaseServings,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Obx(() => Text(
                      "${servingsValue!.value}",
                      style: AppTextStyles.buttonText,
                    )),
                    IconButton(
                      onPressed: increaseServings,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // align to the right
            children: [
              SizedBox(
                width: 110.w, // fixed width
                child: isMetricUnit != null
                    ? Obx(() => DropdownButtonFormField<String>(
                        value: isMetricUnit!.value ? "g/ml" : "Household",
                        items: ["g/ml", "Household"]
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e, textAlign: TextAlign.center),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null && recipeDetailsController != null) {
                            recipeDetailsController.toggleUnitMode(val == "g/ml");
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        isExpanded: true, // ensures text uses full width
                      ))
                    : DropdownButtonFormField<String>(
                        value: "g/ml",
                        items: ["g/ml", "Household"]
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e, textAlign: TextAlign.center),
                                ))
                            .toList(),
                        onChanged: (val) {},
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        isExpanded: true,
                      ),
              ),
            ],
          ),

          SizedBox(height: 25.h),
        ],
        Divider(color: Color(0xFFACACAC), height: 2,),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ingredient.name,
                style: AppTextStyles.buttonText.copyWith(fontSize: 13.sp),
              ),
              // Display quantity based on unit mode
              isMetricUnit != null
                  ? Obx(() {
                      // Check if ingredient has metric/household getters (IngredientDetails type)
                      if (ingredient is IngredientDetails) {
                        return Text(
                          isMetricUnit!.value
                              ? ingredient.metricQuantity
                              : ingredient.householdQuantity,
                          style: AppTextStyles.buttonRegular.copyWith(fontSize: 13.sp),
                        );
                      }
                      // Fallback for other ingredient types
                      return Text(
                        ingredient.quantity,
                        style: AppTextStyles.buttonRegular.copyWith(fontSize: 13.sp),
                      );
                    })
                  : Text(
                      ingredient.quantity,
                      style: AppTextStyles.buttonRegular.copyWith(fontSize: 13.sp),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
