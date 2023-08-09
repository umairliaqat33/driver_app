import 'package:driver_app/utils/colors.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final Color backgroundColor;

  const TextButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
    this.backgroundColor = whiteColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }
}
