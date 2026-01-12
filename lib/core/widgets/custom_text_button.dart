import 'package:flutter/material.dart';
import 'package:freshbite/core/themes/app_colors.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double? padding;
  final Color? color;      // button color or border color
  final Color? textColor;
  final VoidCallback? onTap;
  final double? radius;
  final bool filled;       // true = filled, false = outlined

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.fontSize,
    this.radius,
    this.textColor,
    this.padding,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;

    final Color mainColor = color ?? AppColors.buttonColor;
    final Color effectiveTextColor =
        textColor ?? (filled ? Colors.white : mainColor);

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(padding ?? sizeH * .015),
        backgroundColor: filled ? mainColor : Colors.white,
        fixedSize: const Size.fromWidth(double.maxFinite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? sizeH * .01),
          side: filled
              ? BorderSide.none
              : BorderSide(color: mainColor, width: 2), // outline border
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: effectiveTextColor,
          fontSize: fontSize ?? sizeH * .021,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
