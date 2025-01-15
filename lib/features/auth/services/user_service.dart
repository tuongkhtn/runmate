import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_storage/firebase_storage.dart";
import '../models/user_model.dart';
import "dart:io";

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> saveUserToFirestore(UserModel userModel) async {
    final userRef = _firestore.collection("users").doc(userModel.userId);
    try {
      await userRef.set(userModel.toJson());
    } catch (e) {
      throw Exception("Error saving user: $e");
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final userDoc = await _firestore.collection("users").doc(user.uid).get();
      if (!userDoc.exists) return null;

      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      throw Exception("Error fetching current user: $e");
    }
  }

  Future<void> updateUser({
    required String userId,
    String? name,
    String? email,
    String? avatarUrl,
    double? totalDistance,
    int? totalTime,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("No authenticated user found");

      // Chuẩn bị dữ liệu cần cập nhật
      final updatedData = {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (avatarUrl != null && avatarUrl.isNotEmpty) 'avatarUrl': avatarUrl,
        if (totalDistance != null) 'totalDistance': totalDistance,
        if (totalTime != null) 'totalTime': totalTime,
      };

      // Cập nhật trong Firestore nếu có thay đổi
      if (updatedData.isNotEmpty) {
        final userRef = _firestore.collection("users").doc(userId);
        await userRef.update(updatedData);
      }
    } catch (e) {
      throw Exception("Failed to update profile: $e");
    }
  }

  Future<String> uploadAvatar(File avatar) async {
    try {
      final storageRef = _storage.ref().child('avatars/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(avatar);
      final url = await storageRef.getDownloadURL();
      return url;
    } catch(e) {
      throw Exception("Failed to upload avatar: $e");
    }
  }
}
