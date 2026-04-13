import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void saveTheme(ThemeMode theme) {
    String cachedTheme = theme == ThemeMode.light ? "Light" : "Dark";
    prefs.setString("themeKey", cachedTheme);
  }

  static ThemeMode? getSavedTheme() {
    String? cachedTheme = prefs.getString("themeKey");
    if (cachedTheme == null) {
      return null;
    } else {
      if (cachedTheme == "Light") {
        return ThemeMode.light;
      } else {
        return ThemeMode.dark;
      }
    }
  }


 static void  saveLanguage(String lang){
    prefs.setString("languageKey", lang);
  }

 static String?  getLanguage(){
   return prefs.getString("languageKey");
  }
}


