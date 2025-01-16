import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:runmate/enums/challenge_status_enum.dart';
import 'package:runmate/enums/challenge_type_enum.dart';
import 'package:runmate/models/challenge.dart';
import 'package:runmate/models/participant.dart';
import 'package:runmate/repositories/challenge_repository.dart';
import 'package:runmate/repositories/participant_repository.dart';
import 'participant_repository_tests.mocks.dart';

@GenerateMocks([ChallengeRepository])
void main() {
  group('ParticipantRepository Tests', () {
    late ParticipantRepository participantRepository;
    late FakeFirebaseFirestore fakeFirestore;
    late CollectionReference participantsCollection;
    late MockChallengeRepository mockChallengeRepository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockChallengeRepository = MockChallengeRepository();
      participantRepository = ParticipantRepository.withMockFirestore(fakeFirestore, challengeRepository: mockChallengeRepository);
      participantsCollection = fakeFirestore.collection('participants');
    });

    test('addParticipant adds a participant to Firestore and returns the created participant', () async {
      Challenge challenge = Challenge(
        ownerId: 'user123',
        name: 'Challenge 1',
        goalDistance: 100.0,
        type: ChallengeTypeEnum.PRIVATE,
        status: ChallengeStatusEnum.ONGOING,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      );
      challenge.id = 'challenge123';

      when(mockChallengeRepository.getChallengeById('challenge123')).thenAnswer((_) async => challenge);

      challenge.totalNumberOfParticipants = 1;
      when(mockChallengeRepository.addTotalNumberOfParticipants('challenge123', 1)).thenAnswer((_) async => challenge);

      final participant = Participant(
        userId: 'user123',
        challengeId: 'challenge123',
        totalDistance: 10.0,
        createdAt: DateTime.now(),
      );

      final createdParticipant = await participantRepository.addParticipant(participant);

      final doc = await participantsCollection.doc(createdParticipant.id).get();
      expect(doc.exists, true);
      expect((doc.data() as Map<String, dynamic>)['userId'], 'user123');
      expect((doc.data() as Map<String, dynamic>)['challengeId'], 'challenge123');
      expect((doc.data() as Map<String, dynamic>)['totalDistance'], 10.0);
    });

    test('getParticipantById returns a Participant object if the document exists', () async {
      Challenge challenge = Challenge(
        ownerId: 'user123',
        name: 'Challenge 1',
        goalDistance: 100.0,
        type: ChallengeTypeEnum.PRIVATE,
        status: ChallengeStatusEnum.ONGOING,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      );
      challenge.id = 'challenge123';
      when(mockChallengeRepository.getChallengeById('challenge123')).thenAnswer((_) async => challenge);

      challenge.totalNumberOfParticipants = 1;
      when(mockChallengeRepository.addTotalNumberOfParticipants('challenge123', 1)).thenAnswer((_) async => challenge);

      final participant = Participant(
        userId: 'user123',
        challengeId: 'challenge123',
        totalDistance: 10.0,
        createdAt: DateTime.now(),
      );

      final createdParticipant = await participantRepository.addParticipant(participant);
      final fetchedParticipant = await participantRepository.getParticipantById(createdParticipant.id!);

      expect(fetchedParticipant, isNotNull);
      expect(fetchedParticipant?.id, createdParticipant.id);
      expect(fetchedParticipant?.userId, 'user123');
      expect(fetchedParticipant?.challengeId, 'challenge123');
      expect(fetchedParticipant?.totalDistance, 10.0);
    });

    test('getParticipantById returns null if the document does not exist',
            () async {
          final participant = await participantRepository.getParticipantById('non_existing_id');
          expect(participant, isNull);
        });

    test('getAllParticipants returns all participants in the collection', () async {
      Challenge challenge = Challenge(
        ownerId: 'user123',
        name: 'Challenge 1',
        goalDistance: 100.0,
        type: ChallengeTypeEnum.PRIVATE,
        status: ChallengeStatusEnum.ONGOING,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      );
      challenge.id = 'challenge1';
      when(mockChallengeRepository.getChallengeById('challenge1')).thenAnswer((_) async => challenge);

      // Create multiple participants
      challenge.totalNumberOfParticipants = 1;
      when(mockChallengeRepository.addTotalNumberOfParticipants('challenge1', 1)).thenAnswer((_) async => challenge);
      final participant1 = await participantRepository.addParticipant(
        Participant(userId: 'user1', totalDistance: 10.0, challengeId: 'challenge1'),
      );

      challenge.totalNumberOfParticipants = 2;
      when(mockChallengeRepository.addTotalNumberOfParticipants('challenge1', 1)).thenAnswer((_) async => challenge);
      final participant2 = await participantRepository.addParticipant(
        Participant(userId: 'user2', totalDistance: 20.0, challengeId: 'challenge1'),
      );

      final participants = await participantRepository.getAllParticipants();

      expect(participants.length, 2);
      expect(participants.any((p) => p.userId == 'user1' && p.totalDistance == 10.0), true);
      expect(participants.any((p) => p.userId == 'user2' && p.totalDistance == 20.0), true);
    });

    test('getParticipantsByUserId returns participants for specific user', () async {
      Challenge challenge1 = Challenge(
        ownerId: 'user123',
        name: 'Challenge 1',
        goalDistance: 100.0,
        type: ChallengeTypeEnum.PRIVATE,
        status: ChallengeStatusEnum.ONGOING,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      );
      challenge1.id = 'challenge1';
      when(mockChallengeRepository.getChallengeById('challenge1')).thenAnswer((_) async => challenge1);

      challenge1.totalNumberOfParticipants = 1;
      when(mockChallengeRepository.addTotalNumberOfParticipants('challenge1', 1)).thenAnswer((_) async => challenge1);
      await participantRepository.addParticipant(
        Participant(userId: 'user1', totalDistance: 10.0, challengeId: 'challenge1'),
      );

      challenge1.totalNumberOfParticipants = 2;
      when(mockChallengeRepository.addTotalNumberOfParticipants('challenge1', 1)).thenAnswer((_) async => challenge1);
      await participantRepository.addParticipant(
        Participant(userId: 'user2', totalDistance: 30.0, challengeId: 'challenge1'),
      );

      Challenge challenge2 = Challenge(
        ownerId: 'user123',
        name: 'Challenge 2',
        goalDistance: 100.0,
        type: ChallengeTypeEnum.PRIVATE,
        status: ChallengeStatusEnum.ONGOING,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      );
      challenge2.id = 'challenge2';
      when(mockChallengeRepository.getChallengeById('challenge2')).thenAnswer((_) async => challenge2);

      challenge2.totalNumberOfParticipants = 1;
      when(mockChallengeRepository.addTotalNumberOfParticipants('challenge2', 1)).thenAnswer((_) async => challenge2);
      await participantRepository.addParticipant(
        Participant(userId: 'user1', totalDistance: 20.0, challengeId: 'challenge2'),
      );

      final user1Participants = await participantRepository.getParticipantsByUserId('user1');
      expect(user1Participants.length, 2);
      expect(user1Participants.every((p) => p.userId == 'user1'), true);
    });

    test('updateParticipant updates participant data in Firestore', () async {
      Challenge challenge = Challenge(
        ownerId: 'user123',
        name: 'Challenge 1',
        goalDistance: 100.0,
        type: ChallengeTypeEnum.PRIVATE,
        status: ChallengeStatusEnum.ONGOING,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      );
      challenge.id = 'challenge1';
      when(mockChallengeRepository.getChallengeById('challenge1')).thenAnswer((_) async => challenge);

      // Create multiple participants
      challenge.totalNumberOfParticipants = 1;
      when(mockChallengeRepository.addTotalNumberOfParticipants('challenge1', 1)).thenAnswer((_) async => challenge);
      final participant = await participantRepository.addParticipant(
        Participant(userId: 'user1', totalDistance: 10.0, challengeId: 'challenge1'),
      );

      final updatedParticipant = await participantRepository.updateParticipant(
        participant.id!,
        Participant(userId: 'user1', totalDistance: 20.0, challengeId: 'challenge1'),
      );

      expect(updatedParticipant.totalDistance, 20.0);

      final doc = await participantsCollection.doc(participant.id).get();
      expect((doc.data() as Map<String, dynamic>)['totalDistance'], 20.0);
    });

    test('updateTotalDistance updates only the total distance', () async {
      Challenge challenge = Challenge(
        ownerId: 'user123',
        name: 'Challenge 1',
        goalDistance: 100.0,
        type: ChallengeTypeEnum.PRIVATE,
        status: ChallengeStatusEnum.ONGOING,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      );
      challenge.id = 'challenge1';
      when(mockChallengeRepository.getChallengeById('challenge1')).thenAnswer((_) async => challenge);

      // Create multiple participants
      challenge.totalNumberOfParticipants = 1;
      when(mockChallengeRepository.addTotalNumberOfParticipants('challenge1', 1)).thenAnswer((_) async => challenge);
      final participant = await participantRepository.addParticipant(
        Participant(userId: 'user1', totalDistance: 10.0, challengeId: 'challenge1'),
      );

      final updatedParticipant = await participantRepository.updateTotalDistance(
        participant.id!,
        25.0,
      );

      expect(updatedParticipant.totalDistance, 25.0);
      expect(updatedParticipant.userId, 'user1');
      expect(updatedParticipant.challengeId, 'challenge1');
    });

    test('deleteParticipant removes the participant from Firestore', () async {
      Challenge challenge = Challenge(
        ownerId: 'user123',
        name: 'Challenge 1',
        goalDistance: 100.0,
        type: ChallengeTypeEnum.PRIVATE,
        status: ChallengeStatusEnum.ONGOING,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      );
      challenge.id = 'challenge1';
      when(mockChallengeRepository.getChallengeById('challenge1')).thenAnswer((_) async => challenge);

      challenge.totalNumberOfParticipants = 1;
      when(mockChallengeRepository.addTotalNumberOfParticipants('challenge1', 1)).thenAnswer((_) async => challenge);

      final participant = await participantRepository.addParticipant(
        Participant(userId: 'user1', totalDistance: 10.0, challengeId: 'challenge1'),
      );

      await participantRepository.deleteParticipant(participant.id!);

      final doc = await participantsCollection.doc(participant.id).get();
      expect(doc.exists, false);
    });
  });
}