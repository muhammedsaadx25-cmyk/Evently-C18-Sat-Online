import 'package:evently_sat_online/core/prefs_manager/prefs_manager.dart';
import 'package:flutter/material.dart';

class LangProvider extends ChangeNotifier{
  String currentLang = PrefsManager.getLanguage() ?? "en";
 bool get isEnglish=> currentLang == 'en';
  void updateAppLang(String newLang){
    if(currentLang == newLang) return;
    currentLang = newLang;
    PrefsManager.saveLanguage(currentLang);
    notifyListeners();
  }
}