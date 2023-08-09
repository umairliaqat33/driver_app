// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:driver_app/controllers/global_controller.dart';
import 'package:driver_app/controllers/request_controller/business_request_controller/business_request_controller.dart';
import 'package:driver_app/controllers/request_controller/driver_request_controller/driver_request_controller.dart';
import 'package:driver_app/models/location_model/location.dart';
import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/models/request_models/driver_request_model/driver_request_model.dart';
import 'package:driver_app/services/distance_matrix_api.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/global.dart';
import 'package:driver_app/views/screens/request/components/offer_item_lower_block.dart';
import 'package:driver_app/views/screens/request/components/offer_item_upper_block.dart';
import 'package:driver_app/views/screens/ride_in_progress/ride_in_progress.dart';
import 'package:driver_app/views/widgets/alerts/custom_toast.dart';
import 'package:flutter/material.dart';

class OfferItem<T> extends StatefulWidget {
  const OfferItem({
    super.key,
    required this.profile,
    required this.businessRequestOffer,
    required this.driverRequestModel,
    this.driverId,
  });

  final T? profile;
  final BusinessRequestModel? businessRequestOffer;
  final DriverRequestModel? driverRequestModel;
  final String? driverId;

  @override
  State<OfferItem<T>> createState() => _OfferItemState<T>();
}

class _OfferItemState<T> extends State<OfferItem<T>> {
  final BusinessRequestController _businessRequestController =
      BusinessRequestController();
  final DriverRequestController _driverRequestController =
      DriverRequestController();
  Timer? _timer;
  Timer? _driverRequestTimer;
  double progressValue = 0;
  // bool _isDriverOfferEnabled = true;

  @override
  void initState() {
    super.initState();
    _requestTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _driverRequestTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: progressValue,
          color: primaryColor,
          backgroundColor: whiteColor,
        ),
        Container(
          padding:
              const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
          decoration: const BoxDecoration(
            color: whiteColor,
          ),
          child: Column(
            children: <Widget>[
              DriverOfferItemUpperBlock(
                profile: widget.profile,
                businessRequestOffer: widget.businessRequestOffer,
                driverRequestModel: widget.driverRequestModel,
              ),
              const SizedBox(height: 16),
              DriverOfferItemLowerBlock(
                  requestId: widget.businessRequestOffer?.requestId ??
                      widget.driverRequestModel!.requestId,
                  onRequestAction: (decision) => _onRequestDecision(
                        decision,
                        context,
                        widget.driverId,
                      )),
            ],
          ),
        ),
      ],
    );
  }

  void _requestTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        progressValue = progressValue + 0.0004;
        if (progressValue == 0.9999999999999551) {
          if (getUserType() == UserType.driver.name) {
            GlobalController.updateWithDeclinedUsers(
              widget.businessRequestOffer,
              null,
            );
          } else {
            _driverRequestController
                .declineDriverOffer(widget.driverRequestModel!.requestId);
          }
          progressValue = 0;
        }
      });
    });
  }

  // void _startDriverRequestTimer() {
  //   _driverRequestTimer =
  //       Timer.periodic(const Duration(milliseconds: 2), (timer) {
  //     _isDriverOfferEnabled = true;
  //     if (!mounted) return;
  //     setState(() {
  //       progressValue = progressValue + 0.0004;
  //       if (progressValue == 0.9999999999999551) {
  //         _isDriverOfferEnabled = true;
  //         progressValue = 0;
  //       }
  //     });
  //   });
  // }

  void _onRequestDecision(
    RequestDecision decision,
    BuildContext context,
    String? id,
  ) {
    if (decision == RequestDecision.accept) {
      _acceptRequest(
        context,
        id,
      );
    } else {
      _declineRequest(widget.businessRequestOffer);
    }
  }

  void _acceptRequest(
    BuildContext context,
    String? id,
  ) async {
    try {
      BusinessRequestModel? businessRequestModel =
          await _businessRequestController.getActiveBusinessRequest(getUid());
      if (getUserType() == UserType.driver.name) {
        // if (_isDriverOfferEnabled) {
        GlobalController.updateWithDeclinedUsers(
          widget.businessRequestOffer,
          null,
        );
        String time = await DistanceMatrixAPI.getTime(
          Location(
            latitude: widget.businessRequestOffer!.pickupLocationLatitude,
            longitude: widget.businessRequestOffer!.pickupLocationLongitude,
          ),
          Location(
            latitude: widget.businessRequestOffer!.dropOffLocationLatitude,
            longitude: widget.businessRequestOffer!.dropOffLocationLongitude,
          ),
        );
        List list = time.split(' ');

        _driverRequestController.sendDriverRequest(
          DriverRequestModel(
            offeredFare: widget.businessRequestOffer!.fare,
            dropOffLocationLatitude:
                widget.businessRequestOffer!.dropOffLocationLatitude,
            dropOffLocationLongitude:
                widget.businessRequestOffer!.dropOffLocationLongitude,
            pickupLocationLatitude:
                widget.businessRequestOffer!.pickupLocationLatitude,
            pickupLocationLongitude:
                widget.businessRequestOffer!.pickupLocationLongitude,
            requestId: getUid()!,
            time: int.parse(list[0]),
          ),
          widget.businessRequestOffer!.requestId,
        );
        // _startDriverRequestTimer();
        // }else{

        // }
      } else {
        businessRequestModel!.acceptorDriverId = id;
        GlobalController.updateWithDeclinedUsers(
          businessRequestModel,
          null,
        );
        _navigateToRideInProgScr(
          context,
          businessRequestModel,
        );
      }
      CustomToast.showCustomToast(
        "Request Accepted",
        context,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  void _navigateToRideInProgScr(
    BuildContext context,
    BusinessRequestModel? request,
  ) {
    try {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => RideInProgressScreen(
            businessRequestModel: BusinessRequestModel(
              isRideCompleted: false,
              isRideCancelled: false,
              acceptorDriverId: request!.acceptorDriverId,
              requestId: request.requestId,
              pickupLocationLatitude: request.pickupLocationLatitude,
              pickupLocationLongitude: request.pickupLocationLongitude,
              dropOffLocationLatitude: request.dropOffLocationLatitude,
              dropOffLocationLongitude: request.dropOffLocationLongitude,
              fare: request.fare,
              riderType: request.riderType,
            ),
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      log("exception in business request screen at switching : ${e.toString()}");
    }
  }

  void _declineRequest(BusinessRequestModel? request) {
    if (getUserType() == UserType.driver.name) {
      GlobalController.updateWithDeclinedUsers(
        request,
        null,
      );
    } else {
      _driverRequestController
          .declineDriverOffer(widget.driverRequestModel!.requestId);
    }
    CustomToast.showCustomToast(
      "Request Declined",
      context,
    );
  }
}
