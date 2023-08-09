import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/models/driver/driver_model.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/widgets/text/basic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DriverOfferItemUpperBlockProfileContainer extends StatelessWidget {
  const DriverOfferItemUpperBlockProfileContainer(
      {super.key, required this.profile});
  final dynamic profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            (profile.runtimeType == DriverModel)
                ? (profile as DriverModel).profileImageLink!
                : (profile as BusinessModel).imageLink!,
            height: 42,
            width: 42,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TextWidget(
                  title: profile!.name!,
                  fontSize: 14,
                  fontColor: blackColor,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(width: 4),
                Image.asset(Assets.verified),
                const SizedBox(width: 4),
                SvgPicture.asset(Assets.starFilled),
                const SizedBox(width: 4),
                TextWidget(
                  title: "12",
                  fontSize: 12,
                  fontColor: greyColor,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(width: 2),
                TextWidget(
                  title: "(${27})",
                  fontSize: 10,
                  fontColor: greyColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextWidget(
              title: (profile.runtimeType == DriverModel)
                  ? (profile as DriverModel).vehicleType!
                  : "",
              fontSize: 12,
              fontColor: greyColor,
              fontWeight: FontWeight.w600,
            )
          ],
        ),
      ],
    );
  }
}
