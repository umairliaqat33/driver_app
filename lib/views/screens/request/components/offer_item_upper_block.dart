import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/models/request_models/driver_request_model/driver_request_model.dart';
import 'package:driver_app/views/screens/request/components/offer_item_upper_block_details_container.dart';
import 'package:driver_app/views/screens/request/components/offer_item_upper_block_profile_container.dart';
import 'package:flutter/material.dart';

class DriverOfferItemUpperBlock extends StatelessWidget {
  const DriverOfferItemUpperBlock({
    super.key,
    required this.profile,
    required this.businessRequestOffer,
    required this.driverRequestModel,
  });
  final dynamic profile;
  final BusinessRequestModel? businessRequestOffer;
  final DriverRequestModel? driverRequestModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DriverOfferItemUpperBlockProfileContainer(profile: profile),
        OfferItemUpperBlockOfferDetailsContainer(
          businessRequestOffer: businessRequestOffer,
          driverRequestOffer: driverRequestModel,
        ),
      ],
    );
  }
}
