import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:driver_app/utils/colors.dart';

class BackArrowAppbar extends StatelessWidget {
  final Color appBarColor;
  final double elevation;
  final VoidCallback onPressed;
  final String? picture;
  final String text;
  final Color textColor;
  final double fontSize;

  const BackArrowAppbar({
    Key? key,
    required this.fontSize,
    required this.textColor,
    required this.text,
    this.picture,
    required this.onPressed,
    required this.appBarColor,
    required this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      backgroundColor: backgroundColor,
      centerTitle: true,
      leading: picture != null
          ? MaterialButton(
              onPressed: onPressed,
              child: SvgPicture.asset(
                picture!,
              ),
            )
          : null,
      title: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
