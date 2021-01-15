import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Data/Data.dart';
import '../Data/User.dart';
import '../Data/constants.dart';

class HeadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(
      builder: (BuildContext context,UserData value, Widget child) => Text(
        'Hi! ${value.userName}',
        style: TextStyle(fontSize: headingFontSize, color: whiteColor),
      ),
    );
  }
}

class LastSevenDaysDataRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (BuildContext context, Data value, Widget child) {
        final color = (value.thisWeekAmount.isNegative) ? redColor : greenColor;
        // final sign =(value.thisWeekAmount.isNegative)?String.fromCharCode(0x2212):String.fromCharCode(0x002B);
        return Align(
          alignment: Alignment.topCenter,
          child: Text(
            '$rupeeSign ${value.thisWeekAmount}',
            style: TextStyle(
              fontSize: fontSizeNormal + 4,
              color: color,
            ),
          ),
        );
      },
    );
  }
}

class YesterdayDataRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (BuildContext context, Data value, Widget child) {
        final color = (value.yesterdayAmount.isNegative) ? redColor : greenColor;
        // final sign =(value.yesterdayAmount.isNegative)?String.fromCharCode(0x2212):String.fromCharCode(0x002B);
        return Align(
          alignment: Alignment.topCenter,
          child: Text(
            '$rupeeSign ${value.yesterdayAmount.abs()}',
            style: TextStyle(fontSize: fontSizeNormal + 4, color: color),
          ),
        );
      },
    );
  }
}

class LastRecordText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (BuildContext context, Data value, Widget child) {
        final color = (value.lastTransaction.isNegative) ? redColor : greenColor;
        // final sign =(value.lastTransaction.isNegative)?String.fromCharCode(0x2212):String.fromCharCode(0x002B);
        // print(value.yesterdayAmount.isNegative);
        return Text(
          '$rupeeSign ${value.lastTransaction.abs()}',
          style: TextStyle(color: color, fontSize: fontSizeNormal + 4),
        );
      },
    );
  }
}

class BalanceText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (BuildContext context, Data value, Widget child) => Text(
        '$rupeeSign ${value.balance}',
        style: TextStyle(fontSize: fontSizeNormal + 4),
      ),
    );
  }
}
