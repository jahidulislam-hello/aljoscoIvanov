
import 'package:flutter/material.dart';

class StyleTextButton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final Color? textColor;
  final Function onTap;
  final double? radius;
  const StyleTextButton({
    super.key,
    required this.text,
    this.color,
    required this.onTap,
    this.fontSize,
    this.radius,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return TextButton(
        onPressed: () {
          onTap();
        },
        child: Text(
          text,
          style: TextStyle(
              color: const Color(0xffF48460),
              fontSize: sizeH * .018,
              fontWeight: FontWeight.w500),
        ));
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double? padding;
  final Color? color;
  final Color? textColor;
  final Function onTap;
  final double? radius;
  const CustomButton({
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
            backgroundColor: color ?? Colors.transparent,
            side: const BorderSide(color: Colors.white),
            fixedSize: const Size.fromWidth(double.maxFinite),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? sizeH * .017))),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: sizeH * .021,
              fontWeight: FontWeight.w500),
        ));
  }
}