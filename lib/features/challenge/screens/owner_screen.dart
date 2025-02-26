import 'package:flutter/material.dart';
import 'package:runmate/common/providers/user_id_provider.dart';
import 'package:runmate/common/utils/constants.dart';
import 'package:runmate/common/utils/date_formatter.dart';
import 'package:runmate/features/challenge/screens/detail_challenge_owner_screen.dart';
import 'package:runmate/repositories/challenge_repository.dart';

import '../../../models/challenge.dart';

class OwnerList extends StatefulWidget {
  const OwnerList({super.key});

  @override
  State<OwnerList> createState() => _OwnerListState();
}

class _OwnerListState extends State<OwnerList> {
  final ChallengeRepository _challengeRepository = ChallengeRepository();
  final String _userId =UserIdProvider().userId;
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
      final challenges =
                  await _challengeRepository.getChallengesByOwnerId(ownerId: _userId);
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChallengeOwnerScreen(challengeId: challenge.id.toString()),
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
              child: const Text('Manage')
            ),
          ),
        ],
      ),
    );
  }
}