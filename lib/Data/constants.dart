import 'package:flutter/material.dart';

final Color blueAccentColor = Colors.blueAccent[400]!;
final Color normalBlueAccentColor = Colors.blue[400]!;
final Color redAccentColor = Colors.redAccent[400]!;
final Color normalRedAccentColor = Colors.red[400]!;
final Color purpleAccentColor = Colors.purpleAccent[400]!;
final Color deepPurpleAccentColor = Colors.deepPurpleAccent[400]!;
final Color orangeAccentColor = Colors.orangeAccent[400]!;
final Color deepOrangeAccentColor = Colors.deepOrangeAccent[400]!;
// final Color deepAccentColor = Colors.deepOrangeAccent[400];
final Color greenAccentColor = Colors.greenAccent[400]!;
final Color greenColor = Colors.green[400]!;
final Color redColor = Colors.red[400]!;
const Color whiteColor = Colors.white;

//Preferenced Keys

const String sharedDateKey = "last_backup_date";
const String sharedColorKey = "accent_color";
const String sharedThemeModeKey = "theme_mode";

const String appName = 'MoneyTracker';
const String balance = 'Balance';
const String lastRecord = 'Last Record';

final String rupeeSign = String.fromCharCode(0x20B9);
const String recordCollectionName = "Record";
const String lastDateCollectionName = "LastDate";
const String lastDateKey = "lastDate";

const double fontSizeNormal = 24;
const double headingFontSize = 35;

const RoundedRectangleBorder cardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(
      9,
    ),
  ),
);

const Widget paddingWidget = const SizedBox(
  height: 10,
);

// final TextStyle normalTextStyle = TextStyle(
//     fontSize: fontSizeNormal,
// );
//const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(9));
