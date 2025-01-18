import 'package:flutter/material.dart';
import 'package:runmate/common/providers/user_id_provider.dart';
import 'package:runmate/common/utils/constants.dart';
import 'package:runmate/repositories/participant_repository.dart';
import 'package:runmate/models/challenge.dart';
import 'package:runmate/common/utils/date_formatter.dart';

import '../../../enums/challenge_status_enum.dart';
import 'ongoing_detail_screen.dart'; // Import model Challenge

class OngoingList extends StatefulWidget {
  const OngoingList({super.key});

  @override
  State<OngoingList> createState() => _OngoingListState();
}

class _OngoingListState extends State<OngoingList> {
  final ParticipantRepository _participantRepository = ParticipantRepository();
  final String _userId = UserIdProvider().userId;
  bool _isLoading = true; // Trạng thái loading
  List<Challenge> _challenges = []; // Danh sách challenge

  @override
  void initState() {
    super.initState();
    _fetchChallenges();
  }

  Future<void> _fetchChallenges() async {
    try {
      // Gọi hàm từ UserRepository
      final challenges = await _participantRepository.getChallengesByStatusAndUserId(
        ChallengeStatusEnum.ongoing, // Thay bằng trạng thái phù hợp
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
                Icons.emoji_people,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              // Dòng thông báo
              const Text(
                'No challenges on-going now. Let\'s join some!',
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
          crossAxisCount: 2, // Hiển thị 2 cột
          crossAxisSpacing: 16, // Khoảng cách giữa các cột
          mainAxisSpacing: 16, // Khoảng cách giữa các hàng
          childAspectRatio: 0.6, // Tỷ lệ width/height của mỗi card
          children: _challenges.map((challenge) {
            return _buildChallengeCard(challenge);
          }).toList(),
        ),
      ),
    );
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
                    builder: (context) => OngoingDetailScreen(challenge: challenge),
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
