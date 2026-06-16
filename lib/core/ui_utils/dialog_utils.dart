import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogUtils{
 static void showLoading(BuildContext context, {bool dismissible = true}){
    showDialog(
      barrierDismissible: dismissible,
        context: context, builder: (context)=> PopScope(
      canPop: dismissible,
          child: AlertDialog(content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
          Center(child: CircularProgressIndicator(),),
                ],
              )),
        ));
  }

  static void hideDialog(BuildContext context){
   Navigator.pop(context);
  }


  static void showToastMessage({required String message,required Color bgColor, }){
    Fluttertoast.showToast(
        msg:message,

        gravity: ToastGravity.BOTTOM,

        backgroundColor: bgColor,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

