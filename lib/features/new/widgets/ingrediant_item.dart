import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';

import '../model/new_recipe_model.dart';

class IngredientItem extends StatelessWidget {
  final Ingredient ingredient;
  final bool isChecked;
  final ValueChanged<bool?>? onChanged; // Changed from ValueChanged<bool>? to ValueChanged<bool?>?

  const IngredientItem({
    Key? key,
    required this.ingredient,
    this.isChecked = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.1,
            child: Checkbox(
              value: isChecked,
              onChanged: onChanged,
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              ingredient.name,
              style: AppTextStyles.bodyMedium.copyWith(
                decoration: isChecked ? TextDecoration.lineThrough : null,
                color: isChecked
                    ? AppColors.textLight
                    : AppColors.textPrimary,
              ),
            ),
          ),
          if (ingredient.quantity.isNotEmpty)
            Text(
              ingredient.quantity,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}