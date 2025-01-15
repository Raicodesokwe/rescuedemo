import 'package:flutter/material.dart';

class SeeAllItems extends StatelessWidget {
  final String label;
  final String secondLabel;
  final IconData icon;
  const SeeAllItems({
    super.key,
    required this.label,
    required this.secondLabel,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         Text(label,style:const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600
         ),),
         const Spacer(),
          Text(secondLabel,style: TextStyle(
            color: const Color(0xFF323232).withOpacity(.77)
          ),),
      Icon(icon,color: const Color(0xFF323232).withOpacity(.77),),
      ],
    );
  }
}

