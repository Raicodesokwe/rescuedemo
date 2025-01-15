import 'package:flutter/material.dart';
import 'package:rescuedemo/screens/sos_map.dart';
import 'package:rescuedemo/utils/constants.dart';
import 'package:rescuedemo/utils/navigation_utils.dart';
import 'package:rescuedemo/widgets/preferences_list.dart';
import '../utils/common_functions.dart';
import '../widgets/banner_image.dart';
import '../widgets/see_all_items.dart';
import '../widgets/selection_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
   late AnimationController controller;
  late Animation<double> fadeAnimation;
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;
  @override
  void initState() {
   controller =
        AnimationController(vsync: this, duration:const Duration(milliseconds: 200));
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(controller);
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    scaleAnimation =
        CurvedAnimation(parent: scaleController, curve: Curves.elasticInOut);
    Future.delayed(const Duration(milliseconds: 600), () {
      controller.forward().then((value) => scaleController.forward());
    });
    super.initState();
   
  }

  @override
  void dispose() {
    controller.dispose();
    scaleController.dispose();
    super.dispose();
    
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      floatingActionButton: FloatingActionButton(
     
        backgroundColor: AppColors.appRed,
        onPressed: (){
        openScreen(context,const SosMapScreen());
      },   child: const Icon(Icons.location_on,color: Colors.white,),),
      body: FadeTransition(
        opacity: fadeAnimation,
        child:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight(context) * .03,),
              const  Text('Hi there,',style: TextStyle(
                  fontFamily: clashDisplay,
                  fontWeight: FontWeight.w600,
                  fontSize: 20
                ),),
                SizedBox(height: screenHeight(context) * .01,),
               const Text('Select one of our cover options',style: TextStyle(
                  fontSize: 16
                ),),
                   SizedBox(height: screenHeight(context) * .01,),
                 const SeeAllItems(icon: Icons.keyboard_arrow_right,label: 'Cover Options',secondLabel: 'See All'),
                  SizedBox(height: screenHeight(context) * .01,),
               ScaleTransition(
                scale: scaleAnimation,
                child: const SelectionSection()), 
                 
                  SizedBox(height: screenHeight(context) * .03,),
                const  BannerImage(),
                  SizedBox(height: screenHeight(context) * .03,),
                const SeeAllItems(icon: Icons.settings,label: 'Your Preferences',secondLabel: 'Change'),
                SizedBox(height: screenHeight(context) * .02,),
              const PreferencesList(),
              const SizedBox(height: 70,)
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

