import 'package:flutter/material.dart';

final Color accentColor = Colors.blueAccent[400];
final Color greenColor = Colors.green[400];
final Color redColor = Colors.red[400];
const Color whiteColor = Colors.white;
const String appName = 'MoneyTracker';
const String balance = 'Balance';
const String lastRecord = 'Last Record';
final String rupeeSign = String.fromCharCode(0x20B9);

const String collectionName="Record";
const String sharedDateKey="last_backup_date";

const double fontSizeNormal = 24;
const double headingFontSize = 35;

const RoundedRectangleBorder cardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(
      9,
    ),
  ),
);


const Widget paddingWidget=const SizedBox(
  height: 10,
);

final TextStyle normalTextStyle = TextStyle(
    fontSize: fontSizeNormal,
    color: whiteColor.withOpacity(0.8)
);
//const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(9));
