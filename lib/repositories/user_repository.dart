import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runmate/models/invitation.dart';
import 'package:runmate/models/participant.dart';
import 'package:runmate/repositories/challenge_repository.dart';
import 'package:runmate/repositories/invitation_repository.dart';
import 'package:runmate/repositories/participant_repository.dart';
import '../enums/challenge_status_enum.dart';
import '../enums/challenge_type_enum.dart';
import '../models/user.dart';
import '../models/challenge.dart';
import 'base_repository.dart';

class UserRepository extends BaseRepository {
  final CollectionReference collection;
  ChallengeRepository challengeRepository;
  ParticipantRepository participantRepository;
  InvitationRepository invitationRepository;

  UserRepository() :
        challengeRepository = ChallengeRepository(),
        invitationRepository = InvitationRepository(),
        participantRepository = ParticipantRepository(),
        collection = FirebaseFirestore.instance.collection('users');

  UserRepository.withMockFirestore(super.firestore, this.challengeRepository, this.invitationRepository, this.participantRepository)
      : collection = firestore.collection('users'),
        super.withMockFirestore();

  Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot = await collection.get();
      return querySnapshot.docs
          .map((doc) {
        final user = User.fromJson(doc.data() as Map<String, dynamic>);
        user.id = doc.id;
        return user;
      })
          .toList();
    } catch (e) {
      throw Exception('Error getting all users: $e');
    }
  }

  Future<User> getUserById(String? userId) async {
    try {
      if (userId == null) throw Exception('User ID is required');
      final doc = await collection.doc(userId).get();
      if (!doc.exists) throw Exception('User not found');

      final user = User.fromJson(doc.data() as Map<String, dynamic>);
      user.id = doc.id;
      return user;
    } catch (e) {
      throw Exception('Error getting user by userId: $e');
    }
  }

  Future<bool> isUserExists(String? userId) async {
    try {
      if (userId == null) throw Exception('User ID is required');
      final doc = await collection.doc(userId).get();
      return doc.exists;
    } catch (e) {
    throw Exception('Error checking if user exists: $e');
    }
  }

Future<User> createUser(User user) async {
  try {
    final docRef = await collection.add(user.toJson());
    User createdUser = await getUserById(docRef.id);
    createdUser.id = docRef.id;
    return createdUser;
  } catch (e) {
    print('Error creating user: $e');
    throw Exception('Error creating user');
  }
}

  Future<User> updateUser(String? userId, Map<String, dynamic> data) async {
    try {
      if (userId == null) throw Exception('User ID is required');
      await collection.doc(userId).update(data);
      return getUserById(userId);
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  Future<User> addTotalDistance(String? userId, double distance) async {
    try {
      if (userId == null) throw Exception('User ID is required');
      final user = await getUserById(userId);
      final totalDistance = user.totalDistance + distance;
      return updateUser(userId, {'totalDistance': totalDistance});
    } catch (e) {
      throw Exception('Error adding total distance: $e');
    }
  }

  Future<User> addTotalTime(String? userId, int time) async {
    try {
      if (userId == null) throw Exception('User ID is required');
      final user = await getUserById(userId);
      final totalTime = user.totalTime + time;
      return updateUser(userId, {'totalTime': totalTime});
    } catch (e) {
      throw Exception('Error adding total time: $e');
    }
  }

  Future<User> updateAvatarUrl(String? userId, String avatarUrl) async {
    try {
      return updateUser(userId, {'avatarUrl': avatarUrl});
    } catch (e) {
      throw Exception('Error updating avatar URL: $e');
    }
  }

  Future<User> updatePhoneNumber(String? userId, String phoneNumber) async {
    try {
      return updateUser(userId, {'phoneNumber': phoneNumber});
    } catch (e) {
      throw Exception('Error updating phone number: $e');
    }
  }

  Future<User> updateAddress(String? userId, String address) async {
    try {
      return updateUser(userId, {'address': address});
    } catch (e) {
      throw Exception('Error updating address: $e');
    }
  }

  Future<User> updateDateOfBirth(String? userId, DateTime dateOfBirth) async {
    try {
      return updateUser(userId, {'dateOfBirth': dateOfBirth.toIso8601String()});
    } catch (e) {
      throw Exception('Error updating date of birth: $e');
    }
  }

  Future<void> deleteUser(String? userId) async {
    try {
      if (userId == null) throw Exception('User ID is required');
      await collection.doc(userId).delete();
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  Future<List<Challenge>> getChallengesByTypeAndUserId(ChallengeTypeEnum type, String userId) async {
    try {
      final challengesByType = await challengeRepository.getChallengesByType(type);
      final challengesByUserId = await participantRepository.getParticipantsByUserId(userId);
      return challengesByType.where((challenge) => challengesByUserId.any((participant) => participant.challengeId == challenge.id)).toList();
    } catch (e) {
      throw Exception('Error getting challenges by type and user ID: $e');
    }
  }

  Future<List<Challenge>> getChallengesByStatusAndUserId(ChallengeStatusEnum status, String userId) async {
    try {
      final challengesByStatus = await challengeRepository.getChallengesByStatus(status);
      final challengesByUserId = await participantRepository.getParticipantsByUserId(userId);
      return challengesByStatus.where((challenge) => challengesByUserId.any((participant) => participant.challengeId == challenge.id)).toList();
    } catch (e) {
      throw Exception('Error getting challenges by status and user ID: $e');
    }
  }

  Future<List<Challenge>> getChallengesByTypeAndStatusAndUserId(ChallengeTypeEnum type, ChallengeStatusEnum status, String userId) async {
    try {
      final challengesByType = await challengeRepository.getChallengesByType(type);
      final challengesByStatus = await challengeRepository.getChallengesByStatus(status);
      final challengesByUserId = await participantRepository.getParticipantsByUserId(userId);
      return challengesByType.where((challenge) => challengesByStatus.any((c) => c.id == challenge.id) && challengesByUserId.any((participant) => participant.challengeId == challenge.id)).toList();
    } catch (e) {
      throw Exception('Error getting challenges by type, status, and user ID: $e');
    }
  }
}