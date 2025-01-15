//screen size
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
//check if location permissions are enabled
Future<bool> checkIfLocationServiceIsEnabled() async {
  return await Geolocator.isLocationServiceEnabled();
}

showInformationDialog(
    {required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onTap}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: onTap,
              child: const Text(
                'Enable',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        );
      });
}
Future<void> getPermissions() async {
  await [
    Permission.location,
    Permission.camera,
  ].request();
}
Future<bool> checkLocationPermissions() async {
  /**Check permission is allowed*/
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showToast('Location permissions denied');
      return false;
    }
  }

  /**Check if service is enabled*/
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showToast('Enable location services');
    return false;
  }

  if (permission == LocationPermission.deniedForever) {
    showToast('Permission permanently denied');
    return false;
  }
  return true;
}
 Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    try {
      final result = await http.get(uri, headers: headers);
      if (result.statusCode == 200) {
        return result.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
  void showToast(String message) {
  Fluttertoast.showToast(
      msg: message, // message
      toastLength: Toast.LENGTH_SHORT, // length
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey // location
      // timeInSecForIos: 1               // duration
      );
}
Future<bool> checkInternetConnection() async {
  bool connected = false;

    final response = await InternetAddress.lookup('www.google.com');
    if (response.isNotEmpty) {
      connected = true;
    }
 
  if (connected) log("Internet connected");
  if (!connected) showToast("No Internet Connection");
  return connected;
}