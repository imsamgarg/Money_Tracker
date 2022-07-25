import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newmoneytracker/Data/Data.dart';
import 'package:newmoneytracker/Data/ThemeManager.dart';
import 'package:newmoneytracker/Data/constants.dart';
import 'package:newmoneytracker/Screens/backup_screen.dart';
import 'package:newmoneytracker/Screens/history.dart';
import 'package:newmoneytracker/Screens/theme_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Data/Backup.dart';
import 'Data/User.dart';
import 'Screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityResult>.value(
          initialData: ConnectivityResult.none,
          value: Connectivity().onConnectivityChanged,
        ),
        FutureProvider(
          initialData: null,
          create: (BuildContext context) {
            return SharedPreferences.getInstance();
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Data(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Backup(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => UserData(),
        ),
      ],
      child: Consumer<SharedPreferences?>(
        builder: (context, value, child) {
          final _accentColor = value?.getInt(sharedColorKey) == null
              ? blueAccentColor
              : Color(value!.getInt(sharedColorKey)!);
          final _themeMode = value?.getInt(sharedThemeModeKey) == null
              ? ThemeMode.system
              : ThemeMode.values[value!.getInt(sharedThemeModeKey)!];
          return ChangeNotifierProvider(
            create: (BuildContext context) => ThemeManager(
              accentColor: _accentColor,
              themeMode: _themeMode,
            ),
            child: Consumer<ThemeManager>(
              builder: (BuildContext context, value, Widget? child) {
                return MaterialApp(
                  theme: value.lightTheme,
                  darkTheme: value.darkTheme,
                  themeMode: value.themeMode,
                  routes: {
                    HistoryScreen.route: (context) => HistoryScreen(),
                    HomeScreen.route: (context) => HomeScreen(),
                    BackupScreen.route: (context) => BackupScreen(),
                    ThemeScreen.route: (context) => ThemeScreen(),
                  },
                  initialRoute: HomeScreen.route,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
