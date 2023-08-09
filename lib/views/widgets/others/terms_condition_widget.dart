import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/widgets/buttons/text_button_widget.dart';

class TermsConditionsWidget extends StatelessWidget {
  const TermsConditionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.width8(context),
        right: SizeConfig.width8(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButtonWidget(
            text: 'Terms',
            onPressed: () {
              log("terms Pressed");
            },
            fontSize: 14,
            color: blackColor,
            fontWeight: FontWeight.w500,
          ),
          TextButtonWidget(
            text: 'Conditions',
            onPressed: () {
              log("Conditions Pressed");
            },
            fontSize: 14,
            color: blackColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
