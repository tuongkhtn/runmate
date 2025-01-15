import '../models/invitation.dart';
import 'base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvitationRepository extends BaseRepository {
  final CollectionReference collection;

  InvitationRepository()
      : collection = FirebaseFirestore.instance.collection('invitations');

  Future<void> createInvitation(Invitation invitation) async {
    try {
      await collection.add(invitation.toJson());
    } catch (e) {
      // Handle error
      print('Failed to create invitation: $e');
    }
  }

  Future<List<Invitation>> getInvitationsByEmail(String email) async {
    try {
      final querySnapshot = await collection.where('email', isEqualTo: email).get();
      return querySnapshot.docs
          .map((doc) => Invitation.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Handle error
      print('Failed to get invitations: $e');
      return [];
    }
  }

  Future<void> updateInvitationStatus(String invitationId, String status) async {
    try {
      await collection.doc(invitationId).update({'status': status});
    } catch (e) {
      // Handle error
      print('Failed to update invitation status: $e');
    }
  }
}