import 'dart:developer';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:driver_app/controllers/request_controller/business_request_controller/business_request_controller.dart';
import 'package:driver_app/models/request_models/business_request_model/business_request_model.dart';
import 'package:driver_app/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/users/user_model.dart';
import 'package:driver_app/local/local_repository.dart';
import 'package:driver_app/services/location_services.dart';

class GlobalController {
  static late LocalStorageRepository _localStorage;
  static bool _isDriverOnline = false;
  static void initialize() async {
    _localStorage =
        LocalStorageRepository(await SharedPreferences.getInstance());
  }

  static void clearPreferences() async {
    var prefManager = await SharedPreferences.getInstance();
    await prefManager.clear();
    _localStorage = LocalStorageRepository(prefManager);
  }

  static void updateWithDeclinedUsers(
    BusinessRequestModel? request,
    String? id,
  ) async {
    final BusinessRequestController businessRequestController =
        BusinessRequestController();
    List<String>? declinedUsersIdList = request?.declinedUsersIdList;
    if (declinedUsersIdList == null || declinedUsersIdList.isEmpty) {
      declinedUsersIdList = [];
      declinedUsersIdList.add(GlobalController.getUserId()!);
    } else {
      if (UserType.business.name != getUserType()) {
        declinedUsersIdList.add(GlobalController.getUserId()!);
      }
    }
    businessRequestController.uploadBusinessRequest(
      BusinessRequestModel(
        isRideCompleted: false,
        isRideCancelled: false,
        acceptorDriverId: id ?? request?.acceptorDriverId,
        requestId: request!.requestId,
        pickupLocationLatitude: request.pickupLocationLatitude,
        pickupLocationLongitude: request.pickupLocationLongitude,
        dropOffLocationLatitude: request.dropOffLocationLatitude,
        dropOffLocationLongitude: request.dropOffLocationLongitude,
        fare: request.fare,
        riderType: request.riderType,
        declinedUsersIdList:
            UserType.business.name == getUserType() ? [] : declinedUsersIdList,
      ),
    );
  }

  static String? getUserType() {
    return _localStorage.getUserType(LocalStorageKeys.usertype);
  }

  static void setUserType(String userType) {
    _localStorage.setValue(LocalStorageKeys.usertype, userType);
  }

  static UserModel? getUser() {
    return _localStorage.getValue(
        LocalStorageKeys.usertype, UserModel.fromJson);
  }

  static String? getUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static void setUser(UserModel user) {
    _localStorage.setValue(LocalStorageKeys.usertype, UserModel.fromJson);
  }

  static Future<Position?> getLocation() async {
    log('came in getLocation');
    Position? position;
    try {
      position = await LocationServices.getCurrentLocation();
    } catch (e) {
      if (e.toString() != "Location services not enabled") {
        throw const LocationServiceDisabledException();
      }
    }
    return position;
  }

  static void setDriverWorkStatus(bool status) {
    _isDriverOnline = status;
  }

  static bool getDriverWorkStatus() {
    return _isDriverOnline;
  }

  static Future<Uint8List> getImageFromBytes(int width, String path) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!
        .buffer
        .asUint8List();
  }

  static Future<String> getAddress(LatLng position) async {
    List<Placemark> placeMark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark address = placeMark[0];
    String newAddress =
        "${address.street}, ${address.subLocality},${address.locality},${address.administrativeArea}";
    return newAddress;
  }
}
