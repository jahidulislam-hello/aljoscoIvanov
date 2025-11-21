import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';


class TimeInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const TimeInfoChip({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTextStyles.labelBold.copyWith(
              fontSize: 13.sp,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}