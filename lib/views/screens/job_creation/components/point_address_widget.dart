import 'package:driver_app/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PointAddressWidget extends StatelessWidget {
  final String address;
  final String image;
  const PointAddressWidget({
    Key? key,
    required this.address,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          image,
        ),
        SizedBox(
          width: SizeConfig.width8(context),
        ),
        SizedBox(
          width: (SizeConfig.width20(context) * 8),
          child: Text(
            address,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontSize: SizeConfig.font14(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
