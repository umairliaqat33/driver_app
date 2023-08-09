// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:driver_app/models/request_models/driver_request_model/driver_request_model.dart';
import 'package:driver_app/views/widgets/alerts/custom_toast.dart';
import 'package:flutter/material.dart';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:driver_app/config/size_config.dart';
import 'package:driver_app/utils/assets.dart';
import 'package:driver_app/views/widgets/alerts/approval_in_progress_alert.dart';
import 'package:driver_app/models/users/user_model.dart';
import 'package:driver_app/repositories/user_repository/user_repository.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/views/screens/driver/driver_registration_screen.dart';
import 'package:driver_app/views/screens/map/map_screen.dart';
import 'package:driver_app/views/widgets/alerts/user_not_registered_alert_box.dart';
import 'package:driver_app/controllers/driver_controller/driver_firestore_controller.dart';
import 'package:driver_app/models/driver/driver_model.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:driver_app/utils/strings.dart';
import 'package:driver_app/controllers/business_controllers/business_firestore_controller.dart';
import 'package:driver_app/controllers/global_controller.dart';
import 'package:driver_app/controllers/maps_controller/maps_firestore_controller.dart';
import 'package:driver_app/models/business/business_model.dart';
import 'package:driver_app/models/location_model/location_model.dart';
import 'package:driver_app/models/user_data.dart';
import 'package:driver_app/views/screens/business/business_registration_screen.dart';
import 'package:driver_app/views/screens/job_creation/job_creation_screen.dart';
import 'package:driver_app/views/screens/request/business_request_screen.dart';
import 'package:driver_app/controllers/request_controller/business_request_controller/business_request_controller.dart';
import 'package:driver_app/controllers/request_controller/driver_request_controller/driver_request_controller.dart';
import 'package:driver_app/models/local/local_request_model.dart';
import 'package:driver_app/models/local/offer_model.dart';
import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/views/screens/request/driver_request_overlay.dart';
import 'package:driver_app/views/screens/map/bottom_sheet_drop_off_location.dart';
import 'package:driver_app/views/screens/ride_in_progress/ride_in_progress.dart';
import '../../../utils/global.dart';

class HomeScreen extends StatefulWidget {
  final VehicleType? vehicleType;
  final GeoPoint? dropOffLocation;
  final String? dropOffAddress;
  GeoPoint? pickUpLocation;
  String? pickUpAddress;
  HomeScreen({
    super.key,
    this.vehicleType,
    this.dropOffLocation,
    this.dropOffAddress,
    this.pickUpAddress,
    this.pickUpLocation,
  });
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSwitched = false;
  final UserRepository _userRepository = UserRepository();
  final MapsFirestoreController _mapsFirestoreController =
      MapsFirestoreController();
  final BusinessFirestoreController _businessFirestoreController =
      BusinessFirestoreController();
  final BusinessRequestController _businessRequestController =
      BusinessRequestController();
  GeoPoint? previousPosition;
  DriverModel? _driverModel;
  Timer? timer;
  String? userType;
  UserModel? userModel;
  UserData userData = UserData();
  VehicleType _vehicleCategory = VehicleType.all;
  bool showHideJobCreationScreen = true;
  bool _isLoading = false;
  LatLng? _currentLocation;
  LocalRequestModel? localRequestModel;
  DriverRequestModel? _driverRequestModel;
  @override
  void initState() {
    super.initState();
    userType = GlobalController.getUserType();
    _vehicleCategory = widget.vehicleType ?? VehicleType.all;

    _getAndUpdateLocation();

    _getData();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userType == UserType.business.name
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: backgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Offline',
                    style: TextStyle(
                      color: appTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.width8(context),
                      right: SizeConfig.width8(context),
                    ),
                    child: FlutterSwitch(
                      width: (SizeConfig.width8(context) * 4),
                      height: SizeConfig.height18(context),
                      toggleSize: SizeConfig.height10(context),
                      activeColor: primaryColor,
                      inactiveColor: blackColor,
                      value: GlobalController.getDriverWorkStatus(),
                      onToggle: (bool value) => _switchValue(),
                    ),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(
                      color: appTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        MapScreen(
                          vehicleType: _vehicleCategory,
                          destination: widget.dropOffLocation,
                          pickupLocation: widget.pickUpLocation,
                        ),
                        if (userType == AppStrings.roleDriver &&
                            userData.data != null &&
                            GlobalController.getDriverWorkStatus())
                          StreamBuilder<List<BusinessRequestModel?>>(
                            stream: _businessRequestController
                                .getBusinessRequestsStream(
                                    userData.data.vehicleType),
                            builder: (_,
                                AsyncSnapshot<List<BusinessRequestModel?>>
                                    snapshot1) {
                              if (snapshot1.hasData &&
                                  snapshot1.data!.isNotEmpty) {
                                _storeRequests(snapshot1.data!);
                                _isRequestAccepted(snapshot1.data!);
                                return StreamBuilder<QuerySnapshot>(
                                    stream: _businessFirestoreController
                                        .getBusinesses(extractDocumentIds(
                                            snapshot1.data!)),
                                    builder: (_,
                                        AsyncSnapshot<QuerySnapshot>
                                            snapshot2) {
                                      if (snapshot2.hasData) {
                                        _storeRoleModels(snapshot2);
                                      }
                                      return Visibility(
                                        visible: snapshot2.hasData,
                                        child: DriverRequestOverlay(
                                            localRequestModel:
                                                localRequestModel!),
                                      );
                                    });
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: userType == AppStrings.roleBusiness &&
                            showHideJobCreationScreen
                        ? true
                        : false,
                    child: Column(
                      children: [
                        JobCreationScreen(
                          selectedVehicleType: _vehicleCategory,
                          onAllTap: () => _selectVehicle(VehicleType.all),
                          onBikeTap: () => _selectVehicle(VehicleType.bike),
                          onCarTap: () => _selectVehicle(VehicleType.car),
                          onFindDriver: (request, offer) =>
                              _businessDoNotExist(request, offer),
                          pickupAddress: widget.pickUpAddress,
                          dropOffAddress: widget.dropOffAddress,
                          onDropOfFieldTap: () => _onLocationFieldTap(true),
                          onPickUpFieldTap: () => _onLocationFieldTap(false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _businessDoNotExist(
      BusinessRequestModel request, OfferModel offer) async {
    if (userModel?.reference == null) {
      userNotRegisteredAlert(
        context: context,
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const BusinessRegistrationScreen(),
            ),
          );
        },
        description:
            'It seems you’re not registered as a driver yet in order to start earning first you need to register.',
        isButtonVisible: true,
        title: AppStrings.driverNotRegistered,
      );
    } else if (userModel?.reference != null &&
        userData.data?.approvalStatus == BusinessApprovalStatus.approved.name) {
      _onFindDriverClick(request, offer);
    } else {
      if (userData.data!.approvalStatus ==
          BusinessApprovalStatus.blocked.name) {
        approvalInProgressAlert(
          context: context,
          description:
              'You’re blocked due to some reason contact the administrator here switchdriver@gmail.com',
          isButtonVisible: false,
          image: Assets.approvalRequestBlockerImage,
          heading: "User Blocked",
        );
        return;
      } else if (userData.data.approvalStatus ==
          BusinessApprovalStatus.pending.name) {
        approvalInProgressAlert(
          context: context,
          description:
              "Your request is not approved yet. Once it approve we will notify you.",
          isButtonVisible: false,
          image: Assets.waitingImage,
          heading: "Request Pending",
        );
        return;
      } else if (userData.data.approvalStatus == null) {
        log("approval do not exist");
      } else {
        log("approval do not exist or something else went wrong");
      }
    }
  }

  void _storeRequests(List<BusinessRequestModel?> snapshot) {
    if (snapshot.isNotEmpty) {
      for (int i = 0; i < snapshot.length; i++) {
        if (localRequestModel!.businessRequestList!.isEmpty ||
            localRequestModel!.businessRequestList!.length <= i) {
          localRequestModel!.businessRequestList!.add(snapshot[i]!);
        } else {
          localRequestModel!.businessRequestList![i] = snapshot[i]!;
        }
      }
    }
  }

  Future<void> _getDriverRequestData(
      String uid, String businessRequestId) async {
    final DriverRequestController driverRequestController =
        DriverRequestController();
    _driverRequestModel = await driverRequestController.getAccDriverRequest(
      businessRequestId,
      uid,
    );
  }

  void _isRequestAccepted(List<BusinessRequestModel?> snapshot) async {
    try {
      if (snapshot.isNotEmpty) {
        for (var element in snapshot) {
          if (element!.acceptorDriverId == getUid()) {
            await _getDriverRequestData(getUid()!, element.requestId);
            if (!element.isRideCompleted ||
                (_driverRequestModel!.isRideCompleted &&
                    _driverRequestModel?.imageLink == null)) {
              if (!mounted) return;
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => RideInProgressScreen(
                        businessRequestModel: element,
                      ),
                    ),
                    (route) => false,
                  );
                },
              );
            }
          }
        }
      }
    } catch (e) {
      log("error in switching at homeScreen :${e.toString()}");
    }
  }

  void _storeRoleModels(AsyncSnapshot<QuerySnapshot> snapshot) {
    localRequestModel!.roleModelList!.clear();
    snapshot.data?.docs.map((e) => e.data()).forEach((element) {
      localRequestModel!.roleModelList!.add(element as BusinessModel);
    });
  }

  List<String> extractDocumentIds(List<BusinessRequestModel?> snapshot) {
    List<String> documentIdsList = [];
    if (snapshot.isNotEmpty) {
      for (var element in snapshot) {
        documentIdsList.add(element!.requestId);
      }
    }
    return documentIdsList;
  }

  void _onLocationFieldTap(bool isDropOff) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BottomSheetDropOffLocation(
          isDropOff: isDropOff,
          vehicleType: widget.vehicleType,
          dropOffAddress: widget.dropOffAddress,
          dropOffLocation: widget.dropOffLocation,
          pickUpAddress: widget.pickUpAddress,
          pickUpLocation: widget.pickUpLocation,
        ),
      ),
    );
  }

  void _onFindDriverClick(
      BusinessRequestModel request, OfferModel offer) async {
    try {
      setState(() {
        showHideJobCreationScreen = false;
      });
      DriverRequestController driverRequestController =
          DriverRequestController();
      driverRequestController.deleteAllDriverReq(getUid()!);
      _businessRequestController.uploadBusinessRequest(
        BusinessRequestModel(
          requestId: userData.data.uid,
          isRideCompleted: false,
          isRideCancelled: false,
          pickupLocationLatitude:
              widget.pickUpLocation?.latitude ?? _currentLocation!.latitude,
          pickupLocationLongitude:
              widget.pickUpLocation?.longitude ?? _currentLocation!.longitude,
          dropOffLocationLatitude: widget.dropOffLocation!.latitude,
          dropOffLocationLongitude: widget.dropOffLocation!.longitude,
          fare: request.fare,
          riderType: _vehicleCategory.name,
          acceptorDriverId: "",
          declinedUsersIdList: [],
        ),
      );
      bool value = await Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => BusinessRequestScreen(
            localRequestModel: localRequestModel!,
            offer: offer,
            request: BusinessRequestModel(
              requestId: userData.data.uid,
              isRideCompleted: false,
              isRideCancelled: false,
              pickupLocationLatitude:
                  widget.pickUpLocation?.latitude ?? _currentLocation!.latitude,
              pickupLocationLongitude: widget.pickUpLocation?.longitude ??
                  _currentLocation!.longitude,
              dropOffLocationLatitude: widget.dropOffLocation!.latitude,
              dropOffLocationLongitude: widget.dropOffLocation!.longitude,
              fare: request.fare,
              riderType: _vehicleCategory.name,
              acceptorDriverId: "",
            ),
          ),
        ),
      );

      if (!mounted) return;
      setState(() {
        showHideJobCreationScreen = value;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void _selectVehicle(VehicleType type) {
    setState(() {
      _vehicleCategory = type;
    });
    log(_vehicleCategory.name);
  }

  void _getAndUpdateLocation() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      if (widget.pickUpAddress != null && widget.pickUpLocation != null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      Position? currentLocation = await GlobalController.getLocation();
      if (currentLocation == null) {
        _getAndUpdateLocation();
      }
      await _getAddress(
        LatLng(currentLocation!.latitude, currentLocation.longitude),
      );
      if (!mounted) return;
      setState(() {
        widget.pickUpLocation =
            GeoPoint(currentLocation.latitude, currentLocation.longitude);
        _isLoading = false;
      });
      updateDriverLocation();
    } catch (e) {
      log(e.toString());
    }
  }

  void updateDriverLocation() async {
    UserModel? userModel = await _userRepository.getUserInformation();
    MapsFirestoreController mapsFirestoreController = MapsFirestoreController();
    LocationModel? locationModel =
        await mapsFirestoreController.getUserLocation(userModel!.uid!);
    if (userType == AppStrings.roleDriver && userModel.reference != null) {
      if (locationModel == null) {
        log("location model is null");
      } else {
        previousPosition =
            GeoPoint(locationModel.latitude!, locationModel.longitude!);
      }
      timer = Timer.periodic(
          const Duration(
            seconds: 1,
          ), (_) async {
        if (_isSwitched) {
          Position? currentLocation = await GlobalController.getLocation();

          if (currentLocation?.longitude != previousPosition?.longitude ||
              currentLocation?.latitude != previousPosition?.latitude) {
            previousPosition = GeoPoint(
              currentLocation!.latitude,
              currentLocation.longitude,
            );
            _mapsFirestoreController.updateLocationData(
              LocationModel(
                latitude: currentLocation.latitude,
                longitude: currentLocation.longitude,
                userName: locationModel?.userName ?? userModel.userName,
                vehicleType:
                    locationModel?.vehicleType ?? _driverModel?.vehicleType,
                userId: userModel.uid,
              ),
            );
            log('location updated');
          }
        }
      });
    }
  }

  void getLocationAgain() {
    _getAndUpdateLocation();
  }

  Future<void> _getAddress(LatLng position) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placeMarks[0];
    widget.pickUpAddress ??=
        '${place.street}, ${place.subLocality},${place.locality},${place.administrativeArea}';
    log(widget.pickUpAddress!);
  }

  Future<void> _getData() async {
    final DriverFirestoreController driverFirestoreController =
        DriverFirestoreController();
    final BusinessFirestoreController businessFirestoreController =
        BusinessFirestoreController();
    userModel = await _userRepository.getUserInformation();
    if (userType == AppStrings.roleDriver) {
      userData = UserData<DriverModel>();
      userData.data = await driverFirestoreController.getData();
      _driverModel = userData.data;
      localRequestModel = LocalRequestModel<BusinessModel>(
        businessRequestList: [],
        roleModelList: [],
        driverRequestList: [],
      );
    } else {
      userData = UserData<BusinessModel>();
      userData.data = await businessFirestoreController.getBusinessData();
      localRequestModel = LocalRequestModel<DriverModel>(
        businessRequestList: [],
        roleModelList: [],
        driverRequestList: [],
      );
    }
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _switchValue() async {
    try {
      if (userModel?.reference == null) {
        userNotRegisteredAlert(
          context: context,
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => userType == UserType.driver.name
                    ? const DriverRegistrationScreen()
                    : const BusinessRegistrationScreen(),
              ),
            );
          },
          description:
              'It seems you’re not registered as a driver yet in order to start earning first you need to register.',
          isButtonVisible: true,
          title: AppStrings.driverNotRegistered,
        );
      } else if (userModel?.reference != null &&
          userData.data?.approvalStatus == DriverApprovalStatus.approved.name) {
        _isSwitched = !_isSwitched;

        CustomToast.showCustomToast(
          "Status changed to ${_isSwitched ? "Online" : "Offline"}",
          context,
        );

        GlobalController.setDriverWorkStatus(_isSwitched);

        if (!mounted) return;
        setState(() {});
      } else {
        if (userData.data!.approvalStatus ==
            DriverApprovalStatus.blocked.name) {
          approvalInProgressAlert(
            context: context,
            description:
                'You’re blocked due to some reason contact the administrator here switchdriver@gmail.com',
            isButtonVisible: false,
            image: Assets.approvalRequestBlockerImage,
            heading: "User Blocked",
          );
          return;
        } else if (userData.data.approvalStatus ==
            DriverApprovalStatus.pending.name) {
          approvalInProgressAlert(
            context: context,
            description:
                "Your request is not approved yet. Once it approve we will notify you.",
            isButtonVisible: false,
            image: Assets.waitingImage,
            heading: "Request Pending",
          );
          return;
        } else if (userData.data.approvalStatus ==
            DriverApprovalStatus.rejected.name) {
          approvalInProgressAlert(
            context: context,
            description:
                'It seems your request have been rejected. Please contact to support for further assistance.',
            isButtonVisible: false,
            image: Assets.approvalRequestRejectedImage,
            heading: "Request Rejected",
          );
          return;
        } else if (userData.data.approvalStatus == null) {
          log("approval do not exist");
        } else {
          log("approval do not exist or something else went wrong");
        }
      }
    } catch (e) {
      log("Exception in switching driver status: ${e.toString()}");
    }
  }
}
