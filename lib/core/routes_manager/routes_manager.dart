import 'package:evently_sat_online/features/auth/login/login_screen.dart';
import 'package:evently_sat_online/features/auth/register/register_screen.dart';
import 'package:evently_sat_online/features/create_event/create_event.dart';
import 'package:evently_sat_online/features/home/home_screen.dart';
import 'package:flutter/cupertino.dart';

class RoutesManager{
  static const String login = '/login';
  static const String register = '/register';
  static const String homeScreen = '/homeScreen';
  static const String createEvent = '/createEvent';
  static Route? router(RouteSettings settings){
    switch(settings.name){
      case login:{
        return CupertinoPageRoute(builder: (_)=>LoginScreen());
      }
      case register:{
        return CupertinoPageRoute(builder: (_)=>RegisterScreen());
      }
      case homeScreen:{
        return CupertinoPageRoute(builder: (_)=>HomeScreen());
      }
      case createEvent:{
        return CupertinoPageRoute(builder: (_)=>CreateEvent());
      }
    }
  }
}

