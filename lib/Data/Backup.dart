import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:newmoneytracker/Data/MoneyRecord.dart';
import 'package:newmoneytracker/Data/constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Backup extends ChangeNotifier {
  DateTime _lastBackupDate;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String get lastBackupDate {
    if (_lastBackupDate == null) return "Never";
    return DateFormat.yMd().add_jm().format(_lastBackupDate);
  }

  Future loadLastBackupDate(String userId) async {
    try {
      DocumentSnapshot _documentReference = await _firebaseFirestore
          .collection(lastDateCollectionName)
          .doc(userId)
          .get();
      var _data = _documentReference.data()[lastDateKey];
      if (_documentReference.data()[lastDateKey] != null)
        _lastBackupDate = DateTime.parse(_data);
      _lastBackupDate = null;
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future performRestore(String userId) async {
    try {
      DocumentSnapshot _documentReference = await _firebaseFirestore
          .collection(recordCollectionName)
          .doc(userId)
          .get();
         return _documentReference.data();
    }  catch (e) {
      throw e;
    }
  }

  Future performBackup(MoneyRecord record, String userId,) async {
    try {
      var time = DateTime.now();
      await _firebaseFirestore
          .collection(recordCollectionName)
          .doc(userId)
          .set(record.toJson());
      await _firebaseFirestore
          .collection(lastDateCollectionName)
          .doc(userId)
          .set({lastDateKey: time.toLocal().toString()});
      _lastBackupDate = time;
      notifyListeners();
      return true;
    } catch (e) {
      throw e;
    }
  }
}
