import 'package:flutter/material.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';

class CustomButton extends StatelessWidget {
// placements
  // please do not remove this t o d o as i want to save this format somewhere.
  // variables
  // functions
  //   static
  //   constructors
  //   public
  //   inherited
  //   private

  final String text;
  final Function onTap;
  final Color color;
  final Color textColor;
  final bool isEnabled;
  final bool isBorderEnabled;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.color = Colors.white,
    this.textColor = appTextColor,
    this.isEnabled = true,
    this.isBorderEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? () => onTap() : null,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: color,
        disabledBackgroundColor: greyColor,
        shape: isEnabled
            ? RoundedRectangleBorder(
                side: BorderSide(
                    color: isBorderEnabled ? primaryColor : Colors.transparent),
                borderRadius: const BorderRadius.all(
                  Radius.circular(3),
                ),
              )
            : null,
        minimumSize: Size(
          double.infinity,
          (SizeConfig.height20(context) * 2),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
