import 'package:flutter/material.dart';
import 'package:runmate/common/utils/constants.dart';
import 'package:runmate/common/utils/date_formatter.dart';
import 'package:runmate/repositories/participant_repository.dart';

import '../../../common/providers/user_id_provider.dart';
import '../../../enums/challenge_status_enum.dart';
import '../../../models/challenge.dart';

class RecommendedList extends StatefulWidget {
  const RecommendedList({super.key});

  @override
  State<RecommendedList> createState() => _RecommendedListState();
}

class _RecommendedListState extends State<RecommendedList> {
  final ParticipantRepository _participantRepository = ParticipantRepository();
  final String _userId = UserIdProvider().userId;
  bool _isLoading = false;
  List<Challenge> _challenges = []; // Danh sách challenge

  @override
  void initState() {
    super.initState();
    _fetchChallenges();
  }

  Future<void> _fetchChallenges() async {
    try {
      // Gọi hàm từ UserRepository
      final challenges = await _participantRepository.getRecommendedChallengesByUserId(
          _userId
      );
      setState(() {
        _challenges = challenges;
        _isLoading = false;
      });
    } catch (e) {

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
        color: kSecondaryColor, // Đặt màu nền (thay bằng màu bạn muốn)
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Biểu tượng
              Icon(
                Icons.hourglass_empty_outlined, // Biểu tượng hộp trống
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              // Dòng thông báo
              const Text(
                "No challenges have been recommended for you",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const Text(
                "Please check back later",
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
      backgroundColor: kSecondaryColor, // Màu nền của toàn bộ body
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
              onPressed: () {},
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
              child: const Text('Join',),
            ),
          ),
        ],
      ),
    );
  }
}