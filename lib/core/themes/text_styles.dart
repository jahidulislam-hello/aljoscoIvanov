import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static final String _fontFamily = GoogleFonts.rubik().fontFamily!;

  static final TextStyle H1_Regular = TextStyle(
    fontSize: 40.sp,
    fontWeight: FontWeight.w700,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaulttext,
    letterSpacing: 0,
  );

  static final TextStyle H2_Regular = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w700,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaulttext,
    letterSpacing: 0,

  );

  static final TextStyle H3_Regular = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w500,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaulttext,
    letterSpacing: 0,
  );

  static final TextStyle H4_Regular = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w500,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaulttext,
    letterSpacing: 0,
  );

  static final TextStyle HeadBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaulttext,
    letterSpacing: 0,
  );

  static final TextStyle H5_Regular = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaulttext,
    letterSpacing: 0,
  );

  static final TextStyle H6_Regular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaulttext,
    letterSpacing: 0,
  );

  static final TextStyle buttonText = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaulttext,
    letterSpacing: 0,
  );

  static final TextStyle body = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaulttext,
    letterSpacing: 0,
  );

  static final TextStyle bioText = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaulttext,
    letterSpacing: 0,
  );

  static final TextStyle buttonRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: GoogleFonts.rubik().fontFamily,
    color: AppColors.defaulttext,
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
    fontWeight: FontWeight.w600,
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
    fontWeight: FontWeight.w500,
    color: AppColors.defaulttext,
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

  static TextStyle h1 = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle h2 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle h3 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle h4 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle buttonSmall = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static TextStyle captionBold = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  // Label Styles
  static TextStyle label = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle labelBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 3,
  );


  /// ===============================
  /// MEDIUM (FontWeight.w500)
  /// ===============================

  static final TextStyle medium24 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    height: 1,
    letterSpacing: 0,
    color: AppColors.defaultText,
  );

  static final TextStyle medium20 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    height: 24 / 20,
    letterSpacing: 0,
    color: AppColors.defaultText,
  );

  static final TextStyle medium18 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    height: 22 / 18,
    letterSpacing: 0,
    color: AppColors.defaultText,
  );

  static final TextStyle medium16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    height: 1,
    letterSpacing: 0,
    color: AppColors.defaultText,
  );

  static final TextStyle medium16Caps = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    height: 1,
    letterSpacing: 0,
    color: AppColors.defaultText,
  );

  static final TextStyle medium14 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    height: 1,
    letterSpacing: -0.005 * 14,
    color: AppColors.defaultText,
  );

  /// ===============================
  /// REGULAR (FontWeight.w400)
  /// ===============================

  static final TextStyle regular16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    height: 1,
    letterSpacing: 0,
    color: AppColors.defaultText,
  );

  static final TextStyle regular14 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    height: 1,
    letterSpacing: -0.005 * 14,
    color: AppColors.defaultText,
  );

  static final TextStyle regular12 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    height: 1,
    letterSpacing: -0.005 * 12,
    color: AppColors.defaultText,
  );

  static final TextStyle regular10 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    height: 1,
    letterSpacing: 0,
    color: AppColors.defaultText,
  );

  /// ===============================
  /// SEMIBOLD (FontWeight.w600)
  /// ===============================

  static final TextStyle semi24 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    height: 1,
    letterSpacing: 0,
    color: AppColors.defaultText,
  );

  static final TextStyle semi20 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    height: 30 / 20,
    letterSpacing: 0,
    color: AppColors.defaultText,
  );

  static final TextStyle semi18 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    height: 1,
    letterSpacing: 0,
    color: AppColors.defaultText,
  );

  static final TextStyle semi16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    height: 20 / 16,
    letterSpacing: 0,
    color: AppColors.defaultText,
  );

  static final TextStyle semi14 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    height: 1.25,
    letterSpacing: 0,
    color: AppColors.defaultText,
  );
}
