import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/common_functions.dart';
import '../utils/constants.dart';
import 'common_button.dart';

class BannerImage extends StatelessWidget {
  const BannerImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 17,vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.appRed,
        borderRadius: BorderRadius.circular(17)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(sosCallIcon),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const Text('Get Annual Cover',style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20
                ),),
               const SizedBox(height: 4,),
                SizedBox(
                  width: screenWidth(context) * .3,
                  child:const Text('Starting from as little as 4,000 Ksh per year',style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  ),)),
                  const SizedBox(height: 10,),
                  CommonButton(
                    width: screenWidth(context) * .4,
                    height: 37,
                    label: 'Get Annual Cover',
                    fontSize: 14,
                    fontColor: Colors.black,
                  )
            ],
          )
        ],
      ),
    );
  }
}

