import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import 'base_repository.dart';

class UserRepository extends BaseRepository {
  final CollectionReference collection;

  UserRepository() : collection = FirebaseFirestore.instance.collection('users');

  Future<User?> getUser(String userId) async {
    final doc = await collection.doc(userId).get();
    if (!doc.exists) return null;
    return User.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<User> getUserByUserId(String userId) async {
    final doc = await collection.doc(userId).get();
    if (!doc.exists) throw Exception('User not found');
    return User.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<bool> isUserExists(String userId) async {
    final doc = await collection.doc(userId).get();
    return doc.exists;
  }

  Future<void> createUser(User user) async {
    await collection.doc(user.userId).set(user.toJson());
  }

  Future<User> updateUser(String userId, Map<String, dynamic> data) async {
    await collection.doc(userId).update(data);
    return getUserByUserId(userId);
  }

  Future<User> addTotalDistance(String userId, double distance) async {
    final user = await getUserByUserId(userId);
    final totalDistance = user.totalDistance + distance;
    return updateUser(userId, {'totalDistance': totalDistance});
  }

  Future<User> addTotalTime(String userId, int time) async {
    final user = await getUserByUserId(userId);
    final totalTime = user.totalTime + time;
    return updateUser(userId, {'totalTime': totalTime});
  }

  Future<User> updateAvatarUrl(String userId, String avatarUrl) async {
    return updateUser(userId, {'avatarUrl': avatarUrl});
  }

  Future<void> deleteUser(String userId) async {
    await collection.doc(userId).delete();
  }
}