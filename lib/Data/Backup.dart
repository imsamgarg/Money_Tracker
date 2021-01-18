import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:newmoneytracker/Data/MoneyRecord.dart';
import 'package:newmoneytracker/Data/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Backup extends ChangeNotifier {
  DateTime _lastBackupDate = DateTime.now();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String get lastBackupDate {
    if(_lastBackupDate==null)
      return "Backup Never Done";
    return DateFormat.yMd().add_jm().format(_lastBackupDate);
  }


  Future loadLastBackupDate(SharedPreferences sharedPreferences) async {
    try {
      // SharedPreferences sharedPreferences =
      // await SharedPreferences.getInstance();
      String _date = sharedPreferences.getString(sharedDateKey);
      if (_date != null) _lastBackupDate = DateTime.parse(_date);
      _lastBackupDate = null;
      return true;
    } catch (e) {
      throw e;
    }
  }

   Future saveLastDate(SharedPreferences sharedPreferences)async{
     try {
       // SharedPreferences sharedPreferences =
       await SharedPreferences.getInstance();//
       sharedPreferences.setString(sharedDateKey,DateTime.now().toLocal().toString());
       return true;
     } catch (e) {
       throw e;
     }
   }

  Future performBackup(MoneyRecord record, String userId,SharedPreferences sharedPreferences) async {
    try {
      await _firebaseFirestore
          .collection(collectionName)
          .doc(userId)
          .set(record.toJson());
      await saveLastDate(sharedPreferences);
      return true;
    } catch (e) {
      throw e;
    }
  }
}
