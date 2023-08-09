import 'package:flutter/material.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';

userNotRegisteredAlert({
  required BuildContext context,
  Function? onTap,
  required String title,
  required String description,
  required bool isButtonVisible,
  bool dismissibleProperty = true,
}) {
  return showDialog(
    barrierDismissible: dismissibleProperty,
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        title: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: appTextColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        content: Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: greyColor,
          ),
        ),
        actions: [
          isButtonVisible
              ? Padding(
                  padding: EdgeInsets.only(
                    top: (SizeConfig.height20(context)),
                    bottom: (SizeConfig.height20(context)),
                    left: (SizeConfig.width15(context) + 1),
                    right: (SizeConfig.width15(context) + 1),
                  ),
                  child: CustomButton(
                    text: 'GET STARTED',
                    onTap: onTap!,
                    textColor: whiteColor,
                    color: primaryColor,
                  ),
                )
              : const SizedBox(),
        ],
      );
    },
  );
}
