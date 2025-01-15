import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runmate/enums/challenge_status_enum.dart';
import 'package:runmate/enums/challenge_type_enum.dart';
import 'package:runmate/repositories/challenge_repository.dart';
import 'package:runmate/models/challenge.dart';

void main() {
  group('ChallengeRepository Tests', () {
    late ChallengeRepository challengeRepository;
    late FakeFirebaseFirestore fakeFirestore;
    late CollectionReference challengesCollection;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      challengeRepository = ChallengeRepository.withMockFirestore(fakeFirestore);
      challengesCollection = fakeFirestore.collection('challenges');
    });

    Challenge createTestChallenge({
      String ownerId = 'test-owner',
      String name = 'Test Challenge',
      String description = 'Test Description',
      String longDescription = 'Test Long Description',
      DateTime? startDate,
      DateTime? endDate,
      double goalDistance = 100.0,
      ChallengeStatusEnum status = ChallengeStatusEnum.ONGOING,
      ChallengeTypeEnum type = ChallengeTypeEnum.PUBLIC,
      int totalNumberOfParticipants = 0,
    }) {
      return Challenge(
        ownerId: ownerId,
        name: name,
        description: description,
        longDescription: longDescription,
        startDate: startDate ?? DateTime.now(),
        endDate: endDate ?? DateTime.now().add(const Duration(days: 7)),
        goalDistance: goalDistance,
        status: status,
        type: type,
        totalNumberOfParticipants: totalNumberOfParticipants,
      );
    }

    test('createChallenge adds a challenge to Firestore and returns the created challenge', () async {
      final challenge = createTestChallenge();

      final createdChallenge = await challengeRepository.createChallenge(challenge);

      expect(createdChallenge.id, isNotNull);
      expect(createdChallenge.name, challenge.name);
      expect(createdChallenge.ownerId, challenge.ownerId);

      final doc = await challengesCollection.doc(createdChallenge.id).get();
      expect(doc.exists, true);
      expect((doc.data() as Map<String, dynamic>)['name'], challenge.name);
    });

    test('createChallenge throws exception when start date is after end date', () async {
      final challenge = createTestChallenge(
        startDate: DateTime.now().add(const Duration(days: 7)),
        endDate: DateTime.now(),
      );

      expect(
            () => challengeRepository.createChallenge(challenge),
        throwsException,
      );
    });

    test('getChallengesByOwnerId returns challenges for specific owner', () async {
      await challengeRepository.createChallenge(createTestChallenge(ownerId: 'owner1', name: 'Challenge 1'));
      await challengeRepository.createChallenge(createTestChallenge(ownerId: 'owner1', name: 'Challenge 2'));

      await challengeRepository.createChallenge(createTestChallenge(ownerId: 'owner2', name: 'Challenge 3'));

      final owner1Challenges = await challengeRepository.getChallengesByOwnerId(ownerId: 'owner1');
      final owner2Challenges = await challengeRepository.getChallengesByOwnerId(ownerId: 'owner2');

      expect(owner1Challenges.length, 2);
      expect(owner1Challenges.map((c) => c.name), containsAll(['Challenge 1', 'Challenge 2']));
      expect(owner2Challenges.length, 1);
      expect(owner2Challenges.first.name, 'Challenge 3');
    });

    test('getChallengeById returns correct challenge', () async {
      final challenge = await challengeRepository.createChallenge(createTestChallenge());

      final retrievedChallenge = await challengeRepository.getChallengeById(challenge.id!);

      expect(retrievedChallenge.id, challenge.id);
      expect(retrievedChallenge.name, challenge.name);
    });

    test('getChallengeById throws exception for non-existent challenge', () async {
      expect(
            () => challengeRepository.getChallengeById('non-existent-id'),
        throwsException,
      );
    });

    test('getAllChallenges returns all challenges', () async {
      await Future.wait([
        challengeRepository.createChallenge(createTestChallenge(name: 'Challenge 1')),
        challengeRepository.createChallenge(createTestChallenge(name: 'Challenge 2')),
        challengeRepository.createChallenge(createTestChallenge(name: 'Challenge 3')),
      ]);

      final allChallenges = await challengeRepository.getAllChallenges();
      expect(allChallenges.length, 3);
    });

    test('getChallengesByStatus returns challenges with matching status', () async {
      await challengeRepository.createChallenge(
          createTestChallenge(status: ChallengeStatusEnum.ONGOING)
      );
      await challengeRepository.createChallenge(
          createTestChallenge(status: ChallengeStatusEnum.COMPLETED)
      );

      final ongoingChallenges = await challengeRepository.getChallengesByStatus(
          ChallengeStatusEnum.ONGOING
      );
      expect(ongoingChallenges.length, 1);
      expect(ongoingChallenges.first.status, ChallengeStatusEnum.ONGOING);
    });

    test('getChallengesByType returns challenges with matching type', () async {
      await challengeRepository.createChallenge(
          createTestChallenge(type: ChallengeTypeEnum.PUBLIC)
      );
      await challengeRepository.createChallenge(
          createTestChallenge(type: ChallengeTypeEnum.PRIVATE)
      );

      final publicChallenges = await challengeRepository.getChallengesByType(
          ChallengeTypeEnum.PUBLIC
      );
      expect(publicChallenges.length, 1);
      expect(publicChallenges.first.type, ChallengeTypeEnum.PUBLIC);
    });


    test('getChallengesWhereNameContainingString returns matching challenges', () async {
      await challengeRepository.createChallenge(createTestChallenge(name: 'Marathon 2024'));
      await challengeRepository.createChallenge(createTestChallenge(name: 'Sprint Challenge'));
      await challengeRepository.createChallenge(createTestChallenge(name: 'Marathon Training'));

      final marathonChallenges = await challengeRepository.getChallengesWhereNameContainingString('Marathon');

      expect(marathonChallenges.length, 2);
      expect(
          marathonChallenges.map((c) => c.name),
          containsAll(['Marathon 2024', 'Marathon Training'])
      );
    });

    test('getChallengesFromDateTimeToDateTime returns challenges within timeframe', () async {
      final now = DateTime.now();

      // Challenge within timeframe
      await challengeRepository.createChallenge(createTestChallenge(
          name: 'Within Range',
          startDate: now.add(const Duration(days: 2)),
          endDate: now.add(const Duration(days: 5))
      ));

      // Challenge outside timeframe
      await challengeRepository.createChallenge(createTestChallenge(
          name: 'Outside Range',
          startDate: now.add(const Duration(days: 10)),
          endDate: now.add(const Duration(days: 15))
      ));

      final challenges = await challengeRepository.getChallengesFromDateTimeToDateTime(
          now.add(const Duration(days: 1)),
          now.add(const Duration(days: 6))
      );

      expect(challenges.length, 1);
      expect(challenges.first.name, 'Within Range');
    });

    test('deleteChallenge removes challenge from Firestore', () async {
      final challenge = await challengeRepository.createChallenge(createTestChallenge());

      await challengeRepository.deleteChallenge(challenge.id!);

      final doc = await challengesCollection.doc(challenge.id).get();
      expect(doc.exists, false);
    });

    test('updateDescription updates challenge description', () async {
      final challenge = await challengeRepository.createChallenge(createTestChallenge());

      final updatedChallenge = await challengeRepository.updateDescription(challenge.id!, 'New description');

      expect(updatedChallenge.description, 'New description');

      final doc = await challengesCollection.doc(challenge.id).get();
      expect((doc.data() as Map<String, dynamic>)['description'], 'New description');
    });

    test('updateLongDescription updates challenge long description', () async {
      final challenge = await challengeRepository.createChallenge(createTestChallenge());

      final updatedChallenge = await challengeRepository.updateLongDescription(
          challenge.id!,
          'New long description'
      );

      expect(updatedChallenge.longDescription, 'New long description');
    });

    test('updateGoalDistance updates challenge goal distance', () async {
      final challenge = await challengeRepository.createChallenge(createTestChallenge());

      final updatedChallenge = await challengeRepository.updateGoalDistance(challenge.id!, 200.0);

      expect(updatedChallenge.goalDistance, 200.0);
    });

    test('addTotalNumberOfParticipants increases participant count', () async {
      final challenge = await challengeRepository.createChallenge(createTestChallenge());

      final updatedChallenge = await challengeRepository.addTotalNumberOfParticipants(challenge.id!, 5);

      expect(updatedChallenge.totalNumberOfParticipants, 5);

      final furtherUpdatedChallenge = await challengeRepository.addTotalNumberOfParticipants(challenge.id!, 3);

      expect(furtherUpdatedChallenge.totalNumberOfParticipants, 8);
    });

    test('updateStartDate and updateEndDate update challenge dates', () async {
      final challenge = await challengeRepository.createChallenge(createTestChallenge());

      final newStartDate = DateTime.now().add(const Duration(days: 1));
      final newEndDate = DateTime.now().add(const Duration(days: 14));

      final updatedWithStartDate = await challengeRepository.updateStartDate(challenge.id!, newStartDate);
      expect(updatedWithStartDate.startDate.day, newStartDate.day);

      final updatedWithEndDate = await challengeRepository.updateEndDate(challenge.id!, newEndDate);
      expect(updatedWithEndDate.endDate.day, newEndDate.day);
    });

    test('updateStatus successfully updates challenge status', () async {
      final challenge = await challengeRepository.createChallenge(
          createTestChallenge(status: ChallengeStatusEnum.ONGOING)
      );

      final updatedChallenge = await challengeRepository.updateStatus(
          challenge.id!,
          ChallengeStatusEnum.COMPLETED
      );

      expect(updatedChallenge.status, ChallengeStatusEnum.COMPLETED);

      // Verify in Firestore
      final doc = await challengesCollection.doc(challenge.id).get();
      expect(
          (doc.data() as Map<String, dynamic>)['status'],
          'COMPLETED'
      );
    });

    test('updateStatus updates through all possible status values', () async {
      final challenge = await challengeRepository.createChallenge(
          createTestChallenge(status: ChallengeStatusEnum.ONGOING)
      );

      // Test all status transitions
      for (final status in ChallengeStatusEnum.values) {
        final updated = await challengeRepository.updateStatus(challenge.id!, status);
        expect(updated.status, status);

        // Verify in Firestore
        final doc = await challengesCollection.doc(challenge.id).get();
        expect(
            (doc.data() as Map<String, dynamic>)['status'],
            status.toString().split('.').last
        );
      }
    });

    test('updateStatus handles invalid challenge ID', () async {
      expect(
              () => challengeRepository.updateStatus(
              'non-existent-id',
              ChallengeStatusEnum.COMPLETED
          ),
          throwsException
      );
    });

    test('updateType successfully updates challenge type', () async {
      final challenge = await challengeRepository.createChallenge(
          createTestChallenge(type: ChallengeTypeEnum.PUBLIC)
      );

      final updatedChallenge = await challengeRepository.updateType(
          challenge.id!,
          ChallengeTypeEnum.PRIVATE
      );

      expect(updatedChallenge.type, ChallengeTypeEnum.PRIVATE);

      // Verify in Firestore
      final doc = await challengesCollection.doc(challenge.id).get();
      expect(
          (doc.data() as Map<String, dynamic>)['type'],
          'PRIVATE'
      );
    });

    test('updateType updates through all possible type values', () async {
      final challenge = await challengeRepository.createChallenge(
          createTestChallenge(type: ChallengeTypeEnum.PUBLIC)
      );

      // Test all type transitions
      for (final type in ChallengeTypeEnum.values) {
        final updated = await challengeRepository.updateType(challenge.id!, type);
        expect(updated.type, type);

        // Verify in Firestore
        final doc = await challengesCollection.doc(challenge.id).get();
        expect(
            (doc.data() as Map<String, dynamic>)['type'],
            type.toString().split('.').last
        );
      }
    });

    test('updateType handles invalid challenge ID', () async {
      expect(
              () => challengeRepository.updateType(
              'non-existent-id',
              ChallengeTypeEnum.PRIVATE
          ),
          throwsException
      );
    });

    test('updateType followed by updateStatus maintains both values', () async {
      final challenge = await challengeRepository.createChallenge(
          createTestChallenge(
              type: ChallengeTypeEnum.PUBLIC,
              status: ChallengeStatusEnum.ONGOING
          )
      );

      // Update type first
      final typeUpdated = await challengeRepository.updateType(
          challenge.id!,
          ChallengeTypeEnum.PRIVATE
      );
      expect(typeUpdated.type, ChallengeTypeEnum.PRIVATE);
      expect(typeUpdated.status, ChallengeStatusEnum.ONGOING);

      // Then update status
      final bothUpdated = await challengeRepository.updateStatus(
          challenge.id!,
          ChallengeStatusEnum.COMPLETED
      );
      expect(bothUpdated.type, ChallengeTypeEnum.PRIVATE);
      expect(bothUpdated.status, ChallengeStatusEnum.COMPLETED);
    });
  });
}
