import 'dart:developer';

import 'package:geolocator/geolocator.dart';

import 'package:driver_app/controllers/global_controller.dart';

class LocationServices {
  static Future<Position?> getCurrentLocation() async {
    Position? position;
    LocationPermission permission;
    try {
      await Geolocator.isLocationServiceEnabled();
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        Geolocator.openLocationSettings();
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      log(e.toString());
    }
    if (position == null) {
      GlobalController.getLocation();
    }
    return position;
  }
}
