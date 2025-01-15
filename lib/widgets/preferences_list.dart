import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rescuedemo/models/preferences_model.dart';

import '../utils/constants.dart';

class PreferencesList extends StatelessWidget {
  const PreferencesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(preferencesList.length, (index) =>    AnimationConfiguration.staggeredList(
         position: index,
                 duration: const Duration(seconds: 1),
        child: SlideAnimation(
          verticalOffset: 50.0, 
          child: Padding(
            padding: const EdgeInsets.only(bottom:8.0),
            child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      tileColor: const Color(0xFFf6f6f6),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.appRed,
                          borderRadius: BorderRadius.circular(4),
                          
                        ),
                        child: SvgPicture.asset(preferencesList[index].leadingIcon),
                      ),
                      title: Text(
                        preferencesList[index].title,
                        style:const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black
                        ),
                      ),
                      subtitle: Text(
                        'Preferred ${preferencesList[index].subTitle}',
                        style:const TextStyle(
                          fontSize: 12,
                          color: Colors.black45
                        ),
                      ),
                      trailing:const Icon(Icons.keyboard_arrow_right),
                    ),
          ),
        ),
      )),
    );
  }
}