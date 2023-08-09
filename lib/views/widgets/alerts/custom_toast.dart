import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class CustomToast {
  static void showCustomToast(String text, BuildContext context) {
    showToast(
      text,
      context: context,
      backgroundColor: blackColor,
      duration: const Duration(seconds: 2),
      position: StyledToastPosition(
        align: Alignment.bottomCenter,
        offset: SizeConfig.height20(context) * 3,
      ),
      textStyle: TextStyle(
        fontSize: SizeConfig.font14(context),
        fontWeight: FontWeight.w500,
        color: whiteColor,
      ),
      textPadding: EdgeInsets.only(
        top: SizeConfig.height12(context),
        bottom: SizeConfig.height12(context),
        left: SizeConfig.height12(context) * 2,
        right: SizeConfig.height12(context) * 2,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(
          100,
        ),
      ),
    );
  }
}
