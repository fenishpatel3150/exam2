import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/attendencmodel.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> syncRecords(List<AttendanceRecord> records) async {
    User? user = _auth.currentUser;
    if (user != null) {
      for (var record in records) {
        await _firestore.collection('users/${user.uid}/attendance').doc(record.id).set(record.toMap());
      }
    }
  }

  Future<void> loginUser(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signupUser(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> deleteRecord(String id) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users/${user.uid}/attendance').doc(id).delete();
    }
  }
}
