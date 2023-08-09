// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:driver_app/controllers/business_controllers/business_firestore_controller.dart';
import 'package:driver_app/controllers/global_controller.dart';
import 'package:driver_app/controllers/request_controller/driver_request_controller/driver_request_controller.dart';
import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/services/media_service.dart';
import 'package:driver_app/views/screens/ratings/give_ratings_screen.dart';
import 'package:driver_app/views/screens/ride_in_progress/components/after_ride_image_part.dart';
import 'package:driver_app/views/widgets/alerts/custom_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/models/request_models/driver_request_model/driver_request_model.dart';
import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/controllers/request_controller/business_request_controller/business_request_controller.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/screens/job_creation/job_viewing_screen.dart';
import 'package:driver_app/views/screens/map/map_screen.dart';
import 'package:driver_app/views/widgets/buttons/custom_button_widget.dart';
import 'package:driver_app/controllers/driver_controller/driver_firestore_controller.dart';
import 'package:driver_app/models/driver/driver_model.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/global.dart';
import 'package:driver_app/views/widgets/alerts/custom_toast.dart';
import 'package:driver_app/views/widgets/others/circular_loader_widget.dart';
import 'package:geofence_flutter/geofence_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideInProgressScreen extends StatefulWidget {
  const RideInProgressScreen({
    super.key,
    required this.businessRequestModel,
  });
  final BusinessRequestModel businessRequestModel;

  @override
  State<RideInProgressScreen> createState() => _RideInProgressScreenState();
}

class _RideInProgressScreenState extends State<RideInProgressScreen> {
  final BusinessRequestController _businessRequestController =
      BusinessRequestController();
  final DriverRequestController _driverRequestController =
      DriverRequestController();
  final DriverFirestoreController _driverFirestoreController =
      DriverFirestoreController();
  DriverModel? _driverModel;
  BusinessModel? _businessModel;
  bool _isRideCompleted = false;
  String? _doorImage;
  String pickupAddress = '';
  String dropOffAddress = '';
  PlatformFile? _parcelPlatformFile;
  bool _isImageUploaded = false;

  @override
  void initState() {
    super.initState();
    _isDriverReached(
      GeoPoint(
        widget.businessRequestModel.dropOffLocationLatitude,
        widget.businessRequestModel.dropOffLocationLongitude,
      ),
    );
    _getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MapScreen(
              vehicleType: _driverModel?.vehicleType == VehicleType.bike.name
                  ? VehicleType.bike
                  : VehicleType.car,
              pickupLocation: GeoPoint(
                widget.businessRequestModel.pickupLocationLatitude,
                widget.businessRequestModel.pickupLocationLongitude,
              ),
              destination: GeoPoint(
                widget.businessRequestModel.dropOffLocationLatitude,
                widget.businessRequestModel.dropOffLocationLongitude,
              ),
              driverId: widget.businessRequestModel.acceptorDriverId,
            ),
          ),
          _isImageUploaded
              ? GiveRatingsScreen(
                  imageLink: getUserType() == UserType.business.name
                      ? _driverModel!.profileImageLink!
                      : _businessModel!.imageLink!,
                  userName: getUserType() == UserType.business.name
                      ? _driverModel!.name!
                      : _businessModel!.name!,
                )
              : StreamBuilder<DocumentSnapshot?>(
                  stream: getUserType() != UserType.driver.name
                      ? _driverRequestController.getSpecDriverReqStream(
                          widget.businessRequestModel.acceptorDriverId!,
                          getUid()!,
                        )
                      : _businessRequestController.getSpecBusinessReqStream(
                          widget.businessRequestModel.requestId,
                        ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularLoaderWidget(),
                      );
                    }
                    if (snapshot.hasData) {
                      String value = getUserType() != UserType.business.name
                          ? 'acceptorDriverId'
                          : 'requestId';
                      String id = snapshot.data!.get(value);
                      _isRideCompleted = snapshot.data!.get("isRideCompleted");
                      _doorImage = getUserType() != UserType.driver.name
                          ? snapshot.data!.get("imageLink")
                          : null;
                      _getDriverData(id);
                      _isRideCompletedFunction(snapshot.data!);
                      _getBusinessData();
                    }
                    return SafeArea(
                      child: Column(
                        children: [
                          !_isRideCompleted
                              ? Column(
                                  children: [
                                    JobViewingScreen(
                                      requestOffer: widget.businessRequestModel,
                                      isRideInProgress: true,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.width20(context) * 10,
                                      child: CustomButton(
                                        color: primaryColor,
                                        textColor: whiteColor,
                                        text: "Complete Ride",
                                        onTap: () => _completeRide(context),
                                      ),
                                    ),
                                  ],
                                )
                              : getUserType() == UserType.driver.name
                                  ? Column(
                                      children: [
                                        JobViewingScreen(
                                          requestOffer:
                                              widget.businessRequestModel,
                                          isRideInProgress: true,
                                        ),
                                        AfterRideImagePart(
                                          selectImage: () async =>
                                              _selectProfileImage(),
                                          parcelPlatformFile:
                                              _parcelPlatformFile,
                                          onTap: () async =>
                                              _endDriverSideRide(),
                                        ),
                                      ],
                                    )
                                  : AfterRideImagePart(
                                      dropOffAddress: dropOffAddress,
                                      pickupAddress: pickupAddress,
                                      image: _doorImage,
                                      onTap: () {
                                        if (_doorImage!.isNotEmpty) {
                                          setState(() {
                                            _isImageUploaded = true;
                                          });
                                        }
                                      },
                                    ),
                        ],
                      ),
                    );
                  }),
        ],
      ),
    );
  }

  void _getDriverData(String id) async {
    _driverModel = await _driverFirestoreController.getSpecificUserData(id);
  }

  void _getBusinessData() async {
    BusinessFirestoreController businessFirestoreController =
        BusinessFirestoreController();
    _businessModel = await businessFirestoreController.getSpecificBusinessData(
      widget.businessRequestModel.requestId,
    );
  }

  void _getAddress() async {
    pickupAddress = await GlobalController.getAddress(
      LatLng(
        widget.businessRequestModel.pickupLocationLatitude,
        widget.businessRequestModel.pickupLocationLongitude,
      ),
    );
    dropOffAddress = await GlobalController.getAddress(
      LatLng(
        widget.businessRequestModel.dropOffLocationLatitude,
        widget.businessRequestModel.dropOffLocationLongitude,
      ),
    );
  }

  void showRatingScreen(
    String imageLink,
    String userName,
  ) {
    showBottomSheet(
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return GiveRatingsScreen(
          imageLink: imageLink,
          userName: userName,
        );
      },
    );
  }

  void _isRideCompletedFunction(DocumentSnapshot snapshot) {
    try {
      if (snapshot.data() != null) {
        bool isRideCompleted = snapshot.get('isRideCompleted');
        if (isRideCompleted) {
          if (!mounted) return;
        }
      }
    } catch (e) {
      log("error in switching at ride in progress screen :${e.toString()}");
    }
  }

  void _isDriverReached(GeoPoint dropOffLocation) async {
    try {
      await Geofence.startGeofenceService(
        pointedLatitude: dropOffLocation.latitude.toString(),
        pointedLongitude: dropOffLocation.latitude.toString(),
        radiusMeter: "2.0",
        eventPeriodInSeconds: 1,
      );

      StreamSubscription<GeofenceEvent>? geofenceEventStream =
          Geofence.getGeofenceStream()?.listen((GeofenceEvent event) {
        log(event.toString());
      });
      geofenceEventStream?.onData((data) {
        if (data.name == GeofenceEvent.enter.name) {
          Geofence.stopGeofenceService();
          geofenceEventStream.cancel();
          _completeRide(context);
        }
      });
    } catch (e) {
      log("Log in ride in progress screen's _isDriverReached function : ${e.toString()}");
    }
  }

  void _completeRide(BuildContext context) async {
    try {
      BusinessRequestController requestController = BusinessRequestController();
      widget.businessRequestModel.isRideCompleted = true;
      requestController.uploadBusinessRequest(widget.businessRequestModel);

      DriverRequestModel? driverRequestModel =
          await _driverRequestController.getAccDriverRequest(
        widget.businessRequestModel.requestId,
        widget.businessRequestModel.acceptorDriverId!,
      );

      if (driverRequestModel == null) {
        log('Driver Request Model is null');
        return;
      }

      driverRequestModel.isRideCompleted = true;

      _driverRequestController.sendDriverRequest(
        driverRequestModel,
        widget.businessRequestModel.requestId,
      );
      CustomToast.showCustomToast(
        "Ride Completed",
        context,
      );
    } catch (e) {
      log("exception at ride in progress: ${e.toString()}");
    }
  }

  void _endDriverSideRide() async {
    try {
      DriverRequestModel? driverRequestModel =
          await _driverRequestController.getAccDriverRequest(
        widget.businessRequestModel.requestId,
        widget.businessRequestModel.acceptorDriverId!,
      );
      String? imageLink = await MediaService.uploadFile(
        _parcelPlatformFile,
        getUserType()!,
        isRequest: true,
      );
      if (imageLink != null || imageLink!.isNotEmpty) {
        driverRequestModel!.imageLink = imageLink;

        _driverRequestController.sendDriverRequest(
          driverRequestModel,
          widget.businessRequestModel.requestId,
        );
        setState(() {
          _isImageUploaded = true;
        });
        CustomToast.showCustomToast(
          "Image uploaded",
          context,
        );
      } else {
        _showSnackBar("Image uploading failed try again", context);
      }
    } catch (e) {
      log("Error in ending driver ride: ${e.toString()}");
    }
  }

  Future<void> _selectProfileImage() async {
    try {
      _parcelPlatformFile = await MediaService.selectFile();
      if (_parcelPlatformFile != null) {
        log("Big Image Clicked");
        log(_parcelPlatformFile!.name);
      } else {
        log("no file selected");
        return;
      }
      setState(() {});
    } catch (e) {
      _showSnackBar(
        "Please pick an image",
        context,
      );
    }
  }

  void _showSnackBar(
    String subTitle,
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar(
        subTitle: subTitle,
      ),
    );
  }
}
