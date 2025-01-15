import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rescuedemo/provider/map_provider.dart';

import '../../models/place_model.dart';
import '../../utils/common_functions.dart';
import '../../utils/constants.dart';
import '../utils/navigation_utils.dart';

class SosMapScreen extends StatefulWidget {
  const SosMapScreen({super.key});

  @override
  State<SosMapScreen> createState() => _SosMapScreenState();
}

class _SosMapScreenState extends State<SosMapScreen> {
  final textController = TextEditingController();
  bool hasRunFirstTimeCode = false;
  GoogleMapController? mapController;
  double _selectedLat = -1.2460134;
  double _selectedtLng = 36.7762849;
  double cameraZoom = 13.toDouble();

  final Set<Marker> _markers = {};

  ///**Check whether the map view is satellite*///
  bool _isSatellite = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (mapController != null) {
      mapController!.showMarkerInfoWindow(const MarkerId("markerId"));
    }
  }

  void _addMarker(LatLng? latLng) {
    // Set Current Location From View Model
    MapProvider appViewModel =
        Provider.of<MapProvider>(context, listen: false);
    if (latLng == null && appViewModel.currentLocation != null) {
      _selectedLat = appViewModel.currentLocation!.latitude;
      _selectedtLng = appViewModel.currentLocation!.longitude;
    } else {
      log("CURRENT LOCATION NOT SET");
    }

    _markers.clear();
    setState(() {
      _markers.add(
        Marker(
            draggable: true,
            markerId: const MarkerId('markerId'),
            position: CameraPosition(
                    target: LatLng(_selectedLat, _selectedtLng),
                    zoom: cameraZoom)
                .target,
            icon: BitmapDescriptor.defaultMarker,
            infoWindow:const InfoWindow(title: 'Hold To Move Me'),
            onDrag: _setMoveMarkerLocation),
      );
    });
    //Todo
    _moveCamera();
  }

  //OnDrag
  void _setMoveMarkerLocation(LatLng newLocation) {
    MapProvider mapProvider =
        Provider.of<MapProvider>(context, listen: false);
    setState(() {
      _selectedLat = newLocation.latitude;
      _selectedtLng = newLocation.longitude;
       //Set Distress LatLng
      mapProvider.distressLatitude =
          newLocation.latitude;
      mapProvider.distressLongitude =
          newLocation.longitude;
      
    });
    _addMarker(newLocation);
  }

  void _moveCamera() {
    //move the Camera
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(_selectedLat, _selectedtLng), zoom: cameraZoom),
        ),
      );
    }
  }

  void _getCurrentLocation() async {
      MapProvider mapProvider =
        Provider.of<MapProvider>(context, listen: false);
    await Geolocator.getCurrentPosition().then((value) => {
          setState(() {
            _selectedLat = value.latitude;
            _selectedtLng = value.longitude;
              //Set Distress LatLng
      mapProvider.distressLatitude =
          value.latitude;
      mapProvider.distressLongitude =
          value.longitude;
            
          })
        });
    _addMarker(null);
  }


  @override
  void dispose() {
    if (mapController != null) {
      mapController!.dispose();
    }
    super.dispose();
  }

  Future<void> _checkIfLocationServiceIsEnabled() async {
    if (!await checkIfLocationServiceIsEnabled()) {
      log("LOCATION DISABLED");
      if (mounted) {
        showInformationDialog(
            context: context,
            title: "Enable Location",
            message: "This App works well when location is enabled.",
            onTap: () async {
              navigationPop(context);
              await Geolocator.openLocationSettings();
            });
      }
    } else {
      log("LOCATION ENABLED");
    }
  }

  @override
  void didChangeDependencies() {
    if (!hasRunFirstTimeCode) {
      setState(() {
        hasRunFirstTimeCode = true;
      });
      _addMarker(null);
      _getCurrentLocation();
    }
    _checkIfLocationServiceIsEnabled();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    MapProvider mapProvider = context.watch<MapProvider>();
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight(context),
          width: screenWidth(context),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: screenHeight(context),
                  child: Stack(
                    children: [
                      GoogleMap(
                          onMapCreated: _onMapCreated,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          markers: _markers,
                          mapType:
                              _isSatellite ? MapType.satellite : MapType.normal,
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(_selectedLat, _selectedtLng),
                              zoom: 18)),
                      if (
                          mapProvider.searchResults.isNotEmpty)
                        Padding(
                          padding:  EdgeInsets.only(top: screenHeight(context) * .22),
                          child: Container(
                            height: 300.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.6),
                                backgroundBlendMode: BlendMode.darken),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: mapProvider.searchResults.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      mapProvider
                                          .searchResults[index].description,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    onTap: () async {
                                      //Set Description to textView
                                      textController.text = mapProvider
                                          .searchResults[index].description;
                                      textController.selection =
                                          TextSelection.fromPosition(TextPosition(
                                              offset:
                                                  textController.text.length));
                                      //Get place Id
                                      bool getPlace = await mapProvider
                                          .setSelectedLocation(mapProvider
                                              .searchResults[index].placeId);
                                      //Clear Search Results
                                      mapProvider.clearSearchPlaces();
                              
                                      if (getPlace &&
                                          mapProvider
                                                  .selectedLocationFromAutoComplete !=
                                              null) {
                                        //Set Marker
                                        Place place = mapProvider
                                            .selectedLocationFromAutoComplete!;
                                        _setMoveMarkerLocation(LatLng(
                                            place.geometry.location.latitude,
                                            place.geometry.location.longitude));
                                          //Set Distress LatLng
                              mapProvider.distressLatitude =
                                  place.geometry.location.latitude;
                              mapProvider.distressLongitude =
                                  place.geometry.location.longitude;
                                        
                                      }
                                    },
                                  );
                                }),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 40.0, right: 15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  //Clear Search Results
                                  mapProvider.clearSearchPlaces();
                                  navigationPop(context);
                                },
                                icon: Icon(Icons.close,
                                    size: 30,
                                    color: _isSatellite
                                        ? Colors.white
                                        : Colors.black))
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          height: 45.0,
                          child: Row(
                            children: [
                              Flexible(
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.black),
                                  controller: textController,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    suffixIcon:const Icon(Icons.search),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                      borderRadius: BorderRadius.circular(12.7),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                      borderRadius: BorderRadius.circular(12.7),
                                    ),
                                    border: const OutlineInputBorder(),
                                    hintText: 'Search to filter',
                                  ),
                                  onChanged: (value) {
                                    mapProvider.searchPlaces(value);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              SizedBox(
                                width: 60,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.appRed),
                                  onPressed: () => _getCurrentLocation(),
                                  child: const Icon(Icons.my_location,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            Text(
                              'Hold and move the marker to the\n exact location'
                                  ,
                              style: TextStyle(
                                  color:
                                      _isSatellite ? Colors.white : Colors.black),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 50.0, right: 15.0, bottom: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: Colors.white,
                              height: 40.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isSatellite = false;
                                        });
                                      },
                                      child: Text(
                                        'Map',
                                        style: TextStyle(
                                            color: _isSatellite
                                                ? Colors.black
                                                : Colors.grey),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isSatellite = true;
                                        });
                                      },
                                      child: Text(
                                        'Satellite',
                                        style: TextStyle(
                                            color: _isSatellite
                                                ? Colors.grey
                                                : Colors.black),
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                              ),
                                backgroundColor: AppColors.appRed),
                            onPressed: () {
                             
                               showToast("Distress Location Selected. Latitude is ${mapProvider.distressLatitude!.toStringAsFixed(2)} and Longitude is ${mapProvider.distressLongitude!.toStringAsFixed(2)}");
                              
                              navigationPop(context);
                            },
                            child:const Text(
                              'Save',
                              style:  TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextButton(
                            onPressed: () {
                              //Clear Search Results
                              mapProvider.clearSearchPlaces();
                              navigationPop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 15.0,
                                  color:
                                      _isSatellite ? Colors.white : Colors.black),
                            ))
                      ],
                    ),
                  )),
            ],
          ),
        ),
      )),
    );
  }
}
