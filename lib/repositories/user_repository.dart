import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/participant.dart';
import 'base_repository.dart';

class UserRepository extends BaseRepository {
  final CollectionReference collection;

  UserRepository() : collection = FirebaseFirestore.instance.collection('users');

  Future<User?> getUser(String userId) async {
    try {
      final doc = await collection.doc(userId).get();
      if (!doc.exists) return null;
      return User.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<User> getUserByUserId(String userId) async {
    try {
      final doc = await collection.doc(userId).get();
      if (!doc.exists) throw Exception('User not found');
      return User.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error getting user by userId: $e');
    }
  }

  Future<bool> isUserExists(String userId) async {
    try {
      final doc = await collection.doc(userId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking if user exists: $e');
      return false;
    }
  }

  Future<void> createUser(User user) async {
    try {
      await collection.doc(user.userId).set(user.toJson());
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  Future<User> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await collection.doc(userId).update(data);
      return getUserByUserId(userId);
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  Future<User> addTotalDistance(String userId, double distance) async {
    try {
      final user = await getUserByUserId(userId);
      final totalDistance = user.totalDistance + distance;
      return updateUser(userId, {'totalDistance': totalDistance});
    } catch (e) {
      throw Exception('Error adding total distance: $e');
    }
  }

  Future<User> addTotalTime(String userId, int time) async {
    try {
      final user = await getUserByUserId(userId);
      final totalTime = user.totalTime + time;
      return updateUser(userId, {'totalTime': totalTime});
    } catch (e) {
      throw Exception('Error adding total time: $e');
    }
  }

  Future<User> updateAvatarUrl(String userId, String avatarUrl) async {
    try {
      return updateUser(userId, {'avatarUrl': avatarUrl});
    } catch (e) {
      throw Exception('Error updating avatar URL: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await collection.doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}

class ParticipantRepository extends BaseRepository {
  final CollectionReference _participantCollection =
  FirebaseFirestore.instance.collection('participants');

  Future<void> addParticipant(Participant participant) async {
    try {
      await _participantCollection.add(participant.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<Participant?> getParticipantById(String participantId) async {
    try {
      final docSnapshot = await _participantCollection.doc(participantId).get();
      if (docSnapshot.exists) {
        return Participant.fromJson(docSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Participant>> getAllParticipants() async {
    try {
      final querySnapshot = await _participantCollection.get();
      return querySnapshot.docs
          .map((doc) =>
          Participant.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateParticipant(String participantId, Participant participant) async {
    try {
      await _participantCollection
          .doc(participantId)
          .update(participant.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteParticipant(String participantId) async {
    try {
      await _participantCollection.doc(participantId).delete();
    } catch (e) {
      rethrow;
    }
  }
}