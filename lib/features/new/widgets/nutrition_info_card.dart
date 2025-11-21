import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/new/model/new_recipe_model.dart';


class NutritionInfoCard extends StatelessWidget {
  final NutritionInfo nutritionInfo;

  const NutritionInfoCard({
    Key? key,
    required this.nutritionInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition (Typical Values Per Serving)',
            style: AppTextStyles.h4.copyWith(fontSize: 15.sp),
          ),
          SizedBox(height: 16.h),
          _buildNutritionRow('Energy Per Meal', '${nutritionInfo.calories} kcal'),
          _buildNutritionRow('of which Protein', '${nutritionInfo.protein} g'),
          _buildNutritionRow('Carbohydrates', '${nutritionInfo.carbs} g'),
          _buildNutritionRow('of which Sugars', '7.8 g'),
          _buildNutritionRow('Fat', '${nutritionInfo.fat} g'),
          _buildNutritionRow('Salt', '0.7 g'),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.labelBold,
          ),
        ],
      ),
    );
  }
}