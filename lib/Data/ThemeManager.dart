import 'dart:async';
import 'package:flutter/material.dart';
import 'package:newmoneytracker/Data/Themes.dart';
import 'package:provider/provider.dart';
// import 'constants.dart';

class ThemeManager {
  final StreamController<ThemeData> _themeController=StreamController<ThemeData>();

  Future changeTheme(int themeIndex)async{
    ThemeData newTheme=_themes[themeIndex];
    // Theme.of(context).copyWith(accentColor: );
    _themeController.sink.add(newTheme);
  }

  Future changeToThemeLight(int index)async{
    ThemeData _themeData=ThemeData();
  }
  final List _themes=[
    theme1,
    theme2,
    theme3,
    theme4,
    theme5,
    theme6,
    theme7,
    theme8,
  ];

  Stream<ThemeData> get theme => _themeController.stream;

}