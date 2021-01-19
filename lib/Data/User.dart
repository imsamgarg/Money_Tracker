import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserData extends ChangeNotifier {
  User _user;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String get userName {
    if (_user != null) return _user.displayName;
    return "Not Logged";
  }

  String get userId =>_user.uid;

  bool get isUserLogged {
    if(_user!=null)return true;
    return false;
  }

  String get email {
    if(_user!=null)
      return _user.email;
    return "";
  }

  Future<bool> _loginUser() async {
    try {
      final GoogleSignInAccount _googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication _googleAuth =
          await _googleUser.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: _googleAuth.accessToken, idToken: _googleAuth.idToken);

      UserCredential _userCredentials =
          await _firebaseAuth.signInWithCredential(credential);

      _user = _userCredentials.user;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginAlreadyLoggedUser()async{
    _user=_firebaseAuth.currentUser;
    if(_user!=null)
      return true;
    return false;
  }
  Future<bool> login() async {
    _user = _firebaseAuth.currentUser;
    if (_user != null) {
      notifyListeners();
      return true;
    } else {
      try {
        await _loginUser();
        notifyListeners();
        return true;
      } catch (e) {
        throw e;
      }
    }
  }

  Future<bool> logout()async{
    try {
      _firebaseAuth.signOut();
      _user=null;
      notifyListeners();
      return true;
    } catch (e) {
      throw e;
    }
  }
}
