import 'package:flutter/material.dart';
import 'package:freshbite/core/themes/app_colors.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double? padding;
  final Color? color;
  final Color? textColor;
  final Function onTap;
  final double? radius;
  const CustomTextButton({
    super.key,
    required this.text,
    this.color,
    required this.onTap,
    this.fontSize,
    this.radius,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return TextButton(
        onPressed: () {
          onTap();
        },
        style: TextButton.styleFrom(
            padding: EdgeInsets.all(padding ?? sizeH * .015),
            backgroundColor: color ?? AppColors.buttonColor,
            fixedSize: const Size.fromWidth(double.maxFinite),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? sizeH * .01))),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: sizeH * .021,
              fontWeight: FontWeight.w500),
        ));
  }
}
