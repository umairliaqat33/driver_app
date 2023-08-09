import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/strings.dart';
import 'package:driver_app/views/screens/job_creation/components/point_address_widget.dart';
import 'package:flutter/material.dart';

class AfterImageUpperPart extends StatelessWidget {
  final String pickupAddress;
  final String dropOffAddress;
  const AfterImageUpperPart({
    super.key,
    required this.dropOffAddress,
    required this.pickupAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PointAddressWidget(
              address: pickupAddress,
              image: Assets.locationPointASvg,
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                AppStrings.complaint,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: SizeConfig.font12(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.height10(context),
        ),
        Row(
          children: [
            PointAddressWidget(
              address: dropOffAddress,
              image: Assets.locationPointBSvg,
            ),
          ],
        ),
      ],
    );
  }
}
