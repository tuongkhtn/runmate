import 'package:flutter/material.dart';
import 'package:runmate/models/challenge.dart';
import 'package:runmate/repositories/challenge_repository.dart';
import '../../../common/utils/constants.dart';
import '../../../repositories/invitation_repository.dart';
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
  final InvitationRepository _invitationRepository = InvitationRepository();
  late List<dynamic> topRunners = [];
  late List<dynamic> participants = [];
  late List<dynamic> invitations = [];
  late Challenge challenge;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      Challenge localChallenge =
          await _challengeRepository.getChallengeById(widget.challengeId);

      setState(() {
        challenge = localChallenge;
      });

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

      final invitationList = await _invitationRepository
          .getInvitationsByChallengeId(challenge.id!);
      final invitationDetails = await Future.wait(invitationList
          .map((invite) => _userRepository.getUserByEmail(invite.email)));

      setState(() {
        topRunners = top3WithUsers;
        participants = allParticipantsWithUsers;
        isLoading = false;
        invitations = invitationDetails;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    bool isValidEmail(String email) {
      final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
      return emailRegex.hasMatch(email);
    }
    void HandleInvite()  async{

      String email = emailController.text.trim();

      if (email.isNotEmpty && isValidEmail(email)) {
        _invitationRepository.createInvitationWithEmail(challenge.id!, email).then((success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invitation sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
                }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: Colors.red,
            ),
          );
        });
        final invitationList = await _invitationRepository
            .getInvitationsByChallengeId(challenge.id!);
        final invitationDetails = await Future.wait(invitationList
            .map((invite) => _userRepository.getUserByEmail(invite.email)));
        setState(() {
          invitations = invitationDetails;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid email address.'),
            backgroundColor: Colors.orange,
          ),
        );
      }


    }

    Future<void> deleteInvitation(String email) async {
      try {
        // Gọi API hoặc phương thức xóa theo email
         await _invitationRepository.deleteInvitationsByChallengeIdEmail(challenge.id!, email);
        // Thông báo xóa thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invitation to $email deleted')),
        );
         final invitationList = await _invitationRepository
             .getInvitationsByChallengeId(challenge.id!);
         final invitationDetails = await Future.wait(invitationList
             .map((invite) => _userRepository.getUserByEmail(invite.email)));
         setState(() {
           invitations = invitationDetails;
         });
      } catch (e) {
        // Thông báo lỗi khi xóa
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting invitation: $e')),
        );
      }
    }

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
                            challenge.name,
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.description, color: kPrimaryColor),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        challenge.longDescription,
                                        style: const TextStyle(fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, color: kPrimaryColor),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Date: ${challenge.startDate.toLocal().toString().split(' ')[0]} - ${challenge.endDate.toLocal().toString().split(' ')[0]}',
                                        style: const TextStyle(fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Icon(Icons.directions_run, color: kPrimaryColor),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Goal Distance: ${challenge.goalDistance.toStringAsFixed(2)} km',
                                        style: const TextStyle(fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                  ],
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(16), // Bo góc
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Hạng nhì
                              if (topRunners.length > 1)
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Text(
                                        '2nd',
                                        style: TextStyle(
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
                                      const Text(
                                        '1st',
                                        style: TextStyle(
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
                                      const Text(
                                        '3rd',
                                        style: TextStyle(
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
                      ),
                    ),


                    // Mời người tham gia
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: emailController,
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
                              HandleInvite();
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

                    // Danh sach moi nguoi duoc moi
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Invitated:',
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
                        children: invitations.map((invite) {
                          return Dismissible(
                            key: Key(invite.email), // Sử dụng email làm key
                            direction: DismissDirection.endToStart, // Chỉ cho phép kéo từ phải sang trái
                            onDismissed: (direction) async {
                              // Hiển thị modal xác nhận trước khi xóa
                              bool? shouldDelete = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Deletion'),
                                    content: const Text('Are you sure you want to delete this invitation?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false); // Nếu không xóa
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true); // Nếu xóa
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (shouldDelete == true) {
                                // Gọi hàm xử lý xóa nếu người dùng xác nhận
                                await deleteInvitation(invite.id);
                              } else {
                                // Khôi phục lại thẻ nếu người dùng không xóa
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Deletion cancelled')),
                                );
                              }
                            },
                            background: Container(
                              color: Colors.red, // Màu nền khi kéo
                              alignment: Alignment.centerRight,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 20.0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                            child: Card(
                              color: kSecondaryColor,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: kPrimaryColor,
                                          child: Text(
                                            invite.name[0],
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              invite.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              invite.email,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
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
                              border:
                                  Border.all(color: kPrimaryColor, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SizedBox(
                              height: 400, // Chiều cao cố định
                              child: SingleChildScrollView(
                                child: Column(
                                  children:
                                      participants.take(10).map((participant) {
                                    return Card(
                                      color: kSecondaryColor,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween, // Căn hai đầu
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  child: Text(
                                                    participant['user']
                                                            ?.name[0] ??
                                                        '',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  participant['user']?.name ??
                                                      '',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
