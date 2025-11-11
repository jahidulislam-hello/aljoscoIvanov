import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static final TextStyle H1_Regular = TextStyle(
    fontSize: 40.sp,
    fontWeight: FontWeight.w700,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaultTextColor,
    letterSpacing: 0,
  );

  static final TextStyle H2_Regular = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w700,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaultTextColor,
    letterSpacing: 0,
  );

  static final TextStyle H3_Regular = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w500,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaultTextColor,
    letterSpacing: 0,
  );

  static final TextStyle H4_Regular = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w500,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaultTextColor,
    letterSpacing: 0,
  );

  static final TextStyle HeadBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaultTextColor,
    letterSpacing: 0,
  );

  static final TextStyle H5_Regular = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaultTextColor,
    letterSpacing: 0,
  );

  static final TextStyle H6_Regular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaultTextColor,
    letterSpacing: 0,
  );

  static final TextStyle buttonText = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaultTextColor,
    letterSpacing: 0,
  );

  static final TextStyle body = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaultTextColor,
    letterSpacing: 0,
  );

  static final TextStyle bioText = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaultTextColor,
    letterSpacing: 0,
  );

  static final TextStyle buttonRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaultTextColor,
    letterSpacing: 0,
  );

  static final TextStyle heading1 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: GoogleFonts.rubik().fontFamily,
  );

  static final TextStyle heading2 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: GoogleFonts.rubik().fontFamily,
  );

  static final TextStyle heading3 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: GoogleFonts.rubik().fontFamily,
  );

  static final TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    fontFamily: GoogleFonts.rubik().fontFamily,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    fontFamily: GoogleFonts.rubik().fontFamily,
  );

  static final TextStyle bodySmall = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    fontFamily: GoogleFonts.rubik().fontFamily,
  );

  static final TextStyle button = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    fontFamily: GoogleFonts.rubik().fontFamily,
  );

  static final TextStyle caption = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    fontFamily: GoogleFonts.rubik().fontFamily,
  );
}
