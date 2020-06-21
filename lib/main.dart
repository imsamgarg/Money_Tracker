import 'package:flutter/material.dart';
import 'package:newmoneytracker/Data/Data.dart';
import 'package:newmoneytracker/Screens/history.dart';
import 'package:provider/provider.dart';
import 'Data/constants.dart';
import 'Screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context)=>Data(),
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          accentColor: accentColor,
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
        ),
        routes: {
          History.route:(context)=>History(),
          HomeScreen.route:(context)=>HomeScreen()
        },
        initialRoute: HomeScreen.route,
      ),
    );
  }
}
