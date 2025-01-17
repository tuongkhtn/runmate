import 'package:flutter/material.dart';
import 'package:runmate/models/challenge.dart';
import 'package:runmate/models/participant.dart';
import 'package:runmate/repositories/challenge_repository.dart';

import '../../../common/utils/constants.dart';
import '../../../repositories/participant_repository.dart';
import '../../../repositories/user_repository.dart';

class ChallengeOwnerScreen extends StatefulWidget {
  final String challengeId;

  const ChallengeOwnerScreen({
    super.key,
    required this.challengeId,
  });

  @override
  State<ChallengeOwnerScreen> createState() => _ChallengeOwnerScreenState();
}

class _ChallengeOwnerScreenState extends State<ChallengeOwnerScreen> {
  final ParticipantRepository _participantRepository = ParticipantRepository();
  final UserRepository _userRepository = UserRepository();
  final ChallengeRepository _challengeRepository = ChallengeRepository();
  late List<dynamic> topRunners = [];
  late List<dynamic> participants = [];
  late Challenge challenge;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      challenge =
      await _challengeRepository.getChallengeById(widget.challengeId);

      final top3 = await _participantRepository
          .getTop3ParticipantsByTotalDistance(challenge.id!);
      final allParticipants = await _participantRepository
          .getParticipantsByChallengeId(challenge.id!);

      final top3Details = await Future.wait(
          top3.map((runner) => _userRepository.getUserById(runner.userId)));
      final allParticipantsDetails = await Future.wait(allParticipants.map(
              (participant) => _userRepository.getUserById(participant.userId)));

      final top3WithUsers = List.generate(top3.length, (index) {
        return {'participant': top3[index], 'user': top3Details[index]};
      });

      final allParticipantsWithUsers =
      List.generate(allParticipants.length, (index) {
        return {
          'participant': allParticipants[index],
          'user': allParticipantsDetails[index]
        };
      });


      setState(() {
        topRunners = top3WithUsers;
        participants = allParticipantsWithUsers;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error loading data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh bìa
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bg1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      challenge.name ?? '',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              // Thông tin chung
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: kSecondaryColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge.description ?? 'No description',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Date: ${challenge.startDate?.toLocal().toString().split(' ')[0] ?? ''} - ${challenge.endDate?.toLocal().toString().split(' ')[0] ?? ''}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Goal Distance: ${challenge.goalDistance?.toStringAsFixed(2) ?? '0.00'} km',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Top 3 runners
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Top 3 Runners:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Hạng nhì
                    if (topRunners.length > 1)
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '2nd',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: kPrimaryColor,
                              child: Text(
                                topRunners[1]['user']?.name[0] ?? '',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              topRunners[1]['user']?.name ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${topRunners[1]['participant']?.totalDistance ?? 0} km',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Hạng nhất
                    if (topRunners.isNotEmpty)
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '1st',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.amber,
                              child: Text(
                                topRunners[0]['user']?.name[0] ?? '',
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              topRunners[0]['user']?.name ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${topRunners[0]['participant']?.totalDistance ?? 0} km',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Hạng ba
                    if (topRunners.length > 2)
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '3rd',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: kPrimaryColor,
                              child: Text(
                                topRunners[2]['user']?.name[0] ?? '',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              topRunners[2]['user']?.name ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${topRunners[2]['participant']?.totalDistance ?? 0} km',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Mời người tham gia
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Invite by Email',
                          labelStyle:
                          const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý mời người
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Invite'),
                    ),
                  ],
                ),
              ),

              // Danh sách đã tham gia
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Participants:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.1),
                        border: Border.all(color: kPrimaryColor, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        height: 400, // Chiều cao cố định
                        child: SingleChildScrollView(
                          child: Column(
                            children: participants.take(10).map((participant) {
                              return Card(
                                color: kSecondaryColor,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn hai đầu
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            child: Text(
                                              participant['user']?.name[0] ?? '',
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: kPrimaryColor,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            participant['user']?.name ?? '',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${participant['participant']?.totalDistance ?? 0} km',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
      backgroundColor: Colors.white24,
    );
  }
}

