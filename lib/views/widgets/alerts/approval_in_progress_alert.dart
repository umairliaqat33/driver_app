import 'package:flutter/material.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:flutter_svg/svg.dart';

approvalInProgressAlert({
  Function? onTap,
  bool dismissibleProperty = true,
  required BuildContext context,
  required String description,
  required bool isButtonVisible,
  required String image,
  required String heading,
}) {
  return showDialog(
    barrierDismissible: dismissibleProperty,
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        backgroundColor: backgroundColor,
        content: ConstrainedBox(
          constraints: BoxConstraints.tight(Size(
              (SizeConfig.width20(context) * 12.8),
              (SizeConfig.height20(context) * 12.9))),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: (SizeConfig.height20(context) * 3) + 3,
                  bottom: SizeConfig.height20(context),
                ),
                child: SvgPicture.asset(image),
              ),
              Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.font16(context),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.height20(context),
                  // bottom: SizeConfig.height20(context) * 3,
                ),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.font16(context),
                  ),
                ),
              ),
            ],
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
