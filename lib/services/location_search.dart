import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:driver_app/utils/constants.dart';

class LocationSearch {
  static Future<List> getSuggestions(String input, String sessionToken) async {
    List<dynamic> places = [];
    try {
      String request =
          '$googleMapsBaseUrl?input=$input&key=$googleMapsApiKey&sessiontoken=$sessionToken';
      log("uri");
      log(Uri.parse(request).toString());
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        places = jsonDecode(response.body.toString())['predictions'];
      } else {
        log(response.statusCode.toString());
      }
    } catch (e) {
      log("Location Search File :${e.toString()}");
    }
    return places;
  }
}
