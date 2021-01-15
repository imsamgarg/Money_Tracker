import 'package:flutter/material.dart';
// import 'package:googleapis/bigtableadmin/v2.dart';
import 'package:newmoneytracker/Data/Data.dart';
import 'package:newmoneytracker/Screens/backup_screen.dart';
import 'package:newmoneytracker/Screens/history.dart';
import 'package:provider/provider.dart';
import './Data/User.dart';
import 'Data/constants.dart';
import 'Screens/main_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Data(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => UserData(),
        ),
      ],
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
          History.route: (context) => History(),
          HomeScreen.route: (context) => HomeScreen(),
          BackupScreen.route:(context)=>BackupScreen(),
        },
        initialRoute: HomeScreen.route,
      ),
    );
  }
}
