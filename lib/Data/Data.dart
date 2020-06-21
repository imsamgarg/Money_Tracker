import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:newmoneytracker/Data/MoneyRecord.dart';
import 'dart:convert';
import 'dart:io';

class DateUtils {

  static int currentWeek(DateTime dateTime) {
    return weekOfYear(dateTime);
  }

  static int weekOfYear(DateTime date) {
    DateTime monday = weekStart(date);
    DateTime first = weekYearStartDate(monday.year);

    int week = 1 + (monday.difference(first).inDays / 7).floor();

    if (week == 53 && DateTime(monday.year, 12, 31).weekday < 4)
      week = 1;

    return week;
  }

  static DateTime weekStart(DateTime date) {
    // This is ugly, but to avoid problems with daylight saving
    DateTime monday = DateTime.utc(date.year, date.month, date.day);
    monday = monday.subtract(Duration(days: monday.weekday - 1));

    return monday;
  }

  static DateTime weekEnd(DateTime date) {
    // This is ugly, but to avoid problems with daylight saving
    // Set the last microsecond to really be the end of the week
    DateTime sunday = DateTime.utc(date.year, date.month, date.day, 23, 59, 59, 999, 999999);
    sunday = sunday.add(Duration(days: 7 - sunday.weekday));

    return sunday;
  }

  static DateTime weekYearStartDate(int year) {
    final firstDayOfYear = DateTime.utc(year, 1, 1);
    final dayOfWeek = firstDayOfYear.weekday;

    return firstDayOfYear.add(Duration(days: (dayOfWeek <= DateTime.thursday ? 1 : 8) - dayOfWeek));
  }
}

class Data extends ChangeNotifier {
  MoneyRecord _record;
  static Record _transactionRecord;
  static DateTime _dateTime ;

  _saveData() async {
    String data = json.encode(_record.toJson());
    final path = await ExtStorage.getExternalStorageDirectory();
    File('$path/Money Tracker/data.json').writeAsStringSync(data);
  }

  uploadData() async {
    final path = await ExtStorage.getExternalStorageDirectory();
    String stringFile;
    File file = File('$path/Money Tracker/data.json');
    print(path);

    try {
      if (file.existsSync()) {
        stringFile = file.readAsStringSync();
        if(stringFile=='')
          {
            _record = MoneyRecord(balance: null, record: List());
            notifyListeners();
          }
        else {
          _record = MoneyRecord.fromJson(await json.decode(stringFile));
          notifyListeners();
        }
      } else {
        Directory('$path/Money Tracker/').createSync();
        file.writeAsStringSync('');
        _record = MoneyRecord(balance: null, record: List());
      }
    } on FileSystemException catch (e) {
      print(e);
      throw e;
    }
  }

  _updateTotalBalance(double amount) {
    print('fuck man $amount');
    _record.balance = (_record.balance ?? 0) + amount;
    _saveData();
  }

  addTransaction(double amount, String remarks) {
    print('$amount,$remarks');
    _transactionRecord = Record(
        amount: amount,
        date: DateTime.now().toLocal().toString(),
        remarks: remarks);
    print('ethe');
    _record.record.insert(0, _transactionRecord);
    print(_transactionRecord.amount);
    _updateTotalBalance(amount);
    notifyListeners();
  }

  deleteRecord(int index)async {
    if(_record.record.length==1)
      {
        _record.balance=null;
        _record.record=List();
      }
    else {
      print(_record.balance);
      _record.balance = _record.balance - _record.record[index].amount;
      print(_record.balance);
      _record.record.removeAt(index);
    }
      _saveData();
      notifyListeners();
  }

  double get balance => this._record.balance ?? 0;

  double get lastTransaction =>
      (this._record.balance == null) ? 0 : this._record.record[0].amount??0;

  double get yesterdayAmount {
    _dateTime=DateTime.now().toLocal();
    var temp='${_dateTime.year}-${(_dateTime.month<10)?"0${_dateTime.month}":_dateTime.month}-${(_dateTime.day<10)?"0${_dateTime.day}":_dateTime.day}';
    var currentDate = DateTime.parse(temp);
    double amount = 0;
    for (int i = 0; i < _record.record.length; i++) {
      var date=DateTime.parse(_record.record[i].date);
      var temp2='${date.year}-${(date.month<10)?"0${date.month}":date.month}-${(date.day<10)?"0${date.day}":date.day}';
      var transDate=DateTime.parse(temp2);
      if (currentDate.difference(transDate).inDays==1)
        amount=amount+_record.record[i].amount;
      if(currentDate.difference(transDate).inDays>1)
        break;
    }
    return amount;
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

//  double get thisWeekAmount {
//    _dateTime=DateTime.now().toLocal();
//    int currentDate = _dateTime.day;
//    double amount = 0;
//
//    for (int i = 0; i < _record.record.length; i++) {
//      if (DateTime.parse(_record.record[i].date).weekday == 7 ||
//          DateTime.parse(_record.record[i].date).day != currentDate) break;
//      amount += _record.record[i].amount;
//    }
//    return amount;
//  }
  double get thisWeekAmount {
    _dateTime=DateTime.now().toLocal();
    int currentWeek=DateUtils.currentWeek(_dateTime);
    double amount = 0;

    for (int i = 0; i < _record.record.length; i++) {
      var transWeek=DateUtils.currentWeek(DateTime.parse(_record.record[i].date));
      if(currentWeek==transWeek)
        amount=amount+_record.record[i].amount;
      if(currentWeek>transWeek)
        break;
    }
    return amount;
  }

  List<Record> get history => this._record.record;
}
