import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';


class AllergenChip extends StatelessWidget {
  final String allergen;

  const AllergenChip({
    Key? key,
    required this.allergen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        allergen,
        style: AppTextStyles.regular16.copyWith(
          color: AppColors.grey200,
        ),
      ),
    );
  }
}