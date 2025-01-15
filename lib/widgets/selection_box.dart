import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/common_functions.dart';

class SelectionBox extends StatelessWidget {
  final String svgImage;
  const SelectionBox({
    super.key,
    required this.svgImage
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
              width: screenWidth(context) * .42,
              child: SvgPicture.asset(svgImage));
  }
}