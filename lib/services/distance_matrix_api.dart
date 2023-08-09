import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:driver_app/models/location_model/location.dart';
import 'package:driver_app/utils/constants.dart';

class DistanceMatrixAPI {
  static Future getMatrix(
    Location pickupLocation,
    Location dropOffLocation,
  ) async {
    try {
      String origin = "${pickupLocation.latitude},${pickupLocation.longitude}";
      String destination =
          "${dropOffLocation.latitude},${dropOffLocation.longitude}";
      String url =
          "$initialUrl&origins=$origin&destinations=$destination&key=$googleMapsApiKey";
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        log(response.body);
        log("Status code in distance matrix: ${response.statusCode.toString()}");
        return null;
      }
    } catch (e) {
      log("Exception in distance matrix: ${e.toString()}");
    }
  }

  static Future<String> getDistance(
    Location pickupLocation,
    Location dropOffLocation,
  ) async {
    String distance = '0.0 mile';
    try {
      String body = await getMatrix(pickupLocation, dropOffLocation);
      var data = jsonDecode(body);
      String miles = data['rows'][0]['elements'][0]['distance']['text'];
      List list = miles.split(' ');
      double d = double.parse(list[0]) * 1.60934;
      distance = "${d.toStringAsFixed(2)} km";
    } catch (e) {
      log("Exception in distance matrix distance func: ${e.toString()}");
    }
    return distance;
  }

  static Future<String> getTime(
    Location pickupLocation,
    Location dropOffLocation,
  ) async {
    String duration = "0 min";
    try {
      String body = await getMatrix(pickupLocation, dropOffLocation);
      var data = jsonDecode(body);
      duration = data['rows'][0]['elements'][0]['duration']['text'];
    } catch (e) {
      log("Exception in distance matrix distance func: ${e.toString()}");
    }
    return duration;
  }
}
