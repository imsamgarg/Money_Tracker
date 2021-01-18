import 'package:flutter/material.dart';
import 'package:newmoneytracker/Data/Data.dart';
import 'package:newmoneytracker/Data/ThemeManager.dart';
import 'package:newmoneytracker/Screens/backup_screen.dart';
import 'package:newmoneytracker/Screens/history.dart';
import 'package:newmoneytracker/Screens/theme_screen.dart';
import 'package:provider/provider.dart';
import './Data/User.dart';
import 'Data/Themes.dart';

// import 'Data/constants.dart';
import 'Screens/main_screen.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: ThemeManager()),
        StreamProvider<ConnectivityResult>.value(
            initialData: ConnectivityResult.none,
            value: Connectivity().onConnectivityChanged),
        ChangeNotifierProvider(
          create: (BuildContext context) => Data(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => UserData(),
        ),
      ],
      child: Consumer<ThemeManager>(
        builder: (BuildContext context, value, Widget child) =>StreamProvider<ThemeData>.value(
          initialData: initialTheme,
          value: Provider.of<ThemeManager>(context).theme,
          child: Consumer<ThemeData>(
            builder: (BuildContext context, value, Widget child)=>MaterialApp(
              theme: ThemeData.light(),
              // themeMode: ,
              darkTheme: ThemeData.dark(),
              routes: {
                History.route: (context) => History(),
                HomeScreen.route: (context) => HomeScreen(),
                BackupScreen.route: (context) => BackupScreen(),
                ThemeScreen.route: (context) => ThemeScreen(),
              },
              initialRoute: HomeScreen.route,
            ),
          ),
        ),
      ),
    );
  }
}
