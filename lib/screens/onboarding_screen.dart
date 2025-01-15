import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rescuedemo/provider/map_provider.dart';
import 'package:rescuedemo/screens/home_screen.dart';
import 'package:rescuedemo/utils/constants.dart';
import 'package:rescuedemo/utils/navigation_utils.dart';
import 'package:rescuedemo/widgets/common_button.dart';

import '../utils/common_functions.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
    Future<void> _getCurrentLocation() async {
    try {
      if (await checkLocationPermissions()) {
        if(mounted){
          await Provider.of<MapProvider>(context, listen: false)
            .setCurrentLocation();
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
  @override
  void initState() {
      WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await getPermissions();
          _checkIfLocationServiceIsEnabled();
          _getCurrentLocation();
        
      },
    );
  
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: AppColors.appRed,
      body: Column(
        
        children: [
           SizedBox(height: screenHeight(context) * .05,),
            Center(
              child: Text('Rescue.co',style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: clashDisplay,
                fontSize: screenWidth(context) * .1
              ),),
            ),
            SizedBox(height: screenHeight(context) * .1,),
            Container(
              height: 272,
              width: 272,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
              ),
              child: Center(
                child: SvgPicture.asset(ambulanceIcon),
              ),
            ),
              SizedBox(height: screenHeight(context) * .1,),
              SizedBox(
                width: screenWidth(context) * .9,
                child: const Center(
                  child:  Text('Leading Emergency Rescue services provider in East Africa',style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                  ),),
                ),
              ),
                   SizedBox(height: screenHeight(context) * .01,),
                    SizedBox(
                width: screenWidth(context) * .9,
                child: const Center(
                  child:  Text('Live worry free by selecting one of our multiple cover choices',style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),),
                ),
              ),
              SizedBox(height: screenHeight(context) * .05,),
             GestureDetector(
              onTap: (){
                openScreen(context, const HomeScreen());
              },
              child: const CommonButton())
        ],
      ),
    ));
  }
}