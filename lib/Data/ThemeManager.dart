import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class ThemeManager extends ChangeNotifier {
  final Color accentColor;
  ThemeData lightTheme = ThemeData.light();
  ThemeData darkTheme = ThemeData.dark();
  ThemeMode themeMode;

  ThemeManager({this.themeMode, this.accentColor})
      : lightTheme = ThemeData.light().copyWith(
          accentColor: accentColor,
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
        ),
        darkTheme = ThemeData.dark().copyWith(
          accentColor: accentColor,
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
        );

  Future<bool> changeAccentColor(
      Color color, SharedPreferences sharedPreferences) async {
    lightTheme = lightTheme.copyWith(
      accentColor: color,
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
    );
    darkTheme = darkTheme.copyWith(
      accentColor: color,
      // iconTheme: IconThemeData(),
      // appBarTheme: AppBarTheme(color: color),
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
