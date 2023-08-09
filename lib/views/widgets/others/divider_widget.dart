import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: (SizeConfig.width20(context) + 2),
      ),
      width: double.infinity,
      height: 1,
      color: greyColor.withOpacity(0.2),
    );
  }
}
