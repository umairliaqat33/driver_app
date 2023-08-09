import 'dart:developer';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/global.dart';
import 'package:driver_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserActionWidget extends StatelessWidget {
  const UserActionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UserType.driver.name == getUserType()
            ? GestureDetector(
                onTap: () {
                  log("clicked on complaint");
                },
                child: Text(
                  AppStrings.complaint,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: SizeConfig.font12(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : IconButton(
                onPressed: () {
                  log("Driver Blocked");
                },
                icon: SvgPicture.asset(Assets.blockUserImage),
              ),
        IconButton(
          onPressed: () {
            log("Driver added to favorite");
          },
          icon: SvgPicture.asset(Assets.favoriteIcon),
        ),
      ],
    );
  }
}
