import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';

class TitleChip extends StatelessWidget {
  final String titlechip;

  const TitleChip({
    Key? key,
    required this.titlechip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isProtein = titlechip.toLowerCase() == "protein";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.titleChip,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isProtein) ...[
            Image.asset(
              'assets/icons/protein.png',
              width: 14.w,
              height: 14.w,
            ),
            SizedBox(width: 6.w),
          ],
          Text(
            titlechip,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mainTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
