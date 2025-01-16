import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/challenge_status_enum.dart';
import '../enums/challenge_type_enum.dart';
import '../models/challenge.dart';
import '../models/participant.dart';
import 'base_repository.dart';
import 'challenge_repository.dart';

class ParticipantRepository extends BaseRepository {
  final CollectionReference collection;
  final ChallengeRepository challengeRepository;

  ParticipantRepository()
      : challengeRepository = ChallengeRepository(),
        collection = FirebaseFirestore.instance.collection('participants');

  ParticipantRepository.withMockFirestore(FirebaseFirestore firestore, {required this.challengeRepository})
      : collection = firestore.collection('participants'),
        super.withMockFirestore(firestore);

  Future<Participant> addParticipant(Participant participant) async {
    try {
      final docRef = await collection.add(participant.toJson());
      Participant? createdParticipant = await getParticipantById(docRef.id);
      if (createdParticipant == null) {
        throw Exception('Error creating participant');
      }

      createdParticipant.id = docRef.id;

      if (createdParticipant.challengeId != null) {
        final challenge = await challengeRepository.getChallengeById(createdParticipant.challengeId!);
        await challengeRepository.addTotalNumberOfParticipants(challenge.id, 1);
      }

      return createdParticipant;
    } catch (e) {
      throw Exception('Error adding participant: $e');
    }
  }

  Future<Participant?> getParticipantById(String participantId) async {
    try {
      final doc = await collection.doc(participantId).get();
      if (!doc.exists) return null;
      Participant participant = Participant.fromJson(doc.data() as Map<String, dynamic>);
      participant.id = doc.id;
      return participant;
    } catch (e) {
      throw Exception('Error getting participant by ID: $e');
    }
  }

  Future<List<Participant>> getAllParticipants() async {
    try {
      final snapshot = await collection.get();
      return snapshot.docs.map((doc) {
        Participant participant = Participant.fromJson(doc.data() as Map<String, dynamic>);
        participant.id = doc.id;
        return participant;
      }).toList();
    } catch (e) {
      throw Exception('Error getting all participants: $e');
    }
  }

  Future<List<Participant>> getParticipantsByUserId(String userId) async {
    try {
      final snapshot = await collection.where('userId', isEqualTo: userId).get();
      return snapshot.docs.map((doc) {
        Participant participant = Participant.fromJson(doc.data() as Map<String, dynamic>);
        participant.id = doc.id;
        return participant;
      }).toList();
    } catch (e) {
      throw Exception('Error getting participants by user ID: $e');
    }
  }

  Future<List<Participant>> getParticipantsByChallengeId(String challengeId) async {
    try {
      final snapshot = await collection.where('challengeId', isEqualTo: challengeId).get();
      return snapshot.docs.map((doc) {
        Participant participant = Participant.fromJson(doc.data() as Map<String, dynamic>);
        participant.id = doc.id;
        return participant;
      }).toList();
    } catch (e) {
      throw Exception('Error getting participants by challenge ID: $e');
    }
  }

  Future<List<Challenge>> getChallengesByTypeAndUserId(ChallengeTypeEnum type, String participantId) async {
    try
    {
      List<Challenge> challenges = await challengeRepository.getChallengesByType(type);
      List<Participant> participants = await getParticipantsByUserId(participantId);
      List<Challenge> userChallenges = [];
      for (var challenge in challenges) {
        for (var participant in participants) {
          if (challenge.id == participant.challengeId) {
            userChallenges.add(challenge);
          }
        }
      }
      return userChallenges;
    }
    catch (e) {
      throw Exception('Error getting challenges by type and user ID: $e');
    }
  }

  Future<List<Challenge>> getChallengesByStatusAndUserId(ChallengeStatusEnum status, String participantId) async {
    try {
      List<Challenge> challenges = await challengeRepository.getChallengesByStatus(status);
      List<Participant> participants = await getParticipantsByUserId(participantId);
      List<Challenge> userChallenges = [];
      for (var challenge in challenges) {
        for (var participant in participants) {
          if (challenge.id == participant.challengeId) {
            userChallenges.add(challenge);
          }
        }
      }
      return userChallenges;
    } catch (e) {
      throw Exception('Error getting challenges by status and user ID: $e');
    }
  }

  Future<List<Challenge>> getChallengesByTypeAndUserIdAndStatus(ChallengeTypeEnum type, String participantId, ChallengeStatusEnum status) async {
    try {
      List<Challenge> challenges = await challengeRepository.getChallengesByType(type);
      List<Participant> participants = await getParticipantsByUserId(participantId);
      List<Challenge> userChallenges = [];
      for (var challenge in challenges) {
        for (var participant in participants) {
          if (challenge.id == participant.challengeId && challenge.status == status) {
            userChallenges.add(challenge);
          }
        }
      }
      return userChallenges;
    } catch (e) {
      throw Exception('Error getting challenges by type, user ID, and status: $e');
    }
  }

  Future<Participant> updateParticipant(String participantId, Participant participant) async {
    try {
      await collection.doc(participantId).update(participant.toJson());
      Participant? updatedParticipant = await getParticipantById(participantId);
      if (updatedParticipant == null) {
        throw Exception('Error updating participant');
      }

      if (updatedParticipant.challengeId != participant.challengeId) {
        if (participant.challengeId != null) {
          final challenge = await challengeRepository.getChallengeById(participant.challengeId!);
          await challengeRepository.addTotalNumberOfParticipants(challenge.id, 1);
        }

        if (updatedParticipant.challengeId != null) {
          final challenge = await challengeRepository.getChallengeById(updatedParticipant.challengeId!);
          await challengeRepository.addTotalNumberOfParticipants(challenge.id, -1);
        }
      }
      return updatedParticipant;
    } catch (e) {
      throw Exception('Error updating participant: $e');
    }
  }

  Future<Participant> updateTotalDistance(String participantId, double totalDistance) async {
    try {
      await collection.doc(participantId).update({'totalDistance': totalDistance});
      Participant? updatedParticipant = await getParticipantById(participantId);
      if (updatedParticipant == null) {
        throw Exception('Error updating total distance');
      }
      return updatedParticipant;
    } catch (e) {
      throw Exception('Error updating total distance: $e');
    }
  }

  Future<void> deleteParticipant(String participantId) async {
    try {
      await collection.doc(participantId).delete();
    } catch (e) {
      throw Exception('Error deleting participant: $e');
    }
  }
}