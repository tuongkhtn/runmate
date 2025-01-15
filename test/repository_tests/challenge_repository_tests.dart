import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      DateTime? startDate,
      DateTime? endDate,
      double goalDistance = 100.0,
    }) {
      return Challenge(
        ownerId: ownerId,
        name: name,
        startDate: startDate ?? DateTime.now(),
        endDate: endDate ?? DateTime.now().add(const Duration(days: 7)),
        goalDistance: goalDistance,
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
  });
}