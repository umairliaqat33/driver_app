import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VehicleTypeCard extends StatelessWidget {
  final Color color;
  final String text;
  final String image;
  final Border? border;
  const VehicleTypeCard({
    super.key,
    required this.color,
    required this.image,
    required this.text,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (SizeConfig.width20(context) * 5.2),
      height: (SizeConfig.height20(context) * 2.25),
      padding: EdgeInsets.only(
        left: (SizeConfig.width10(context)),
        right: SizeConfig.width8(context),
        top: SizeConfig.height8(context) - 2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(3),
        ),
        border: border,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.height8(context) - 2),
              child: Text(
                text,
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: SizeConfig.font12(context),
                  color: whiteColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SvgPicture.asset(
                image,
              ),
            ],
          )
        ],
      ),
    );
  }
}
