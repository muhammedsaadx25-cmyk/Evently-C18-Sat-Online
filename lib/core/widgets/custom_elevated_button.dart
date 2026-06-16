import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
   CustomElevatedButton({super.key,required this.title,this.onClick});
String title;
VoidCallback? onClick;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onClick, child:Text(title));
  }
}
