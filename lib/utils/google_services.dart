import 'dart:convert';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/directions_model.dart';
import '../models/place_model.dart';
import '../models/place_search.dart';
import '../utils/constants.dart';
import 'api_status.dart';
import 'common_functions.dart';

class GoogleServices {
  static Future<Object> getDirections(
      {required LatLng origin, required LatLng destination}) async {
    try {
      if (!await checkInternetConnection()) {
        return Failure(code: noInternet, errorResponse: "No Internet");
      }

      var url =
          Uri.parse('https://maps.googleapis.com/maps/apis/directions/json?');

      var urli = Uri.parse(
          "https://maps.googleapis.com/maps/api/directions/json?destination=${destination.latitude},${destination.longitude}&origin=${origin.latitude},${origin.longitude} &key=$kGoogleApiKey");

      log("DIRECTIONS : $url");
      var response = await http.get(urli);

      log("RESPONSE : ${response.body.toString()}");

      if (response.statusCode == successCode) {
        return Success(
          code: successCode,
          response: Directions.fromMap(jsonDecode(response.body)),
        );
      } else {
        return Failure(
          code: unknownError,
          errorResponse: response.body,
        );
      }
    } catch (e) {
      log(e.toString());
      return Failure(code: unknownError, errorResponse: e);
    }
  }

 

  Future<Object> getPlace(String placeId) async {
    try {
      if (!await checkInternetConnection()) {
        return Failure(code: noInternet, errorResponse: "No Internet");
      }

      var url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$kGoogleApiKey');

      log("GETPLACE DETAILS : $url");

      var response = await http.get(url);
      log("RESPONSE : ${response.body.toString()}");
      var json = jsonDecode(response.body);
      var jsonResult = json['result'] as Map<String, dynamic>;
      Place place = Place.fromJson(jsonResult);

      if (response.statusCode == successCode) {
        return Success(code: successCode, response: place);
      } else {
        return Failure(
          code: unknownError,
          errorResponse: response.body,
        );
      }
    } catch (e) {
      log(e.toString());
      return Failure(code: unknownError, errorResponse: e);
    }
  }

  Future<Object> getPlaces(double lat, double lng, String placeType) async {
    try {
      if (!await checkInternetConnection()) {
        return Failure(code: noInternet, errorResponse: "No Internet");
      }

      var url = Uri.https('maps.googleapis.com',
          '/maps/api/place/textsearch/json?location=$lat,$lng&type=$placeType&rankby=distance&key=$kGoogleApiKey');
      var response = await http.get(url);
      var json = jsonDecode(response.body);
      var jsonResults = json['results'] as List;
      List<Place> places =
          jsonResults.map((place) => Place.fromJson(place)).toList();

      log("RESPONSE : ${response.toString()}");

      if (response.statusCode == successCode) {
        return Success(code: successCode, response: places);
      } else {
        return Failure(
          code: unknownError,
          errorResponse: response.body,
        );
      }
    } catch (e) {
      log(e.toString());
      return Failure(code: unknownError, errorResponse: e);
    }
  }
 Future<Object> getAutocomplete(
      {required String search}) async {
    try {
      if (!await checkInternetConnection()) {
        return Failure(code: noInternet, errorResponse: "No Internet");
      }

      var url = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&libraries=places&key=$kGoogleApiKey");

      log("AUTOCOMPLETE : $url");

      var response = await http.get(url);
      log("RESPONSE : ${response.body.toString()}");
      var json = jsonDecode(response.body);
      var jsonResults = json['predictions'] as List;
      List<PlaceSearch> list =
          jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();

      if (response.statusCode == successCode) {
        return Success(code: successCode, response: list);
      } else {
        return Failure(
          code: unknownError,
          errorResponse: response.body,
        );
      }
    } catch (e) {
      log(e.toString());
      return Failure(code: unknownError, errorResponse: e);
    }
  }
  Future<Object> getCurrentLocation() async {
    try {
      if (!await checkInternetConnection()) {
        return Failure(code: noInternet, errorResponse: "No Internet");
      }

      log("GETTING CURRENT LOCATION");
      Position? position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      log("RESPONSE : $position");

        return Success(code: successCode, response: position);
      
    } catch (e) {
      log(e.toString());
      return Failure(code: unknownError, errorResponse: e);
    }
  }
}
