import 'package:flutter/material.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';

class OrUseDividerWidget extends StatelessWidget {
  const OrUseDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: SizeConfig.height20(context),
        bottom: SizeConfig.height20(context),
        left: (SizeConfig.width20(context) * 7.3),
        right: (SizeConfig.width20(context) * 7.3),
      ),
      child: const Text(
        'or use',
        style: TextStyle(
          color: appTextColor,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
