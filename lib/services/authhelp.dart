
import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static signInWithEmail({String email, String password}) async {
    final res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final User user = res.user;
    return user;
  }
  Future<bool> isUserloggedIn() async{
    var user = await _auth.currentUser;
    return user != null;
  }
}