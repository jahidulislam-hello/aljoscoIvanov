import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';

class TimeInfoChip extends StatelessWidget {
  final String totalTime;
  final String prepTime;
  final String cookTime;

  const TimeInfoChip({
    Key? key,
    required this.totalTime,
    required this.prepTime,
    required this.cookTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total Time
          Column(
            children: [
              Text(
                'Total Time',
                style: AppTextStyles.semi14.copyWith(color: AppColors.green900),
              ),
              SizedBox(height: 4.h),
              Text(
                totalTime,
                style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
              ),
            ],
          ),

          // Prep Time
          Column(
            children: [
              Text(
                'Prep Time',
                style: AppTextStyles.semi14.copyWith(color: AppColors.green900),
              ),
              SizedBox(height: 4.h),
              Text(
                prepTime,
                style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
              ),
            ],
          ),

          // Cook Time
          Column(
            children: [
              Text(
                'Cook Time',
                style: AppTextStyles.semi14.copyWith(color: AppColors.green900),
              ),
              SizedBox(height: 4.h),
              Text(
                cookTime,
                style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
