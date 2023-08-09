import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';

class ProgressCard extends StatelessWidget {
  final String imageLink;
  final String text;
  const ProgressCard({
    super.key,
    required this.imageLink,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: backgroundColor,
      elevation: 3,
      child: Container(
        width: (SizeConfig.width20(context) * 7.8),
        height: (SizeConfig.height20(context) * 4) - 1,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(3),
          ),
          color: backgroundColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imageLink,
                fit: BoxFit.cover,
                height: SizeConfig.height8(context) * 2,
                width: SizeConfig.width8(context),
              ),
              SizedBox(
                height: SizeConfig.height10(context),
              ),
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
