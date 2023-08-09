import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';

class UserOptions extends StatelessWidget {
  final String image;
  final String heading;
  final String description;
  final Border? border;
  final Function function;

  const UserOptions({
    Key? key,
    required this.description,
    required this.heading,
    required this.image,
    this.border,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      child: Container(
        width: (SizeConfig.width20(context) * 7) + 14,
        height: (SizeConfig.height20(context) * 9) + 14,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: border,
        ),
        padding: EdgeInsets.only(
          left: (SizeConfig.width8(context) * 2),
          right: (SizeConfig.width8(context) * 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(image),
            Text(
              heading,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: greyColor,
                fontWeight: FontWeight.w400,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
