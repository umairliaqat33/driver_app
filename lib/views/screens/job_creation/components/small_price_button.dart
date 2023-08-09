import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:flutter/material.dart';

class SmallPriceButton extends StatelessWidget {
  final String text;
  final Function onIncrement;
  const SmallPriceButton({
    Key? key,
    required this.text,
    required this.onIncrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => onIncrement()),
      child: Container(
        padding: EdgeInsets.only(
          top: SizeConfig.width8(context),
          bottom: SizeConfig.width8(context),
          left: (SizeConfig.height20(context) + 5),
          right: (SizeConfig.height20(context) + 5),
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              5,
            ),
          ),
          border: Border.all(
            color: greyColor.withOpacity(
              0.3,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: SizeConfig.font16(context),
          ),
        ),
      ),
    );
  }
}
