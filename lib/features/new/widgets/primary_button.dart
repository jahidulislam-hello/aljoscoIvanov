import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';


class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 52.h,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w),
        ),
        child: isLoading
            ? SizedBox(
          width: 24.w,
          height: 24.w,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          text,
          style: AppTextStyles.button,
        ),
      ),
    );
  }
}