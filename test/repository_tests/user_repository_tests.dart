import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:runmate/repositories/user_repository.dart';
import 'package:runmate/models/user.dart';

void main() {
  group('UserRepository Tests', () {
    late UserRepository userRepository;
    late FakeFirebaseFirestore fakeFirestore;
    late CollectionReference usersCollection;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      userRepository = UserRepository.withMockFirestore(fakeFirestore);
      usersCollection = fakeFirestore.collection('users');
    });

    test('createUser adds a user to Firestore and returns the created user', () async {
      final user = User(
        name: 'John Doe',
        email: 'john@example.com',
      );

      final createdUser = await userRepository.createUser(user);

      final doc = await usersCollection.doc(createdUser.id).get();
      expect(doc.exists, true);
      expect((doc.data() as Map<String, dynamic>)['name'], 'John Doe');
      expect((doc.data() as Map<String, dynamic>)['email'], 'john@example.com');
    });

    test('getAllUsers returns empty list when no users exist', () async {
      final users = await userRepository.getAllUsers();
      expect(users, isEmpty);
    });

    test('getAllUsers returns all users in the collection', () async {
      // Create multiple users
      final user1 = await userRepository.createUser(User(
        name: 'John Doe',
        email: 'john@example.com',
        totalDistance: 100.0,
        totalTime: 60,
      ));

      final user2 = await userRepository.createUser(User(
        name: 'Jane Smith',
        email: 'jane@example.com',
        totalDistance: 150.0,
        totalTime: 90,
      ));

      final user3 = await userRepository.createUser(User(
        name: 'Bob Johnson',
        email: 'bob@example.com',
        totalDistance: 75.0,
        totalTime: 45,
      ));

      // Get all users
      final users = await userRepository.getAllUsers();

      // Verify the number of users
      expect(users.length, 3);

      // Verify each user's data is present
      expect(users.any((u) => u.name == 'John Doe' && u.email == 'john@example.com' && u.totalDistance == 100.0 && u.totalTime == 60), isTrue);
      expect(users.any((u) => u.name == 'Jane Smith' && u.email == 'jane@example.com' && u.totalDistance == 150.0 && u.totalTime == 90), isTrue);
      expect(users.any((u) => u.name == 'Bob Johnson' && u.email == 'bob@example.com' && u.totalDistance == 75.0 && u.totalTime == 45), isTrue);
    });

    test('getUserById returns a User object if the document exists', () async {
      final user = User(
        name: 'Jane Doe',
        email: 'jane@example.com',
      );

      final createdUser = await userRepository.createUser(user);

      final searchedUser = await userRepository.getUserById(createdUser.id);

      expect(searchedUser, isNotNull);
      expect(createdUser.id, searchedUser.id);
      expect(searchedUser.name, 'Jane Doe');
      expect(searchedUser.email, 'jane@example.com');
    });

    test('getUserById throws an exception if the document does not exist', () async {
      const userId = 'non_existing_user';

      expect(
            () async => await userRepository.getUserById(userId),
        throwsException,
      );
    });

    test('updateUser updates user data in Firestore', () async {
      final user = User(
        name: 'Jane Doe',
        email: 'jane@example.com',
      );

      final createdUser = await userRepository.createUser(user);

      final updatedData = {'totalDistance': 100.0};
      final updatedUser = await userRepository.updateUser(createdUser.id, updatedData);

      final doc = await usersCollection.doc(createdUser.id).get();
      expect((doc.data() as Map<String, dynamic>)['totalDistance'], 100.0);
      expect(updatedUser.totalDistance, 100.0);
    });

    test('deleteUser removes the user from Firestore', () async {
      final user = User(
        name: 'Jane Doe',
        email: 'jane@example.com',
      );

      final createdUser = await userRepository.createUser(user);

      final result = await userRepository.deleteUser(createdUser.id);
      final doc = await usersCollection.doc(createdUser.id).get();

      expect(result, true);
      expect(doc.exists, false);
    });

    test('isUserExists returns true if user exists in Firestore', () async {
      final user = User(
        name: 'Jane Doe',
        email: 'jane@example.com',
      );

      final createdUser = await userRepository.createUser(user);

      final exists = await userRepository.isUserExists(createdUser.id);
      expect(exists, true);
    });

    test('isUserExists returns false if user does not exist in Firestore', () async {
      final userId = 'non_existing_user';

      final exists = await userRepository.isUserExists(userId);
      expect(exists, false);
    });

    test('addTotalDistance increases totalDistance for a user', () async {
      final user = User(
        name: 'Jane Doe',
        email: 'jane@example.com',
        totalDistance: 50.0,
      );

      final createdUser = await userRepository.createUser(user);

      final updatedUser = await userRepository.addTotalDistance(createdUser.id, 25.0);

      expect(updatedUser.totalDistance, 75.0);
    });

    test('addTotalTime increases totalTime for a user', () async {
      final user = User(
        name: 'Jane Doe',
        email: 'jane@example.com',
        totalTime: 120,
      );

      final createdUser = await userRepository.createUser(user);

      final updatedUser = await userRepository.addTotalTime(createdUser.id, 30);

      expect(updatedUser.totalTime, 150);
    });

    test('updateAvatarUrl updates the avatar URL of a user', () async {
      final user = User(
        name: 'Jane Doe',
        email: 'jane@example.com',
      );

      final createdUser = await userRepository.createUser(user);

      final updatedUser = await userRepository.updateAvatarUrl(createdUser.id, 'new_url');

      expect(updatedUser.avatarUrl, 'new_url');
    });

    test('updatePhoneNumber updates the phone number of a user', () async {
      final user = User(
        name: 'Jane Doe',
        email: 'jane@example.com',
      );

      final createdUser = await userRepository.createUser(user);

      final updatedUser = await userRepository.updatePhoneNumber(createdUser.id, '+1234567890');

      expect(updatedUser.phoneNumber, '+1234567890');

      final doc = await usersCollection.doc(createdUser.id).get();
      expect((doc.data() as Map<String, dynamic>)['phoneNumber'], '+1234567890');
    });

    test('updateAddress updates the address of a user', () async {
      final user = User(
        name: 'Jane Doe',
        email: 'jane@example.com',
      );

      final createdUser = await userRepository.createUser(user);

      final updatedUser = await userRepository.updateAddress(createdUser.id, '123 Main St');

      expect(updatedUser.address, '123 Main St');

      final doc = await usersCollection.doc(createdUser.id).get();
      expect((doc.data() as Map<String, dynamic>)['address'], '123 Main St');
    });

    test('updateDateOfBirth updates the date of birth of a user', () async {
      final user = User(
        name: 'Jane Doe',
        email: 'jane@example.com',
      );

      final createdUser = await userRepository.createUser(user);

      final newDateOfBirth = DateTime(1990, 1, 1);
      final updatedUser = await userRepository.updateDateOfBirth(createdUser.id, newDateOfBirth);

      expect(updatedUser.dateOfBirth, newDateOfBirth);

      final doc = await usersCollection.doc(createdUser.id).get();
      expect(DateTime.parse((doc.data() as Map<String, dynamic>)['dateOfBirth']), newDateOfBirth);
    });
  });
}