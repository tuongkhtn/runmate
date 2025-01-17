import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:runmate/models/challenge.dart';
import 'package:runmate/repositories/challenge_repository.dart';
import 'package:runmate/repositories/invitation_repository.dart';
import 'package:runmate/repositories/participant_repository.dart';
import 'package:runmate/repositories/run_repository.dart';
import 'package:runmate/repositories/user_repository.dart';

import 'enums/challenge_status_enum.dart';
import 'enums/challenge_type_enum.dart';
import 'enums/invitation_status_enum.dart';
import 'firebase_options.dart';
import 'models/invitation.dart';
import 'models/participant.dart';
import 'models/run.dart';
import 'models/user.dart';

class InitializeFirebase {
  static final UserRepository _userRepository = UserRepository();
  static final ChallengeRepository _challengeRepository = ChallengeRepository();
  static final ParticipantRepository _participantRepository = ParticipantRepository();
  static final RunRepository _runRepository = RunRepository();
  static final InvitationRepository _invitationRepository = InvitationRepository();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    await _initializeUsers();
    await _initializeChallenges();
    await _initializeParticipants();
    await _initializeRuns();
    await _initializeInvitations();
  }

  static Future<void> _initializeUsers() async {
    _userRepository.createUser(User(
      name: "Admin",
      email: "admin@gmail.com",
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
  }

  static Future<void> _initializeChallenges() async {
    _challengeRepository.createChallenge(Challenge(
      ownerId: (await _userRepository.getUserByEmail("admin@gmail.com")).id!,
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
      ownerId: (await _userRepository.getUserByEmail("admin@gmail.com")).id!,
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
      ownerId: (await _userRepository.getUserByEmail("bobjohnson@gmail.com")).id!,
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
      ownerId: (await _userRepository.getUserByEmail("charliebrown@gmail.com")).id!,
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
      ownerId: (await _userRepository.getUserByEmail("alicesmith@gmail.com")).id!,
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
      ownerId: (await _userRepository.getUserByEmail("janedoe@gmail.com")).id!,
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
      ownerId: (await _userRepository.getUserByEmail("admin@gmail.com")).id!,
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
      ownerId: (await _userRepository.getUserByEmail("bobjohnson@gmail.com")).id!,
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
      ownerId: (await _userRepository.getUserByEmail("admin@gmail.com")).id!,
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
      ownerId: (await _userRepository.getUserByEmail("admin@gmail.com")).id!,
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
      ownerId: (await _userRepository.getUserByEmail("janedoe@gmail.com")).id!,
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
      ownerId: (await _userRepository.getUserByEmail("alicesmith@gmail.com")).id!,
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

  static Future<void> _initializeParticipants() async {
    final users = await Future.wait([
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("janedoe@gmail.com"),
      _userRepository.getUserByEmail("alicesmith@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
      _userRepository.getUserByEmail("charliebrown@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("janedoe@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
      _userRepository.getUserByEmail("janedoe@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("alicesmith@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("charliebrown@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
      _userRepository.getUserByEmail("charliebrown@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
      _userRepository.getUserByEmail("charliebrown@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("charliebrown@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("charliebrown@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("alicesmith@gmail.com"),
      _userRepository.getUserByEmail("charliebrown@gmail.com"),
      _userRepository.getUserByEmail("admin@gmail.com"),
      _userRepository.getUserByEmail("bobjohnson@gmail.com"),
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

  static Future<void> _initializeRuns() async {
    final users = await _userRepository.getAllUsers();
    final challenges = await _challengeRepository.getAllChallenges();
    final now = DateTime(2025, 1, 17); // Current date from context

    for (var user in users) {
      for (var challenge in challenges) {
        await _participantRepository.addParticipant(Participant(
          userId: user.id!,
          challengeId: challenge.id!,
          totalDistance: 0.0,
        ));

        // Create 3 runs within the last 2 weeks
        for (int i = 0; i < 3; i++) {
          // Distribute runs across the last 14 days
          final daysAgo = (i * 4) + (user.hashCode % 3); // Distribute runs evenly, with some variation per user
          final runDate = now.subtract(Duration(days: daysAgo));
          final runTime = DateTime(
            runDate.year,
            runDate.month,
            runDate.day,
            8 + (user.hashCode % 12), // Distribute start times between 8 AM and 7 PM
            30 + (i * 15), // Vary minutes
          );

          await _runRepository.addRun(Run(
            userId: user.id!,
            challengeId: challenge.id,
            distance: 5.0 + i,
            duration: 1800 + (i * 60), // 30 minutes + additional minutes per run
            date: runTime,
            steps: 6000 + (i * 100),
            calories: 300 + (i * 10),
            averagePace: 6.0 - (i * 0.1),
            averageSpeed: 10.0 + (i * 0.2),
            route: [
              LatLngPoint(
                  latitude: 40.7128,
                  longitude: -74.0060,
                  timestamp: runTime
              ),
              LatLngPoint(
                  latitude: 40.7138,
                  longitude: -74.0070,
                  timestamp: runTime.add(Duration(minutes: 5))
              ),
            ],
          ));
        }
      }
    }
  }

  static Future<void> _initializeInvitations() async {
    final invitations = [
      // Challenge 1 invitations
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 1")).id!,
        email: "alicesmith@gmail.com",
        status: InvitationStatusEnum.pending,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 1")).id!,
        email: "bobjohnson@gmail.com",
        status: InvitationStatusEnum.accepted,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 1")).id!,
        email: "charliebrown@gmail.com",
        status: InvitationStatusEnum.declined,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 1")).id!,
        email: "admin@gmail.com",
        status: InvitationStatusEnum.accepted,
      ),
      // Challenge 2 invitations
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 2")).id!,
        email: "janedoe@gmail.com",
        status: InvitationStatusEnum.pending,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 2")).id!,
        email: "bobjohnson@gmail.com",
        status: InvitationStatusEnum.accepted,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 2")).id!,
        email: "admin@gmail.com",
        status: InvitationStatusEnum.pending,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 2")).id!,
        email: "charliebrown@gmail.com",
        status: InvitationStatusEnum.declined,
      ),
      // Challenge 3 invitations
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 3")).id!,
        email: "charliebrown@gmail.com",
        status: InvitationStatusEnum.pending,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 3")).id!,
        email: "janedoe@gmail.com",
        status: InvitationStatusEnum.accepted,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 3")).id!,
        email: "bobjohnson@gmail.com",
        status: InvitationStatusEnum.declined,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 3")).id!,
        email: "admin@gmail.com",
        status: InvitationStatusEnum.accepted,
      ),
      // Admin user additional invitations
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 1")).id!,
        email: "admin@gmail.com",
        status: InvitationStatusEnum.pending,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 2")).id!,
        email: "admin@gmail.com",
        status: InvitationStatusEnum.declined,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 3")).id!,
        email: "admin@gmail.com",
        status: InvitationStatusEnum.accepted,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 1")).id!,
        email: "janedoe@gmail.com",
        status: InvitationStatusEnum.accepted,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 2")).id!,
        email: "bobjohnson@gmail.com",
        status: InvitationStatusEnum.pending,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 3")).id!,
        email: "alicesmith@gmail.com",
        status: InvitationStatusEnum.declined,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 2")).id!,
        email: "charliebrown@gmail.com",
        status: InvitationStatusEnum.pending,
      ),
      Invitation(
        challengeId: (await _challengeRepository.getChallengeByName("Challenge 3")).id!,
        email: "janedoe@gmail.com",
        status: InvitationStatusEnum.accepted,
      ),
    ];

    for (var invitation in invitations) {
      await _invitationRepository.createInvitation(invitation);
    }
  }
}