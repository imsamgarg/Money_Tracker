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
        var color = (value.thisWeekAmount.isNegative) ? redColor : greenColor;
        return Row(
          children: <Widget>[
            Icon(
              (value.thisWeekAmount.isNegative) ? Icons.remove : Icons.add,
              color: color,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              'Rs.${value.thisWeekAmount}',
              style: TextStyle(
                fontSize: fontSizeNormal + 4,
                color: color,
              ),
            ),
          ],
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
        var color = (value.yesterdayAmount.isNegative) ? redColor : greenColor;
        return Row(
          children: <Widget>[
            Icon(
              (value.yesterdayAmount.isNegative) ? Icons.remove : Icons.add,
              color: color,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              'Rs.${value.yesterdayAmount.abs()}',
              style: TextStyle(fontSize: fontSizeNormal + 4, color: color),
            ),
          ],
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
        var color = (value.lastTransaction.isNegative) ? redColor : greenColor;
        return Row(
          children: <Widget>[
            Icon(
              (value.lastTransaction.isNegative) ? Icons.remove : Icons.add,
              color: color,
            ),
            Text(
              ' Rs.${value.lastTransaction.abs()}',
              style: TextStyle(color: color, fontSize: fontSizeNormal + 4),
            ),
          ],
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
        'Rs.${value.balance}',
        style: TextStyle(fontSize: fontSizeNormal + 4),
      ),
    );
  }
}
