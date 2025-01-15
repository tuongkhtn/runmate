import '../models/challenge.dart';
import 'base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeRepository extends BaseRepository {
  final CollectionReference collection;

  ChallengeRepository()
      : collection = FirebaseFirestore.instance.collection('challenges');

  ChallengeRepository.withMockFirestore(FirebaseFirestore firestore)
      : collection = firestore.collection('challenges'),
        super.withMockFirestore(firestore);

  Future<Challenge> createChallenge(Challenge challenge) async {
    try {
      if (challenge.startDate.isAfter(challenge.endDate)) {
        throw Exception('Start date must be before end date');
      }

      final docRef = await collection.add(challenge.toJson());
      Challenge createdChallenge = await getChallengeById(docRef.id);
      createdChallenge.id = docRef.id;

      return createdChallenge;
    } catch (e) {
      throw Exception('Error creating challenge: $e');
    }
  }

  Future<List<Challenge>> getChallengesByOwnerId({String? ownerId}) async {
    try {
      if (ownerId == null) throw Exception('User ID is required');
      final snapshot = await collection.where('ownerId', isEqualTo: ownerId).get();
      return snapshot.docs.map((doc) {
        Challenge challenge = Challenge.fromJson(doc.data() as Map<String, dynamic>);
        challenge.id = doc.id;
        return challenge;
      }).toList();
    } catch (e) {
      throw Exception('Error getting challenges by owner ID: $e');
    }
  }

  Future<Challenge> getChallengeById(String challengeId) async {
    try {
      final doc = await collection.doc(challengeId).get();
      if (!doc.exists) throw Exception('Challenge not found');
      Challenge challenge = Challenge.fromJson(doc.data() as Map<String, dynamic>);
      challenge.id = doc.id;
      return challenge;
    } catch (e) {
      throw Exception('Error getting challenge by ID: $e');
    }
  }

  Future<void> deleteChallenge(String challengeId) async {
    try {
      await collection.doc(challengeId).delete();
    } catch (e) {
      throw Exception('Error deleting challenge: $e');
    }
  }

  Future<Challenge> updateChallenge(String challengeId, Map<String, dynamic> data) async {
    try {
      await collection.doc(challengeId).update(data);
      return getChallengeById(challengeId);
    } catch (e) {
      throw Exception('Error updating challenge: $e');
    }
  }

  Future<Challenge> updateDescription(String challengeId, String description) async {
    try {
      await collection.doc(challengeId).update({'description': description});
      return getChallengeById(challengeId);
    } catch (e) {
      throw Exception('Error updating challenge description: $e');
    }
  }

  Future<Challenge> updateLongDescription(String challengeId, String longDescription) async {
    try {
      await collection.doc(challengeId).update({'longDescription': longDescription});
      return getChallengeById(challengeId);
    } catch (e) {
      throw Exception('Error updating challenge long description: $e');
    }
  }

  Future<Challenge> updateGoalDistance(String challengeId, double goalDistance) async {
    try {
      await collection.doc(challengeId).update({'goalDistance': goalDistance});
      return getChallengeById(challengeId);
    } catch (e) {
      throw Exception('Error updating challenge goal distance: $e');
    }
  }

  Future<Challenge> updateTotalNumberOfParticipants(String challengeId, int totalNumberOfParticipants) async {
    try {
      await collection.doc(challengeId).update({'totalNumberOfParticipants': totalNumberOfParticipants});
      return getChallengeById(challengeId);
    } catch (e) {
      throw Exception('Error updating challenge total number of participants: $e');
    }
  }

  Future<Challenge> addTotalNumberOfParticipants(String challengeId, int addedPeople) async {
    try {
      final challenge = await getChallengeById(challengeId);
      final newTotalNumberOfParticipants = challenge.totalNumberOfParticipants + addedPeople;
      return updateTotalNumberOfParticipants(challengeId, newTotalNumberOfParticipants);
    } catch (e) {
      throw Exception('Error adding total number of participants: $e');
    }
  }

  Future<Challenge> updateStartDate(String challengeId, DateTime startDate) async {
    try {
      await collection.doc(challengeId).update({'startDate': startDate.toIso8601String()});
      return getChallengeById(challengeId);
    } catch (e) {
      throw Exception('Error updating challenge start date: $e');
    }
  }

  Future<Challenge> updateEndDate(String challengeId, DateTime endDate) async {
    try {
      await collection.doc(challengeId).update({'endDate': endDate.toIso8601String()});
      return getChallengeById(challengeId);
    } catch (e) {
      throw Exception('Error updating challenge end date: $e');
    }
  }

  Future<List<Challenge>> getChallengesWhereNameContainingString(String name) async {
    try {
      final snapshot = await collection.get();
      return snapshot.docs
          .where((doc) => (doc['name'] as String).contains(name))
          .map((doc) {
            Challenge challenge = Challenge.fromJson(doc.data() as Map<String, dynamic>);
            challenge.id = doc.id;
            return challenge;
          })
          .toList();
    } catch (e) {
      throw Exception('Error getting challenges where name contains string: $e');
    }
  }

  Future<List<Challenge>> getChallengesFromDateTimeToDateTime(DateTime start, DateTime end) async {
    try {
      final snapshot = await collection.get();
      return snapshot.docs
          .where((doc) {
            final challenge = Challenge.fromJson(doc.data() as Map<String, dynamic>);
            return challenge.startDate.isAfter(start) && challenge.endDate.isBefore(end);
          })
          .map((doc) {
            Challenge challenge = Challenge.fromJson(doc.data() as Map<String, dynamic>);
            challenge.id = doc.id;
            return challenge;
          })
          .toList();
    } catch (e) {
      throw Exception('Error getting challenges from DateTime to DateTime: $e');
    }
  }
}