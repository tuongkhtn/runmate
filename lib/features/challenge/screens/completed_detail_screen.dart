import 'package:flutter/material.dart';
import 'package:runmate/common/providers/user_id_provider.dart';
import 'package:runmate/common/utils/date_formatter.dart';
import 'package:runmate/models/participant.dart';
import 'package:runmate/repositories/participant_repository.dart';
import 'package:runmate/repositories/user_repository.dart';
import '../../../common/utils/constants.dart';
import '../../../models/challenge.dart';
import '../../../models/user.dart';

class CompletedDetailScreen extends StatefulWidget {
  final Challenge challenge;

  const CompletedDetailScreen({super.key, required this.challenge});

  @override
  State<CompletedDetailScreen> createState() => _CompletedDetailScreenState();
}

class _CompletedDetailScreenState extends State<CompletedDetailScreen> {
  bool _isLoading = true;
  String _ownerName = "owner";
  double _totalDistance = 0;
  final UserRepository _userRepository = UserRepository();
  final ParticipantRepository _participantRepository = ParticipantRepository();
  final String _userId = UserIdProvider().userId;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      User owner = await _userRepository.getUserById(widget.challenge.ownerId);
      Participant? participant = await _participantRepository.getParticipantByChallengeIdAndUserId(widget.challenge.id.toString(), _userId);
      _ownerName = owner.name;
      _totalDistance = participant?.totalDistance ?? 0;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
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

    final challenge = widget.challenge;

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true, // Center the title
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(challenge.name),
            backgroundColor: kPrimaryColor,
          ),
          backgroundColor: kSecondaryColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Box 1: Basic Challenge Information
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Owner Name
                      Text(
                        'Owner: $_ownerName',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      // Description
                      Text(
                        challenge.description,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 12),

                      // Start Date & End Date with calendar icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                formatDateRange(challenge.startDate, challenge.endDate),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Icon and Participants Count with running shoes icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.directions_run_outlined, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Participants: ${challenge.totalNumberOfParticipants}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Box 2: Goal Distance, Current Distance and Progress Indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Goal Distance with icon
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Goal Distance: ${challenge.goalDistance} km',
                            style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Current Distance with icon
                      Row(
                        children: [
                          const Icon(Icons.directions_walk, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Your Distance: $_totalDistance km',
                            style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Progress Indicator
                      LinearProgressIndicator(
                        value: _totalDistance / challenge.goalDistance,
                        backgroundColor: Colors.grey[800],
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Box 3: Long Description
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    challenge.longDescription,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  int calculateDaysLeft(DateTime endDate) {
    final difference = endDate.difference(DateTime.now()).inDays;
    return difference > 0 ? difference : 0;
  }
}
