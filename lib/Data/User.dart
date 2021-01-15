import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserData extends ChangeNotifier {
  User _user;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String get userName => _user.displayName;

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

  Future login() async {
    _user = _firebaseAuth.currentUser;
    if (_user != null) {
      return true;
    } else {
      try {
        await _loginUser();
        return true;
      } catch (e) {
        throw e;
      }
    }
  }


}
