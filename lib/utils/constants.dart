import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//Colors
class AppColors {
  static const appRed = Color(0xffFF4E39);
  static const appDarkGrey = Color(0xff323232);
}
//fonts
const String clashDisplay='ClashDisplay';
//assetpath
const String assetPath='assets/images/';
//images and icons
const String ambulanceIcon='${assetPath}ambulance.svg';
const String yellowBox='${assetPath}yellow-box.svg';
const String purpleBox='${assetPath}purple-box.svg';
const String redBox='${assetPath}red-box.svg';
const String pinkBox='${assetPath}pink-box.svg';
const String sosCallIcon='${assetPath}sos-call.svg';
const String doctorIcon='${assetPath}doctor.svg';
const String hospitalIcon='${assetPath}hospital.svg';
//keys
String kGoogleApiKey = dotenv.env['KGOOGLE_API_KEY']!;
//Errors
const noInternet = 100;
const apiError = 101;
const fileNotUploaded = 102;
const unknownError = 103;
const emptyFieldError = 104;
const unauthorizedError = 401;
//success codes
const successCode = 200;
const successCreated = 201;
const successCodes = [200, 201, 202, 204];
const paymentNotFound = 404;
const failureCodes = [400, 401, 402, 404];