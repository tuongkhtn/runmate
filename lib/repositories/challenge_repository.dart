import '../models/challenge.dart';
import '../models/participant.dart';
import 'base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeRepository extends BaseRepository {
  final CollectionReference collection;

  ChallengeRepository()
      : collection = FirebaseFirestore.instance.collection('challenges');

  Future<String> createChallenge(Challenge challenge) async {
    final docRef = await collection.add(challenge.toJson());
    return docRef.id;
  }

  Future<List<Challenge>> getChallengesByUserId({String? userId}) async {
    Query query = collection;
    if (userId != null) {
      query = query.where('ownerId', isEqualTo: userId);
    } else {
      query = query.where('type', isEqualTo: 'public');
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Challenge.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addParticipant(String challengeId, Participant participant) async {
    await collection
        .doc(challengeId)
        .collection('participants')
        .doc(participant.userId)
        .set(participant.toJson());
  }

  Future<List<Participant>> getParticipantsByChallengeId(String challengeId) async {
    final snapshot = await collection
        .doc(challengeId)
        .collection('participants')
        .get();
    return snapshot.docs
        .map((doc) => Participant.fromJson(doc.data()))
        .toList();
  }

  Future<void> deleteChallenge(String challengeId) async {
    await collection.doc(challengeId).delete();
  }

  Future<void> deleteParticipant(String challengeId, String userId) async {
    await collection
        .doc(challengeId)
        .collection('participants')
        .doc(userId)
        .delete();
  }

  Future<void> updateChallenge(String challengeId, Map<String, dynamic> data) async {
    await collection.doc(challengeId).update(data);
  }

  Future<void> updateParticipant(String challengeId, String userId, Map<String, dynamic> data) async {
    await collection
        .doc(challengeId)
        .collection('participants')
        .doc(userId)
        .update(data);
  }

  Future<Challenge> getChallengeById(String challengeId) async {
    final doc = await collection.doc(challengeId).get();
    return Challenge.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<List<Challenge>> getChallengesByType(String type) async {
    final snapshot = await collection.where('type', isEqualTo: type).get();
    return snapshot.docs
        .map((doc) => Challenge.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Challenge>> getChallengesWhereNameContainingString(String name) async {
    final snapshot = await collection.get();
    return snapshot.docs
        .where((doc) => (doc['name'] as String).contains(name))
        .map((doc) => Challenge.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Challenge>> getChallengesFromDateTimeToDateTime(DateTime start, DateTime end) async {
    final snapshot = await collection.get();
    return snapshot.docs
        .where((doc) {
          final challenge = Challenge.fromJson(doc.data() as Map<String, dynamic>);
          return challenge.startDate.isAfter(start) && challenge.endDate.isBefore(end);
        })
        .map((doc) => Challenge.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}