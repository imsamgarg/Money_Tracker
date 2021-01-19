import 'package:flutter/foundation.dart';

class LoadingClass extends ChangeNotifier {
  bool isLoading = false;
  String status = "";
  bool isError = false;
  bool isSuccess = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void showError(String errorMsg) {
    status = errorMsg;
    isError = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 2)).then((value) {
      _hideErrorMsg();
    });
  }

  void _hideErrorMsg() {
    status = "";
    isError = false;
    notifyListeners();
  }

  void showSuccessMsg(String msg) {
    isSuccess = true;
    status = msg;
    notifyListeners();
    Future.delayed(Duration(seconds: 2)).then((value) {
      _hideSuccessMsg();
    });
  }

  void _hideSuccessMsg() {
    status = "";
    isSuccess = false;
    notifyListeners();
  }
}
