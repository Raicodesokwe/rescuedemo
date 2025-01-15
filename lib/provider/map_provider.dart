
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rescuedemo/models/place_search.dart';
import 'dart:async';

import '../models/directions_model.dart';
import '../models/geometry_model.dart';
import '../models/location_model.dart';
import '../models/place_model.dart';
import '../utils/api_status.dart';
import '../utils/google_services.dart';


class MapProvider with ChangeNotifier {
  

  GoogleServices googleServices = GoogleServices();

  

  //Setting Loading==============
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

//Setting Error==============
  ApiError? _apiError;

  ApiError? get apiError => _apiError;

  setApiError(ApiError apiError) async {
    _apiError = apiError;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2), () => _apiError = null);
  }
double? distressLatitude;
double? distressLongitude;
  Directions? _directions;

  Directions? get directions => _directions;

// Fetch Fetch Directions
  Future<void> fetchDirections(
      {required LatLng origin, required LatLng destination}) async {
    setLoading(true);
    var response = await GoogleServices.getDirections(
        origin: origin, destination: destination);
    setLoading(false);

    if (response is Success) {
      _directions = response.response as Directions?;
    }

    // Check Status
    if (response is Failure) {
      ApiError apiError = ApiError(
        code: response.code,
        message: response.errorResponse,
      );
      setApiError(apiError);
      return;
    }
    notifyListeners();
  }

  // Fetch Current location
  Position? _currentLocation;

  Position? get currentLocation => _currentLocation;

  Place? _selectedLocationStatic;
    Place? get selectedLocationStatic => _selectedLocationStatic;

  Future<void> setCurrentLocation() async {
    log("GETTING CURRENT LOCATION");
    var response = await googleServices.getCurrentLocation();
    if (response is Success) {
      Position place = response.response as Position;

      _currentLocation = place;
      _selectedLocationStatic = Place(
        name: '',
        geometry: Geometry(
          location: Location(
              latitude: _currentLocation!.latitude,
              longitude: _currentLocation!.longitude),
        ),
        vicinity: '',
      );
    }

    // Check Status
    if (response is Failure) {
      ApiError apiError = ApiError(
        code: response.code,
        message: response.errorResponse,
      );
      setApiError(apiError);
      return;
    }
    notifyListeners();
  }

  List<PlaceSearch> _searchResults = [];

  List<PlaceSearch> get searchResults => _searchResults;

  Future<void> clearSearchPlaces() async {
    _searchResults.clear();
    notifyListeners();
  }

  Future<void> searchPlaces(String searchTerm) async {
   
    setLoading(true);
    var response = await googleServices.getAutocomplete(
        search: searchTerm);
    setLoading(false);

    if (response is Success) {
      _searchResults = response.response as List<PlaceSearch>;
    }

    // Check Status
    if (response is Failure) {
      ApiError apiError = ApiError(
        code: response.code,
        message: response.errorResponse,
      );
      setApiError(apiError);
      return;
    }
    notifyListeners();
  }

  StreamController<Place> selectedLocationStream = StreamController<Place>();
  StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>();
  Place? _selectedLocationFromAutoComplete;

  Place? get selectedLocationFromAutoComplete =>
      _selectedLocationFromAutoComplete;

  Future<bool> setSelectedLocation(String placeId) async {
    setLoading(true);
    var response = await googleServices.getPlace(placeId);
    setLoading(false);

    if (response is Success) {
      Place place = response.response as Place;
      // selectedLocationStream.add(place);
      _selectedLocationFromAutoComplete = place;
      // _searchResults = [];
    }

    // Check Status
    if (response is Failure) {
      ApiError apiError = ApiError(
        code: response.code,
        message: response.errorResponse,
      );
      setApiError(apiError);
      return false;
    }
    notifyListeners();
    return true;
  }


  @override
  void dispose() {
    selectedLocationStream.close();
    bounds.close();
    super.dispose();
  }
}
