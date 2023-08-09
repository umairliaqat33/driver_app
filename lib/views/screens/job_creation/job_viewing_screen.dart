// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/models/location_model/location.dart' as loc;

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/services/distance_matrix_api.dart';
import 'package:driver_app/views/screens/job_creation/components/lower_part_widget.dart';
import 'package:driver_app/views/screens/job_creation/components/upper_part_widget.dart';
import 'package:driver_app/views/screens/job_creation/components/user_info_widget.dart';
import 'package:driver_app/controllers/business_controllers/business_firestore_controller.dart';
import 'package:driver_app/controllers/driver_controller/driver_firestore_controller.dart';
import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/models/driver/driver_model.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/global.dart';
import 'package:driver_app/views/widgets/others/circular_loader_widget.dart';
import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/controllers/global_controller.dart';

class JobViewingScreen extends StatefulWidget {
  const JobViewingScreen({
    super.key,
    this.requestOffer,
    this.isRideInProgress = false,
  });
  final BusinessRequestModel? requestOffer;
  final bool isRideInProgress;

  @override
  State<JobViewingScreen> createState() => _JobViewingScreenState();
}

class _JobViewingScreenState extends State<JobViewingScreen> {
  bool addressAndButtonVisibility = false;
  String _pickupAddress = "";
  String _dropOffAddress = "";
  DriverModel? _driverModel;
  BusinessModel? _businessModel;
  double charges = 0;
  int time = 0;
  final TextEditingController fareController = TextEditingController();
  @override
  void initState() {
    super.initState();
    charges = widget.requestOffer!.fare;
    fareController.text = charges.toString();
    if (widget.isRideInProgress) {
      if (UserType.driver.name == getUserType()) {
        _getBusinessData();
      } else {
        _getDriverData();
      }
    }
    _getAddressesAndTime(
      LatLng(widget.requestOffer!.dropOffLocationLatitude,
          widget.requestOffer!.dropOffLocationLongitude),
      LatLng(
        widget.requestOffer!.pickupLocationLatitude,
        widget.requestOffer!.pickupLocationLongitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: whiteColor,
          padding: EdgeInsets.only(
            left: (SizeConfig.width15(context) + 1),
            right: (SizeConfig.width15(context) + 1),
            top: SizeConfig.height20(context) + 1,
          ),
          child: Column(
            children: [
              Visibility(
                visible: getUserType() == UserType.driver.name ||
                        widget.isRideInProgress
                    ? true
                    : addressAndButtonVisibility,
                child: UpperPartWidget(
                  pickupAddress: _pickupAddress,
                  dropOffAddress: _dropOffAddress,
                  charges: charges.toStringAsFixed(2),
                  paymentType: "paymentType.",
                  isRideInProgress: widget.isRideInProgress,
                  time: time,
                ),
              ),
              widget.isRideInProgress
                  ? UserType.driver.name == getUserType()
                      ? _businessModel == null
                          ? const CircularLoaderWidget()
                          : UserInfoWidget(
                              imageLink: _businessModel!.imageLink!,
                              name: _businessModel!.name!,
                              subtitle: _businessModel!.pointOfContact!,
                              userType: UserType.business,
                            )
                      : _driverModel == null
                          ? const CircularLoaderWidget()
                          : UserInfoWidget(
                              imageLink: _driverModel!.profileImageLink!,
                              name: _driverModel!.name!,
                              subtitle: _driverModel!.vehicleType!,
                              userType: UserType.driver,
                              vehicleNo: _driverModel!.vehicleNo!,
                            )
                  : LowerPart(
                      fareController: fareController,
                      visibility: getUserType() == UserType.driver.name
                          ? true
                          : addressAndButtonVisibility,
                      chargeVisibility: () =>
                          getUserType() == UserType.driver.name
                              ? null
                              : makeChangeVisibility(),
                      onChanged: (value) => onChanged(value),
                      increment: () => incrementCharges(),
                      decrement: () => decrementCharges(),
                      requestOffer: widget.requestOffer,
                      charges: charges,
                    ),
            ],
          ),
        ),
      ],
    );
  }

  void onChanged(String? value) {
    if (value != null) {
      log("value changed");
      charges = double.parse(value);
      setState(() {});
    }
  }

  void incrementCharges() {
    setState(() {
      charges = charges + 0.10;
      fareController.text = charges.toStringAsFixed(2);
    });
  }

  void decrementCharges() {
    setState(() {
      charges = charges - 0.01;
      fareController.text = charges.toStringAsFixed(2);
    });
  }

  void _getAddressesAndTime(
    LatLng dropOffLocation,
    LatLng pickupLocation,
  ) async {
    _dropOffAddress = await GlobalController.getAddress(dropOffLocation);
    _pickupAddress = await GlobalController.getAddress(pickupLocation);
    String timeString = await DistanceMatrixAPI.getTime(
      loc.Location(
        latitude: pickupLocation.latitude,
        longitude: pickupLocation.longitude,
      ),
      loc.Location(
        latitude: dropOffLocation.latitude,
        longitude: dropOffLocation.longitude,
      ),
    );
    List list = timeString.split(' ');
    time = int.parse(list[0]);
    if (!mounted) return;
    setState(() {});
  }

  void _getDriverData() async {
    DriverFirestoreController driverFirestoreController =
        DriverFirestoreController();
    try {
      log("getting driver's data");
      _driverModel = await driverFirestoreController
          .getSpecificUserData(widget.requestOffer!.acceptorDriverId!);
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  void _getBusinessData() async {
    BusinessFirestoreController businessFirestoreController =
        BusinessFirestoreController();
    try {
      _businessModel = await businessFirestoreController
          .getSpecificBusinessData(widget.requestOffer!.requestId);
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  void makeChangeVisibility() {
    setState(() {
      addressAndButtonVisibility = !addressAndButtonVisibility;
    });
  }
}
