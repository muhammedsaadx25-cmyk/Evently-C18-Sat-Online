import 'package:evently_sat_online/core/resources/colors_manager.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
   CustomTextButton({super.key, required this.title, this.align = TextAlign.center,  this.onTap});
String title;
TextAlign align;
VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return  InkWell(
        onTap:onTap,
        child: Text(title,

          textAlign: align,style: Theme.of(context).textTheme.titleLarge,

         ));
  }
}
