// ignore_for_file: use_build_context_synchronously

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/controllers/global_controller.dart';
import 'package:driver_app/controllers/request_controller/business_request_controller/business_request_controller.dart';
import 'package:driver_app/controllers/request_controller/driver_request_controller/driver_request_controller.dart';
import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/models/request_models/driver_request_model/driver_request_model.dart';
import 'package:driver_app/services/distance_matrix_api.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/constants.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/global.dart';
import 'package:driver_app/utils/strings.dart';
import 'package:driver_app/views/screens/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:driver_app/views/screens/job_creation/components/big_price_button.dart';
import 'package:driver_app/views/widgets/alerts/custom_toast.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/views/widgets/others/divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/models/location_model/location.dart' as loc;

import 'small_price_button.dart';

class LowerPart extends StatefulWidget {
  const LowerPart({
    Key? key,
    required this.visibility,
    required this.chargeVisibility,
    required this.onChanged,
    required this.decrement,
    required this.increment,
    required this.fareController,
    required this.charges,
    this.requestOffer,
  }) : super(key: key);
  final bool visibility;
  final Function chargeVisibility;
  final BusinessRequestModel? requestOffer;
  final Function(String?) onChanged;
  final Function increment;
  final Function decrement;
  final TextEditingController fareController;
  final double charges;

  @override
  State<LowerPart> createState() => LowerPartState();
}

class LowerPartState extends State<LowerPart> {
  final BusinessRequestController _businessRequestController =
      BusinessRequestController();
  final DriverRequestController _driverRequestController =
      DriverRequestController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: widget.visibility,
          child: Column(
            children: [
              const DividerWidget(),
              SizedBox(
                height: SizeConfig.height10(context),
              ),
              Text(
                AppStrings.currentFare,
                style: TextStyle(
                  fontSize: SizeConfig.font12(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SmallPriceButton(
              text: "$decrementSymbol$currency$offerVariationOffset",
              onIncrement: () => getUserType() == UserType.driver.name
                  ? widget.decrement()
                  : widget.visibility
                      ? widget.decrement()
                      : widget.chargeVisibility(),
            ),
            SizedBox(
              width: SizeConfig.width5(context),
            ),
            Expanded(
              child: BigPriceWidget(
                textEditingController: widget.fareController,
                onTap: () =>
                    widget.visibility ? null : widget.chargeVisibility(),
                onChange: (value) => widget.onChanged(value),
              ),
            ),
            SizedBox(
              width: SizeConfig.width5(context),
            ),
            SmallPriceButton(
              text: "$incrementSymbol$currency$offerVariationOffset",
              onIncrement: () => getUserType() == UserType.driver.name
                  ? widget.increment()
                  : widget.visibility
                      ? widget.increment()
                      : widget.chargeVisibility(),
            ),
          ],
        ),
        Visibility(
          visible: widget.visibility,
          child: Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.height15(context),
            ),
            child: CustomButton(
              color: primaryColor,
              textColor: whiteColor,
              text: AppStrings.makeOffer,
              onTap: () => makeOffer(),
            ),
          ),
        ),
      ],
    );
  }

  void makeOffer() async {
    if (getUserType() == UserType.driver.name) {
      GlobalController.updateWithDeclinedUsers(widget.requestOffer, null);
      String time = await DistanceMatrixAPI.getTime(
        loc.Location(
          latitude: widget.requestOffer!.pickupLocationLatitude,
          longitude: widget.requestOffer!.pickupLocationLongitude,
        ),
        loc.Location(
          latitude: widget.requestOffer!.dropOffLocationLatitude,
          longitude: widget.requestOffer!.dropOffLocationLongitude,
        ),
      );
      List list = time.split(' ');

      _driverRequestController.sendDriverRequest(
        DriverRequestModel(
          offeredFare: widget.charges,
          dropOffLocationLatitude: widget.requestOffer!.dropOffLocationLatitude,
          dropOffLocationLongitude:
              widget.requestOffer!.dropOffLocationLongitude,
          pickupLocationLatitude: widget.requestOffer!.pickupLocationLatitude,
          pickupLocationLongitude: widget.requestOffer!.pickupLocationLongitude,
          requestId: getUid()!,
          time: int.parse(list[0]),
        ),
        widget.requestOffer!.requestId,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BottomNavigationBarScreen(
            index: 0,
          ),
        ),
      );
    } else {
      _businessRequestController.uploadBusinessRequest(
        BusinessRequestModel(
          declinedUsersIdList: [],
          isRideCompleted: widget.requestOffer!.isRideCompleted,
          isRideCancelled: widget.requestOffer!.isRideCancelled,
          requestId: widget.requestOffer!.requestId,
          pickupLocationLatitude: widget.requestOffer!.pickupLocationLatitude,
          pickupLocationLongitude: widget.requestOffer!.pickupLocationLongitude,
          dropOffLocationLatitude: widget.requestOffer!.dropOffLocationLatitude,
          dropOffLocationLongitude:
              widget.requestOffer!.dropOffLocationLongitude,
          fare: widget.charges,
          riderType: widget.requestOffer!.riderType,
        ),
      );
      widget.chargeVisibility();
      setState(() {});
    }
    CustomToast.showCustomToast(
      "Offer Updated",
      context,
    );
  }
}
