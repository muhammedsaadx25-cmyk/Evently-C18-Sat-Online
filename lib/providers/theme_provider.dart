import 'package:evently_sat_online/core/prefs_manager/prefs_manager.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeMode currentTheme =   PrefsManager.getSavedTheme() ?? ThemeMode.light;
  bool get isDark => currentTheme == ThemeMode.dark;
  void updateAppTheme(ThemeMode newTheme){
    currentTheme = newTheme;
    PrefsManager.saveTheme(currentTheme);
    notifyListeners();
  }



}