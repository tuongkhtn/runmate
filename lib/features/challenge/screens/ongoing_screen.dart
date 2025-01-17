import 'package:flutter/material.dart';
import 'package:runmate/common/utils/constants.dart';

class OngoingList extends StatefulWidget {
  const OngoingList({super.key});

  @override
  State<OngoingList> createState() => _OngoingListState();
}

class _OngoingListState extends State<OngoingList> {

  bool _isLoading = false;

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
          children: [
            _buildChallengeCard(
              'Challenge 1',
              'Complete a 5 km run.',
              'Jan 1 to Jan 31, 2025',
              Icons.directions_run,
            ),
            _buildChallengeCard(
              'Challenge 2',
              'Log 4 swim workouts.',
              'Jan 1 to Jan 31, 2025',
              Icons.pool,
            ),
            _buildChallengeCard(
              'Challenge 2',
              'Log 4 swim workouts.',
              'Jan 1 to Jan 31, 2025',
              Icons.pool,
            ),
            _buildChallengeCard(
              'Challenge 2',
              'Log 4 swim workouts.',
              'Jan 1 to Jan 31, 2025',
              Icons.pool,
            ),
            _buildChallengeCard(
              'Challenge 2',
              'Log 4 swim workouts.',
              'Jan 1 to Jan 31, 2025',
              Icons.pool,
            ),
            _buildChallengeCard(
              'Challenge 2',
              'Log 4 swim workouts.',
              'Jan 1 to Jan 31, 2025',
              Icons.pool,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(String title, String description, String period, IconData icon) {
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
                title,
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
                child: Icon(icon, size: 24, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                period,
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
              child: const Text('Detail',),
            ),
          ),
        ],
      ),
    );
  }
}