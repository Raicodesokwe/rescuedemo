import 'package:flutter/material.dart';

import '../utils/common_functions.dart';
import '../utils/constants.dart';
import 'selection_box.dart';

class SelectionSection extends StatelessWidget {
  const SelectionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
              SelectionBox(svgImage: yellowBox),
              SelectionBox(svgImage: purpleBox),
           ],
         ),
         SizedBox(height: screenHeight(context) * .02,),
    const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
          SelectionBox(svgImage: redBox),
          SelectionBox(svgImage: pinkBox),
       ],
     ),
      ],
    );
  }
}

