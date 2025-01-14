import "package:cloud_firestore/cloud_firestore.dart";
import "../models/user.dart";

class AuthService {
  Future<void> saveUserToFirestore(User user) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.userId);

    try {
      await userRef.set(user.toJson());
      print("User saved successfully");
    } catch(e) {
      print("Error saving user: $e");
    }
  }
}

