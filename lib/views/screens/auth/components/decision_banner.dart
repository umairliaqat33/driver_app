import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';

class BannerWidget extends StatelessWidget {
  final String logo;
  final String heading;
  final String? description;

  const BannerWidget({
    Key? key,
    this.description,
    required this.heading,
    required this.logo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          logo,
        ),
        SizedBox(height: SizeConfig.height15(context)),
        Padding(
          padding: EdgeInsets.only(
            left: (SizeConfig.width15(context) * 2),
            right: (SizeConfig.width15(context) * 2),
            bottom: (SizeConfig.height8(context) * 8),
            top: (SizeConfig.height15(context) * 2) + 1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                heading,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: appTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              description == null
                  ? const SizedBox()
                  : Container(
                      width: SizeConfig.width20(context) * 10,
                      margin: EdgeInsets.only(
                        top: SizeConfig.height5(context),
                      ),
                      child: Text(
                        description!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: appTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
