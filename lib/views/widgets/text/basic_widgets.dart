// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';

class TextWidget extends StatelessWidget {
  String title;
  FontWeight fontWeight;
  Color? fontColor;
  double fontSize;
  TextWidget(
      {super.key,
      required this.title,
      required this.fontWeight,
      required this.fontSize,
      required this.fontColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: fontWeight, fontSize: fontSize, color: fontColor),
    );
  }
}
