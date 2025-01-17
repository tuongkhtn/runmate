import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:runmate/models/challenge.dart';
import 'package:runmate/repositories/challenge_repository.dart';
import 'package:runmate/repositories/participant_repository.dart';
import 'package:runmate/repositories/run_repository.dart';
import 'package:runmate/repositories/user_repository.dart';

import 'enums/challenge_status_enum.dart';
import 'enums/challenge_type_enum.dart';
import 'firebase_options.dart';
import 'models/participant.dart';
import 'models/run.dart';
import 'models/user.dart';

class InitializeFirebase {
  static final UserRepository _userRepository = UserRepository();
  static final ChallengeRepository _challengeRepository = ChallengeRepository();
  static final ParticipantRepository _participantRepository = ParticipantRepository();
  static final RunRepository _runRepository = RunRepository();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await _initializeUser();
    await _initializeChallenge();
    await _initializeParticipant();
    await _initializeRun();
  }

  static Future<void> _initializeUser() async {
    _userRepository.createUser(User(
      name: "John Doe",
      email: "johndoe@gmail.com",
      avatarUrl: "https://example.com/avatar.jpg",
      totalDistance: 0.0,
      totalTime: 0,
      phoneNumber: "1234567890",
      address: "123 Main St, Springfield, IL 62701",
      dateOfBirth: DateTime(1990, 1, 1),
    ));

    _userRepository.createUser(User(
      name: "Jane Doe",
      email: "janedoe@gmail.com",
      avatarUrl: "https://example.com/avatar.jpg",
      totalDistance: 0.0,
      totalTime: 0,
      phoneNumber: "0987654321",
      address: "456 Elm St, Springfield, IL 62702",
      dateOfBirth: DateTime(1995, 1, 1),
    ));

    _userRepository.createUser(User(
      name: "Alice Smith",
      email: "alicesmith@gmail.com",
      avatarUrl: "https://example.com/avatar.jpg",
      totalDistance: 0.0,
      totalTime: 0,
      phoneNumber: "1112223333",
      address: "789 Oak St, Springfield, IL 62703",
      dateOfBirth: DateTime(1988, 2, 2),
    ));

    _userRepository.createUser(User(
      name: "Bob Johnson",
      email: "bobjohnson@gmail.com",
      avatarUrl: "https://example.com/avatar.jpg",
      totalDistance: 0.0,
      totalTime: 0,
      phoneNumber: "4445556666",
      address: "101 Pine St, Springfield, IL 62704",
      dateOfBirth: DateTime(1985, 3, 3),
    ));

    _userRepository.createUser(User(
      name: "Charlie Brown",
      email: "charliebrown@gmail.com",
      avatarUrl: "https://example.com/avatar.jpg",
      totalDistance: 0.0,
      totalTime: 0,
      phoneNumber: "7778889999",
      address: "202 Maple St, Springfield, IL 62705",
      dateOfBirth: DateTime(1992, 4, 4),
    ));

    _userRepository.createUser(User(
      name: "David Wilson",
      email: "davidwilson@gmail.com",
      avatarUrl: "https://example.com/avatar.jpg",
      totalDistance: 0.0,
      totalTime: 0,
      phoneNumber: "1231231234",
      address: "303 Birch St, Springfield, IL 62706",
      dateOfBirth: DateTime(1991, 5, 5),
    ));

    _userRepository.createUser(User(
      name: "Eve Davis",
      email: "evedavis@gmail.com",
      avatarUrl: "https://example.com/avatar.jpg",
      totalDistance: 0.0,
      totalTime: 0,
      phoneNumber: "2342342345",
      address: "404 Cedar St, Springfield, IL 62707",
      dateOfBirth: DateTime(1993, 6, 6),
    ));

    _userRepository.createUser(User(
      name: "Frank Miller",
      email: "frankmiller@gmail.com",
      avatarUrl: "https://example.com/avatar.jpg",
      totalDistance: 0.0,
      totalTime: 0,
      phoneNumber: "3453453456",
      address: "505 Walnut St, Springfield, IL 62708",
      dateOfBirth: DateTime(1989, 7, 7),
    ));

    _userRepository.createUser(User(
      name: "Grace Lee",
      email: "gracelee@gmail.com",
      avatarUrl: "https://example.com/avatar.jpg",
      totalDistance: 0.0,
      totalTime: 0,
      phoneNumber: "4564564567",
      address: "606 Chestnut St, Springfield, IL 62709",
      dateOfBirth: DateTime(1994, 8, 8),
    ));

    _userRepository.createUser(User(
      name: "Hank Green",
      email: "hankgreen@gmail.com",
      avatarUrl: "https://example.com/avatar.jpg",
      totalDistance: 0.0,
      totalTime: 0,
      phoneNumber: "5675675678",
      address: "707 Ash St, Springfield, IL 62710",
      dateOfBirth: DateTime(1996, 9, 9),
    ));

    _userRepository.createUser(User(
      name: "Ivy White",
      email: "ivywhite@gmail.com",
      avatarUrl: "https://example.com/avatar.jpg",
      totalDistance: 0.0,
      totalTime: 0,
      phoneNumber: "6786786789",
      address: "808 Poplar St, Springfield, IL 62711",
      dateOfBirth: DateTime(1997, 10, 10),
    ));

    _userRepository.createUser(User(
      name: "Jack Black",
      email: "jackblack@gmail.com",
      avatarUrl: "https://example.com/avatar.jpg",
      totalDistance: 0.0,
      totalTime: 0,
      phoneNumber: "7897897890",
      address: "909 Willow St, Springfield, IL 62712",
      dateOfBirth: DateTime(1998, 11, 11),
    ));
  }

  static Future<void> _initializeChallenge() async {
    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("johndoe@gmail.com")).id!,
      name: "Challenge 1",
      description: "Description 1",
      longDescription: "Long Description 1",
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 3, 31),
      goalDistance: 100.0,
      status: ChallengeStatusEnum.ongoing,
      type: ChallengeTypeEnum.public,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("janedoe@gmail.com")).id!,
      name: "Challenge 2",
      description: "Description 2",
      longDescription: "Long Description 2",
      startDate: DateTime(2024, 2, 1),
      endDate: DateTime(2024, 4, 30),
      goalDistance: 200.0,
      status: ChallengeStatusEnum.completed,
      type: ChallengeTypeEnum.public,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("alicesmith@gmail.com")).id!,
      name: "Challenge 3",
      description: "Description 3",
      longDescription: "Long Description 3",
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 5, 31),
      goalDistance: 300.0,
      status: ChallengeStatusEnum.ongoing,
      type: ChallengeTypeEnum.private,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("bobjohnson@gmail.com")).id!,
      name: "Challenge 4",
      description: "Description 4",
      longDescription: "Long Description 4",
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 6, 30),
      goalDistance: 400.0,
      status: ChallengeStatusEnum.ongoing,
      type: ChallengeTypeEnum.public,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("charliebrown@gmail.com")).id!,
      name: "Challenge 5",
      description: "Description 5",
      longDescription: "Long Description 5",
      startDate: DateTime(2024, 5, 1),
      endDate: DateTime(2025, 7, 31),
      goalDistance: 500.0,
      status: ChallengeStatusEnum.ongoing,
      type: ChallengeTypeEnum.private,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("davidwilson@gmail.com")).id!,
      name: "Challenge 6",
      description: "Description 6",
      longDescription: "Long Description 6",
      startDate: DateTime(2024, 6, 1),
      endDate: DateTime(2024, 8, 31),
      goalDistance: 600.0,
      status: ChallengeStatusEnum.completed,
      type: ChallengeTypeEnum.public,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("evedavis@gmail.com")).id!,
      name: "Challenge 7",
      description: "Description 7",
      longDescription: "Long Description 7",
      startDate: DateTime(2024, 7, 1),
      endDate: DateTime(2024, 9, 30),
      goalDistance: 700.0,
      status: ChallengeStatusEnum.completed,
      type: ChallengeTypeEnum.private,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("frankmiller@gmail.com")).id!,
      name: "Challenge 8",
      description: "Description 8",
      longDescription: "Long Description 8",
      startDate: DateTime(2023, 8, 1),
      endDate: DateTime(2023, 10, 31),
      goalDistance: 800.0,
      status: ChallengeStatusEnum.completed,
      type: ChallengeTypeEnum.private,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("gracelee@gmail.com")).id!,
      name: "Challenge 9",
      description: "Description 9",
      longDescription: "Long Description 9",
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2025, 11, 30),
      goalDistance: 900.0,
      status: ChallengeStatusEnum.ongoing,
      type: ChallengeTypeEnum.public,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("hankgreen@gmail.com")).id!,
      name: "Challenge 10",
      description: "Description 10",
      longDescription: "Long Description 10",
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 12, 31),
      goalDistance: 1000.0,
      status: ChallengeStatusEnum.ongoing,
      type: ChallengeTypeEnum.public,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("ivywhite@gmail.com")).id!,
      name: "Challenge 11",
      description: "Description 11",
      longDescription: "Long Description 11",
      startDate: DateTime(2025, 11, 1),
      endDate: DateTime(2026, 1, 31),
      goalDistance: 1100.0,
      status: ChallengeStatusEnum.ongoing,
      type: ChallengeTypeEnum.public,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("jackblack@gmail.com")).id!,
      name: "Challenge 12",
      description: "Description 12",
      longDescription: "Long Description 12",
      startDate: DateTime(2021, 12, 1),
      endDate: DateTime(2026, 2, 29),
      goalDistance: 1200.0,
      status: ChallengeStatusEnum.ongoing,
      type: ChallengeTypeEnum.private,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("johndoe@gmail.com")).id!,
      name: "Challenge 13",
      description: "Description 13",
      longDescription: "Long Description 13",
      startDate: DateTime(2023, 1, 1),
      endDate: DateTime(2024, 3, 31),
      goalDistance: 1300.0,
      status: ChallengeStatusEnum.completed,
      type: ChallengeTypeEnum.private,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("janedoe@gmail.com")).id!,
      name: "Challenge 14",
      description: "Description 14",
      longDescription: "Long Description 14",
      startDate: DateTime(2022, 2, 1),
      endDate: DateTime(2024, 4, 30),
      goalDistance: 1400.0,
      status: ChallengeStatusEnum.completed,
      type: ChallengeTypeEnum.public,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("alicesmith@gmail.com")).id!,
      name: "Challenge 15",
      description: "Description 15",
      longDescription: "Long Description 15",
      startDate: DateTime(2024, 3, 1),
      endDate: DateTime(2024, 5, 31),
      goalDistance: 1500.0,
      status: ChallengeStatusEnum.completed,
      type: ChallengeTypeEnum.public,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("bobjohnson@gmail.com")).id!,
      name: "Challenge 16",
      description: "Description 16",
      longDescription: "Long Description 16",
      startDate: DateTime(2024, 4, 1),
      endDate: DateTime(2026, 6, 30),
      goalDistance: 1600.0,
      status: ChallengeStatusEnum.ongoing,
      type: ChallengeTypeEnum.public,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("charliebrown@gmail.com")).id!,
      name: "Challenge 17",
      description: "Description 17",
      longDescription: "Long Description 17",
      startDate: DateTime(2023, 5, 1),
      endDate: DateTime(2026, 7, 31),
      goalDistance: 1700.0,
      status: ChallengeStatusEnum.ongoing,
      type: ChallengeTypeEnum.private,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("davidwilson@gmail.com")).id!,
      name: "Challenge 18",
      description: "Description 18",
      longDescription: "Long Description 18",
      startDate: DateTime(2024, 6, 1),
      endDate: DateTime(2026, 8, 31),
      goalDistance: 1800.0,
      status: ChallengeStatusEnum.ongoing,
      type: ChallengeTypeEnum.public,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("evedavis@gmail.com")).id!,
      name: "Challenge 19",
      description: "Description 19",
      longDescription: "Long Description 19",
      startDate: DateTime(2024, 7, 1),
      endDate: DateTime(2024, 9, 30),
      goalDistance: 1900.0,
      status: ChallengeStatusEnum.completed,
      type: ChallengeTypeEnum.public,
    ));

    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("frankmiller@gmail.com")).id!,
      name: "Challenge 20",
      description: "Description 20",
      longDescription: "Long Description 20",
      startDate: DateTime(2021, 8, 1),
      endDate: DateTime(2025, 10, 31),
      goalDistance: 2000.0,
      status: ChallengeStatusEnum.completed,
      type: ChallengeTypeEnum.private,
    ));
  }

  static Future<void> _initializeParticipant() async {
      final users = await Future.wait([
        _userRepository.getUserByEmail("johndoe@gmail.com"),
        _userRepository.getUserByEmail("janedoe@gmail.com"),
        _userRepository.getUserByEmail("alicesmith@gmail.com"),
        _userRepository.getUserByEmail("ivywhite@gmail.com"),
        _userRepository.getUserByEmail("johndoe@gmail.com"),
        _userRepository.getUserByEmail("jackblack@gmail.com"),
        _userRepository.getUserByEmail("bobjohnson@gmail.com"),
        _userRepository.getUserByEmail("charliebrown@gmail.com"),
        _userRepository.getUserByEmail("davidwilson@gmail.com"),
        _userRepository.getUserByEmail("jackblack@gmail.com"),
        _userRepository.getUserByEmail("bobjohnson@gmail.com"),
        _userRepository.getUserByEmail("frankmiller@gmail.com"),
        _userRepository.getUserByEmail("davidwilson@gmail.com"),
        _userRepository.getUserByEmail("janedoe@gmail.com"),
        _userRepository.getUserByEmail("jackblack@gmail.com"),
        _userRepository.getUserByEmail("janedoe@gmail.com"),
        _userRepository.getUserByEmail("jackblack@gmail.com"),
        _userRepository.getUserByEmail("evedavis@gmail.com"),
        _userRepository.getUserByEmail("bobjohnson@gmail.com"),
        _userRepository.getUserByEmail("ivywhite@gmail.com"),
        _userRepository.getUserByEmail("gracelee@gmail.com"),
        _userRepository.getUserByEmail("davidwilson@gmail.com"),
        _userRepository.getUserByEmail("hankgreen@gmail.com"),
        _userRepository.getUserByEmail("jackblack@gmail.com"),
        _userRepository.getUserByEmail("jackblack@gmail.com"),
        _userRepository.getUserByEmail("hankgreen@gmail.com"),
        _userRepository.getUserByEmail("evedavis@gmail.com"),
        _userRepository.getUserByEmail("frankmiller@gmail.com"),
        _userRepository.getUserByEmail("evedavis@gmail.com"),
        _userRepository.getUserByEmail("jackblack@gmail.com"),
        _userRepository.getUserByEmail("hankgreen@gmail.com"),
        _userRepository.getUserByEmail("jackblack@gmail.com"),
        _userRepository.getUserByEmail("bobjohnson@gmail.com"),
        _userRepository.getUserByEmail("jackblack@gmail.com"),
        _userRepository.getUserByEmail("johndoe@gmail.com"),
        _userRepository.getUserByEmail("ivywhite@gmail.com"),
        _userRepository.getUserByEmail("ivywhite@gmail.com"),
        _userRepository.getUserByEmail("evedavis@gmail.com"),
        _userRepository.getUserByEmail("evedavis@gmail.com"),
        _userRepository.getUserByEmail("hankgreen@gmail.com"),
        _userRepository.getUserByEmail("frankmiller@gmail.com"),
        _userRepository.getUserByEmail("hankgreen@gmail.com"),
        _userRepository.getUserByEmail("johndoe@gmail.com"),
        _userRepository.getUserByEmail("evedavis@gmail.com"),
        _userRepository.getUserByEmail("frankmiller@gmail.com"),
        _userRepository.getUserByEmail("evedavis@gmail.com"),
        _userRepository.getUserByEmail("frankmiller@gmail.com"),
        _userRepository.getUserByEmail("gracelee@gmail.com"),
        _userRepository.getUserByEmail("hankgreen@gmail.com"),
        _userRepository.getUserByEmail("ivywhite@gmail.com"),
        _userRepository.getUserByEmail("jackblack@gmail.com"),
      ]);

      final challenges = await Future.wait([
        _challengeRepository.getChallengeByName("Challenge 1"),
        _challengeRepository.getChallengeByName("Challenge 2"),
        _challengeRepository.getChallengeByName("Challenge 15"),
        _challengeRepository.getChallengeByName("Challenge 3"),
        _challengeRepository.getChallengeByName("Challenge 2"),
        _challengeRepository.getChallengeByName("Challenge 4"),
        _challengeRepository.getChallengeByName("Challenge 3"),
        _challengeRepository.getChallengeByName("Challenge 1"),
        _challengeRepository.getChallengeByName("Challenge 8"),
        _challengeRepository.getChallengeByName("Challenge 5"),
        _challengeRepository.getChallengeByName("Challenge 8"),
        _challengeRepository.getChallengeByName("Challenge 6"),
        _challengeRepository.getChallengeByName("Challenge 8"),
        _challengeRepository.getChallengeByName("Challenge 3"),
        _challengeRepository.getChallengeByName("Challenge 1"),
        _challengeRepository.getChallengeByName("Challenge 8"),
        _challengeRepository.getChallengeByName("Challenge 13"),
        _challengeRepository.getChallengeByName("Challenge 7"),
        _challengeRepository.getChallengeByName("Challenge 8"),
        _challengeRepository.getChallengeByName("Challenge 12"),
        _challengeRepository.getChallengeByName("Challenge 1"),
        _challengeRepository.getChallengeByName("Challenge 3"),
        _challengeRepository.getChallengeByName("Challenge 3"),
        _challengeRepository.getChallengeByName("Challenge 8"),
        _challengeRepository.getChallengeByName("Challenge 15"),
        _challengeRepository.getChallengeByName("Challenge 2"),
        _challengeRepository.getChallengeByName("Challenge 1"),
        _challengeRepository.getChallengeByName("Challenge 8"),
        _challengeRepository.getChallengeByName("Challenge 9"),
        _challengeRepository.getChallengeByName("Challenge 10"),
        _challengeRepository.getChallengeByName("Challenge 7"),
        _challengeRepository.getChallengeByName("Challenge 1"),
        _challengeRepository.getChallengeByName("Challenge 10"),
        _challengeRepository.getChallengeByName("Challenge 2"),
        _challengeRepository.getChallengeByName("Challenge 11"),
        _challengeRepository.getChallengeByName("Challenge 8"),
        _challengeRepository.getChallengeByName("Challenge 12"),
        _challengeRepository.getChallengeByName("Challenge 20"),
        _challengeRepository.getChallengeByName("Challenge 1"),
        _challengeRepository.getChallengeByName("Challenge 19"),
        _challengeRepository.getChallengeByName("Challenge 13"),
        _challengeRepository.getChallengeByName("Challenge 6"),
        _challengeRepository.getChallengeByName("Challenge 14"),
        _challengeRepository.getChallengeByName("Challenge 13"),
        _challengeRepository.getChallengeByName("Challenge 15"),
        _challengeRepository.getChallengeByName("Challenge 16"),
        _challengeRepository.getChallengeByName("Challenge 1"),
        _challengeRepository.getChallengeByName("Challenge 17"),
        _challengeRepository.getChallengeByName("Challenge 18"),
        _challengeRepository.getChallengeByName("Challenge 13"),
        _challengeRepository.getChallengeByName("Challenge 19"),
        _challengeRepository.getChallengeByName("Challenge 20"),
        _challengeRepository.getChallengeByName("Challenge 1"),
      ]);

      for (int i = 0; i < users.length; i++) {
        await _participantRepository.addParticipant(Participant(
          userId: users[i].id!,
          challengeId: challenges[i].id!,
          totalDistance: 0.0 + i,
        ));
      }
  }

  static Future<void> _initializeRun() async {
    final users = await _userRepository.getAllUsers();
    final challenges = await _challengeRepository.getAllChallenges();

    for (var user in users) {
      for (var challenge in challenges) {
        await _participantRepository.addParticipant(Participant(
          userId: user.id!,
          challengeId: challenge.id!,
          totalDistance: 0.0,
        ));

        for (int i = 0; i < 20; i++) {
          await _runRepository.addRun(Run(
            userId: user.id!,
            challengeId: challenge.id,
            distance: 5.0 + i,
            duration: 1800 + (i * 60),
            date: DateTime.now().subtract(Duration(days: i)),
            steps: 6000 + (i * 100),
            calories: 300 + (i * 10),
            averagePace: 6.0 - (i * 0.1),
            averageSpeed: 10.0 + (i * 0.2),
            route: [
              LatLngPoint(latitude: 40.7128, longitude: -74.0060, timestamp: DateTime.now().subtract(Duration(days: i))),
              LatLngPoint(latitude: 40.7138, longitude: -74.0070, timestamp: DateTime.now().subtract(Duration(days: i)).add(Duration(minutes: 5))),
            ],
          ));
        }
      }
    }
  }
}