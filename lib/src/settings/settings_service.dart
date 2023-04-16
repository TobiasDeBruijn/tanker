import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  Future<ThemeMode> themeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch(prefs.getString("ThemeMode")) {
      case "Dark":
        return ThemeMode.dark;
      case "Light":
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String themeModeStr;
    switch(theme) {
      case ThemeMode.dark:
        themeModeStr = "Dark";
        break;
      case ThemeMode.light:
        themeModeStr = "Light";
        break;
      default:
        themeModeStr = "System";
        break;
    }

    await prefs.setString("ThemeMode", themeModeStr);
  }
}
