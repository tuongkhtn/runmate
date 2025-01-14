import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "../models/user_model.dart";

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Đăng nhập với email và mật khẩu
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      print("Sign in Auth");

      return credential.user;
    } on FirebaseAuthException catch(e) {
      print("Sign in Auth Error");
      throw Exception(_getErrorMessage(e.code));
    }
  }

  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      return credential.user;
    } on FirebaseAuthException catch(e) {
      throw Exception(_getErrorMessage(e.code));
    }
  }

  Future<void> saveUserToFirestore(UserModel userModel) async {
    final userRef = _firestore.collection("users").doc(userModel.userId);

    try {
      await userRef.set(userModel.toJson());
      print("User saved successfully!");
    } catch(e) {
      print("Error saving user: $e");
    }
  }

  String _getErrorMessage(String code) {
    switch(code) {
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }
}

