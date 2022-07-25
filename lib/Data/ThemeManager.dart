import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class ThemeManager extends ChangeNotifier {
  final Color accentColor;
  ThemeData lightTheme = ThemeData.light();
  ThemeData darkTheme = ThemeData.dark();
  ThemeMode themeMode;

  ThemeManager({required this.themeMode, required this.accentColor})
      : lightTheme = ThemeData.light().copyWith(
          textSelectionHandleColor: accentColor,
          cursorColor: accentColor,
          appBarTheme: AppBarTheme(color: accentColor),
          toggleableActiveColor: accentColor,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: accentColor.withOpacity(0.6),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
          ),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: accentColor),
        ),
        darkTheme = ThemeData.dark().copyWith(
          textSelectionHandleColor: accentColor,
          toggleableActiveColor: accentColor,
          cursorColor: accentColor,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: accentColor.withOpacity(0.6),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
          ),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: accentColor),
        );

  Future<bool> changeAccentColor(
      Color color, SharedPreferences sharedPreferences) async {
    lightTheme = lightTheme.copyWith(
      textSelectionHandleColor: color,
      appBarTheme: AppBarTheme(color: color),
      toggleableActiveColor: color,
      cursorColor: color,
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color.withOpacity(0.6),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: color),
    );
    darkTheme = darkTheme.copyWith(
      toggleableActiveColor: color,
      cursorColor: color,
      textSelectionHandleColor: color,
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color.withOpacity(0.6),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: color),
    );
    try {
      bool temp = await sharedPreferences.setInt(sharedColorKey, color.value);
      if (temp) {
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> changeThemeMode(
      ThemeMode themeMode, SharedPreferences sharedPreferences) async {
    try {
      bool temp =
          await sharedPreferences.setInt(sharedThemeModeKey, themeMode.index);
      if (temp) {
        this.themeMode = themeMode;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      throw (e);
    }
  }
}
