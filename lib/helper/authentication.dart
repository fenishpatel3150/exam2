import 'package:firebase_auth/firebase_auth.dart';

class GoogleAuthService{
  static GoogleAuthService googleAuthService = GoogleAuthService._();
  GoogleAuthService._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String> createAccount(String email,String pwd)
  async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pwd,
      );
      return 'Success';
    } catch (e) {
      print(e);
      return 'failed';
    }
  }
}