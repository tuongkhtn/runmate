import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/participant.dart';
import 'base_repository.dart';

class ParticipantRepository extends BaseRepository {
  final CollectionReference collection;

  ParticipantRepository() : collection = FirebaseFirestore.instance.collection('participants');

  Future<Participant> addParticipant(Participant participant) async {
    try {
      await collection.add(participant.toJson());
      return participant;
    } catch (e) {
      rethrow;
    }
  }

  Future<Participant?> getParticipantById(String participantId) async {
    try {
      final docSnapshot = await collection.doc(participantId).get();
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
      final querySnapshot = await collection.get();
      return querySnapshot.docs
          .map((doc) =>
          Participant.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Participant> updateParticipant(String participantId, Participant participant) async {
    try {
      await collection.doc(participantId).update(participant.toJson());
      return participant;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteParticipant(String participantId) async {
    try {
      await collection.doc(participantId).delete();
      return true;
    } catch (e) {
      print('Error deleting participant: $e');
      return false;
    }
  }
}