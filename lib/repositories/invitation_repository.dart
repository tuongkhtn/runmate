import '../models/invitation.dart';
import 'base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvitationRepository extends BaseRepository {
  final CollectionReference collection;

  InvitationRepository()
      : collection = FirebaseFirestore.instance.collection('invitations');

  Future<Invitation> createInvitation(Invitation invitation) async {
    try {
      final docRef = await collection.add(invitation.toJson());
      Invitation createdInvitation = await getInvitationById(docRef.id);
      createdInvitation.id = docRef.id;

      return createdInvitation;
    } catch (e) {
      throw Exception('Error creating invitation: $e');
    }
  }

  Future<Invitation> getInvitationById(String invitationId) async {
    try {
      final doc = await collection.doc(invitationId).get();
      if (!doc.exists) throw Exception('Invitation not found');
      Invitation invitation = Invitation.fromJson(doc.data() as Map<String, dynamic>);
      invitation.id = doc.id;
      return invitation;
    } catch (e) {
      throw Exception('Error getting invitation by ID: $e');
    }
  }

  Future<List<Invitation>> getInvitationsByInviteeId(String inviteeId) async {
    try {
      final snapshot = await collection.where('inviteeId', isEqualTo: inviteeId).get();
      return snapshot.docs.map((doc) {
        Invitation invitation = Invitation.fromJson(doc.data() as Map<String, dynamic>);
        invitation.id = doc.id;
        return invitation;
      }).toList();
    } catch (e) {
      throw Exception('Error getting invitations by invitee ID: $e');
    }
  }

  Future<List<Invitation>> getInvitationsByEmail(String email) async {
    try {
      final snapshot = await collection.where('email', isEqualTo: email).get();
      return snapshot.docs.map((doc) {
        Invitation invitation = Invitation.fromJson(doc.data() as Map<String, dynamic>);
        invitation.id = doc.id;
        return invitation;
      }).toList();
    } catch (e) {
      throw Exception('Error getting invitations by email: $e');
    }
  }

  Future<List<Invitation>> getInvitationsByChallengeId(String challengeId) async {
    try {
      final snapshot = await collection.where('challengeId', isEqualTo: challengeId).get();
      return snapshot.docs.map((doc) {
        Invitation invitation = Invitation.fromJson(doc.data() as Map<String, dynamic>);
        invitation.id = doc.id;
        return invitation;
      }).toList();
    } catch (e) {
      throw Exception('Error getting invitations by challenge ID: $e');
    }
  }

  Future<List<Invitation>> getInvitationsByStatus(String status) async {
    try {
      final snapshot = await collection.where('status', isEqualTo: status).get();
      return snapshot.docs.map((doc) {
        Invitation invitation = Invitation.fromJson(doc.data() as Map<String, dynamic>);
        invitation.id = doc.id;
        return invitation;
      }).toList();
    } catch (e) {
      throw Exception('Error getting invitations by status: $e');
    }
  }

  Future<List<Invitation>> getInvitationsByInviteeIdAndStatus(String inviteeId, String status) async {
    try {
      final snapshot = await collection.where('inviteeId', isEqualTo: inviteeId).where('status', isEqualTo: status).get();
      return snapshot.docs.map((doc) {
        Invitation invitation = Invitation.fromJson(doc.data() as Map<String, dynamic>);
        invitation.id = doc.id;
        return invitation;
      }).toList();
    } catch (e) {
      throw Exception('Error getting invitations by invitee ID and status: $e');
    }
  }

  Future<Invitation> updateInvitationStatus(String invitationId, String status) async {
    try {
      final doc = await collection.doc(invitationId).get();
      if (!doc.exists) throw Exception('Invitation not found');
      await collection.doc(invitationId).update({'status': status});
      return getInvitationById(invitationId);
    } catch (e) {
      throw Exception('Error updating invitation status: $e');
    }
  }

  Future<void> deleteInvitation(String invitationId) async {
    try {
      final doc = await collection.doc(invitationId).get();
      if (!doc.exists) throw Exception('Invitation not found');
      await collection.doc(invitationId).delete();
    } catch (e) {
      throw Exception('Error deleting invitation: $e');
    }
  }
}