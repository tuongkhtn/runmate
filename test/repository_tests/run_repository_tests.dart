import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runmate/models/run.dart';
import 'package:runmate/repositories/run_repository.dart';

void main() {
  group('RunRepository Tests', () {
    late RunRepository runRepository;
    late FakeFirebaseFirestore fakeFirestore;
    late CollectionReference runsCollection;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      runRepository = RunRepository.withMockFirestore(fakeFirestore);
      runsCollection = fakeFirestore.collection('runs');
    });

    LatLngPoint createSamplePoint({
      double latitude = 40.7128,
      double longitude = -74.0060,
      DateTime? timestamp,
    }) {
      return LatLngPoint(
        latitude: latitude,
        longitude: longitude,
        timestamp: timestamp ?? DateTime.now(),
      );
    }

    Run createSampleRun({
      String userId = 'user123',
      String? challengeId = 'challenge123',
      double distance = 5.0,
      int duration = 1800,
      DateTime? date,
      int steps = 6000,
      double calories = 400,
      double averagePace = 6.0,
      double averageSpeed = 10.0,
      List<LatLngPoint>? route,
    }) {
      return Run(
        userId: userId,
        challengeId: challengeId,
        distance: distance,
        duration: duration,
        date: date ?? DateTime.now(),
        steps: steps,
        calories: calories,
        averagePace: averagePace,
        averageSpeed: averageSpeed,
        route: route ?? [createSamplePoint()],
      );
    }

    test('addRun adds a run to Firestore and returns the created run', () async {
      final run = createSampleRun();
      final createdRun = await runRepository.addRun(run);

      expect(createdRun.id, isNotNull);
      expect(createdRun.userId, run.userId);
      expect(createdRun.distance, run.distance);

      final doc = await runsCollection.doc(createdRun.id).get();
      expect(doc.exists, true);
      expect((doc.data() as Map<String, dynamic>)['userId'], run.userId);
    });

    test('getRunById returns a Run if it exists', () async {
      final run = createSampleRun();
      final createdRun = await runRepository.addRun(run);

      final fetchedRun = await runRepository.getRunById(createdRun.id);
      expect(fetchedRun, isNotNull);
      expect(fetchedRun?.id, createdRun.id);
      expect(fetchedRun?.userId, run.userId);
    });

    test('getRunById returns null for non-existent run', () async {
      final fetchedRun = await runRepository.getRunById('non_existent_id');
      expect(fetchedRun, isNull);
    });

    test('getAllRuns returns all runs in the collection', () async {
      final run1 = createSampleRun(userId: 'user1');
      final run2 = createSampleRun(userId: 'user2');
      await runRepository.addRun(run1);
      await runRepository.addRun(run2);

      final runs = await runRepository.getAllRuns();
      expect(runs.length, 2);
      expect(runs.any((r) => r.userId == 'user1'), true);
      expect(runs.any((r) => r.userId == 'user2'), true);
    });

    test('getRunsByUserId returns runs for specific user', () async {
      final run1 = createSampleRun(userId: 'user1');
      final run2 = createSampleRun(userId: 'user1');
      final run3 = createSampleRun(userId: 'user2');
      await runRepository.addRun(run1);
      await runRepository.addRun(run2);
      await runRepository.addRun(run3);

      final userRuns = await runRepository.getRunsByUserId('user1');
      expect(userRuns.length, 2);
      expect(userRuns.every((r) => r.userId == 'user1'), true);
    });

    test('getRunsByChallengeId returns runs for specific challenge', () async {
      final run1 = createSampleRun(challengeId: 'challenge1');
      final run2 = createSampleRun(challengeId: 'challenge1');
      final run3 = createSampleRun(challengeId: 'challenge2');
      await runRepository.addRun(run1);
      await runRepository.addRun(run2);
      await runRepository.addRun(run3);

      final challengeRuns = await runRepository.getRunsByChallengeId('challenge1');
      expect(challengeRuns.length, 2);
      expect(challengeRuns.every((r) => r.challengeId == 'challenge1'), true);
    });

    test('updateRun updates run data in Firestore', () async {
      final run = createSampleRun();
      final createdRun = await runRepository.addRun(run);

      final updatedRun = Run(
        userId: createdRun.userId,
        distance: 10.0,
        duration: 3600,
        date: createdRun.date,
      );
      updatedRun.id = createdRun.id;

      final result = await runRepository.updateRun(updatedRun);
      expect(result.distance, 10.0);
      expect(result.duration, 3600);

      final doc = await runsCollection.doc(createdRun.id).get();
      expect((doc.data() as Map<String, dynamic>)['distance'], 10.0);
      expect((doc.data() as Map<String, dynamic>)['duration'], 3600);
    });

    test('updateRoute updates route points correctly', () async {
      final run = createSampleRun();
      final createdRun = await runRepository.addRun(run);

      final newRoute = [
        createSamplePoint(latitude: 40.0, longitude: -74.0),
        createSamplePoint(latitude: 40.1, longitude: -74.1),
      ];

      final updatedRun = await runRepository.updateRoute(createdRun.id!, newRoute);
      expect(updatedRun.route.length, 2);
      expect(updatedRun.route.first.latitude, 40.0);
      expect(updatedRun.route.last.longitude, -74.1);
    });

    test('addRoutePoint adds a new point to existing route', () async {
      final run = createSampleRun(route: [createSamplePoint()]);
      final createdRun = await runRepository.addRun(run);

      final newPoint = createSamplePoint(
        latitude: 41.0,
        longitude: -75.0,
      );

      final updatedRun = await runRepository.addRoutePoint(createdRun.id!, newPoint);
      expect(updatedRun.route.length, 2);
      expect(updatedRun.route.last.latitude, 41.0);
      expect(updatedRun.route.last.longitude, -75.0);
    });

    test('getRunLatestByUserId returns most recent run', () async {
      final pastRun = createSampleRun(
        userId: 'user1',
        date: DateTime.now().subtract(Duration(days: 1)),
      );
      final recentRun = createSampleRun(
        userId: 'user1',
        date: DateTime.now(),
      );
      await runRepository.addRun(pastRun);
      await runRepository.addRun(recentRun);

      final latestRun = await runRepository.getRunLatestByUserId('user1');
      expect(latestRun.date.day, recentRun.date.day);
    });

    test('deleteRun removes the run from Firestore', () async {
      final run = createSampleRun();
      final createdRun = await runRepository.addRun(run);

      await runRepository.deleteRun(createdRun.id!);
      final doc = await runsCollection.doc(createdRun.id).get();
      expect(doc.exists, false);
    });
  });
}