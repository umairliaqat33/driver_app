import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/global.dart';
import 'package:flutter/material.dart';

import 'point_address_widget.dart';
import 'price_widget.dart';

class UpperPartWidget extends StatelessWidget {
  const UpperPartWidget({
    Key? key,
    required this.charges,
    required this.dropOffAddress,
    required this.paymentType,
    required this.pickupAddress,
    required this.isRideInProgress,
    required this.time,
  }) : super(key: key);

  final String pickupAddress;
  final String dropOffAddress;
  final String charges;
  final String paymentType;
  final bool isRideInProgress;
  final int time;

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
            isRideInProgress && getUserType() == UserType.business.name
                ? Container(
                    padding: EdgeInsets.only(
                      top: SizeConfig.height10(context) - 4,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: primaryColor,
                    ),
                    height: (SizeConfig.height20(context) * 2),
                    width: (SizeConfig.width20(context) * 2),
                    child: Column(
                      children: [
                        Text(
                          time.toString(),
                          style: TextStyle(
                            fontSize: SizeConfig.font14(context),
                            fontWeight: FontWeight.w600,
                            color: whiteColor,
                          ),
                        ),
                        Text(
                          "min",
                          style: TextStyle(
                            fontSize: SizeConfig.font12(context),
                            fontWeight: FontWeight.w400,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : PriceWidget(
                    charges: charges,
                    paymentMethod: paymentType.toUpperCase(),
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
