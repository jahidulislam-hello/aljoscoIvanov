import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';



class NutritionInfoCard extends StatelessWidget {
  final dynamic nutritionInfo; // Accepts both NutritionInfo and NutritionInfoDetails

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
        children: [
          _buildRow("Energy (kJ / kcal)", nutritionInfo.energy),
          _divider(),
          _buildRow("Fat", nutritionInfo.fat),
          _divider(),
          _buildRow("- of which Saturates", nutritionInfo.saturated),
          _divider(),
          _buildRow("Carbohydrate", nutritionInfo.carbs),
          _divider(),
          _buildRow("- of which Sugars", nutritionInfo.sugars),
          _divider(),
          _buildRow("Fibre", nutritionInfo.fibre),
          _divider(),
          _buildRow("Protein", nutritionInfo.protein),
          _divider(),
          _buildRow("Salt", nutritionInfo.salt),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
    color: AppColors.defaultTextColor,
    thickness: 1,
    height: 14.h,
  );

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mainTextColor,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.labelBold,
        ),
      ],
    );
  }
}
