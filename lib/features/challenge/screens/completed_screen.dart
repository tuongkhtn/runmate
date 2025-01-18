import 'package:flutter/material.dart';
import 'package:runmate/common/utils/constants.dart';
import 'package:runmate/common/utils/date_formatter.dart';
import 'package:runmate/features/challenge/screens/completed_detail_screen.dart';
import 'package:runmate/repositories/participant_repository.dart';

import '../../../common/providers/user_id_provider.dart';
import '../../../enums/challenge_status_enum.dart';
import '../../../models/challenge.dart';

class CompletedList extends StatefulWidget {
  const CompletedList({super.key});

  @override
  State<CompletedList> createState() => _CompletedListState();
}

class _CompletedListState extends State<CompletedList> {
  final ParticipantRepository _participantRepository = ParticipantRepository();
  final String _userId = UserIdProvider().userId;
  bool _isLoading = true;
  List<Challenge> _challenges = []; // Danh sách challenge

  @override
  void initState() {
    super.initState();
    _fetchChallenges();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
        backgroundColor: kSecondaryColor,
      );
    }

    if (_challenges.isEmpty) {
      return Container(
        color: kSecondaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Biểu tượng
              Icon(
                Icons.sentiment_dissatisfied_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              // Dòng thông báo
              Text(
                'No challenges completed yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.6,
          children: _challenges.map((challenge) {
            return _buildChallengeCard(challenge);
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _fetchChallenges() async {
    try {
      // Gọi hàm từ UserRepository
      final challenges = await _participantRepository.getChallengesByStatusAndUserId(
          ChallengeStatusEnum.completed,
          _userId
      );
      setState(() {
        _challenges = challenges;
        _isLoading = false;
      });
    } catch (e) {
      // Hiển thị lỗi nếu xảy ra
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching challenges: $e')),
      );
    }
  }

  Widget _buildChallengeCard(Challenge challenge) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.directions_run, size: 24, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                challenge.description,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                formatDateRange(challenge.startDate, challenge.endDate),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompletedDetailScreen(challenge: challenge),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
              child: const Text('Detail',),
            ),
          ),
        ],
      ),
    );
  }
}