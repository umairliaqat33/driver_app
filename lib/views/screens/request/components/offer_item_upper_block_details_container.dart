import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/models/request_models/driver_request_model/driver_request_model.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/global.dart';
import 'package:driver_app/views/widgets/text/basic_widgets.dart';
import 'package:flutter/material.dart';

class OfferItemUpperBlockOfferDetailsContainer extends StatelessWidget {
  final BusinessRequestModel? businessRequestOffer;
  final DriverRequestModel? driverRequestOffer;
  const OfferItemUpperBlockOfferDetailsContainer({
    super.key,
    required this.businessRequestOffer,
    required this.driverRequestOffer,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextWidget(
          title:
              "£${businessRequestOffer?.fare.toStringAsFixed(2) ?? driverRequestOffer?.offeredFare.toStringAsFixed(2)}",
          fontSize: 20,
          fontColor: blackColor,
          fontWeight: FontWeight.w700,
        ),
        Visibility(
          visible: (getUserType() == UserType.business.name),
          child: TextWidget(
            title: getUserType() != UserType.driver.name
                ? "${driverRequestOffer?.time} min away"
                : "",
            fontSize: 12,
            fontColor: blackColor,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
