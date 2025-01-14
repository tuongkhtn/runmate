import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateProfile({required String userId, String? name, String? avatarUrl}) async {
    try {
      final user = _auth.currentUser;
      if(user == null) {
        throw Exception("No authenticated user found");
      }

      if(name != null) {
        await user.updateDisplayName(name);
      }

      if(avatarUrl != null) {
        await user.updatePhotoURL(avatarUrl);
      }

      final userRef = _firestore.collection("users").doc(userId);
      final updatedData = <String, dynamic>{};

      if(name != null) {
        updatedData["name"] = name;
      }

      if(avatarUrl != null) {
        updatedData["avatarUrl"] = avatarUrl;
      }

      if(updatedData.isNotEmpty) {
        await userRef.update(updatedData);
      }

      print("User profile updated successfully");
    } catch(e) {
      print("Error updating user profile: $e");
      throw Exception("Failed to update profile");
    }
  }
}