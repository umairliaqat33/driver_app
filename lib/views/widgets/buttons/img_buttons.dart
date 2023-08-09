import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';

class ImgButton extends StatelessWidget {
  final double height;
  final String img;
  final VoidCallback onPressed;

  const ImgButton({
    Key? key,
    required this.height,
    required this.img,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 2,
        child: Container(
          width: (SizeConfig.width15(context) * 5) + 2,
          height: (SizeConfig.height20(context) * 2),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: whiteColor,
          ),
          child: MaterialButton(
            onPressed: onPressed,
            child: SizedBox(
              height: SizeConfig.height20(context),
              width: SizeConfig.width20(context),
              child: SvgPicture.asset(
                img,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
