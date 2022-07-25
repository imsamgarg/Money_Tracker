import 'package:flutter/foundation.dart';

class LoadingClass extends ChangeNotifier {
  bool isLoading = false;
  String status = "";
  bool isError = false;
  bool isSuccess = false;

  @override
  void notifyListeners() {
    if (!hasListeners) return;
    super.notifyListeners();
  }

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
      if (hasListeners) _hideErrorMsg();
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
      if (hasListeners) _hideSuccessMsg();
    });
  }

  void _hideSuccessMsg() {
    status = "";
    isSuccess = false;
    notifyListeners();
  }
}
