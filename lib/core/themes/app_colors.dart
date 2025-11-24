import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFFE8EAE6);
  static const Color defaultbackground = Color(0xFF1A1A1A);
  static const Color buttonColor = Color(0xFF1C2D07);
  static const Color mainTextColor = Color(0xFF4A4A4A);
  static const Color defaultTextColor = Color(0xFFACACAC);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color borderSecondary = Color(0xFF1C2D07);
  static const Color text = Color(0xFF1F1F1F);
  static const Color primary = Color(0xFF1FCC79);
  static const Color secondary = Color(0xFFFF6464);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF2E3E5C);
  static const Color grey = Color(0xFF9FA5C0);
  static const Color darkGrey = Color(0xFF3E5481);
  static const Color lightGrey = Color(0xFFD0DBEA);
  static const Color textPrimary = Color(0xFF0C1303);
  static const Color textSecondary = Color(0xFF9FA5C0);
  static const Color defaulttext = Color(0xFF142005);

  static const Color primaryDark = Color(0xFF1A3D28);
  static const Color primaryLight = Color(0xFF4A8157);
  static const Color titleChip = Color(0xFFEDEDED);
  static const Color rateborder = Color(0xFFC7C7C7);

  // Accent Colors
  static const Color accent = Color(0xFFE8B86D);


  static const Color cardBackground = Colors.white;


  static const Color textLight = Color(0xFF9E9E9E);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);

  // Star Rating
  static const Color starYellow = Color(0xFFFAF9F6);

  // Status Colors
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFB8C00);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}