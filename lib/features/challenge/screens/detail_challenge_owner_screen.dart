// import 'package:flutter/material.dart';
// import 'package:runmate/models/challenge.dart';
// import 'package:runmate/models/participant.dart';
//
// import '../../../repositories/participant_repository.dart';
//
// class ChallengeOwnerScreen extends StatefulWidget {
//   final Challenge challenge;
//
//   const ChallengeOwnerScreen({
//     super.key,
//     required this.challenge,
//   });
//
//   @override
//   State<ChallengeOwnerScreen> createState() => _ChallengeOwnerScreenState();
// }
//
// class _ChallengeOwnerScreenState extends State<ChallengeOwnerScreen> {
//   final ParticipantRepository _participantRepository = ParticipantRepository();
//
//   late List<Participant> topRunners = [];
//   late List<Participant> participants = [];
//   bool isLoading = true; // Trạng thái tải dữ liệu
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }
//
//   Future<void> _initializeData() async {
//     try {
//       // Gọi API và lấy dữ liệu
//       final top3 = await _participantRepository.getTop3ParticipantsByTotalDistance(widget.challenge.id!);
//       final allParticipants = await _participantRepository.getParticipantsByChallengeId(widget.challenge.id!);
//
//       // Cập nhật dữ liệu và giao diện
//       setState(() {
//         topRunners = top3;
//         participants = allParticipants;
//         isLoading = false;
//       });
//     } catch (error) {
//       // Xử lý lỗi (ví dụ: hiển thị thông báo)
//       setState(() {
//         isLoading = false;
//       });
//       print('Error loading data: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator()) // Hiển thị spinner khi đang tải
//             : Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Ảnh bìa
//             Stack(
//               children: [
//                 Container(
//                   height: 200,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/images/bg1.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 16,
//                   left: 16,
//                   child: Text(
//                     widget.challenge.name,
//                     style: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             // Thông tin chung
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.challenge.description,
//                     style: const TextStyle(fontSize: 16, color: Colors.black87),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Start Date: ${widget.challenge.startDate.toLocal()}',
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                   Text(
//                     'End Date: ${widget.challenge.endDate.toLocal()}',
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                   Text(
//                     'Goal Distance: ${widget.challenge.goalDistance.toStringAsFixed(2)} km',
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Thông tin hiện tại
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Participants: ${widget.challenge.totalNumberOfParticipants}',
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Top 3 Runners:',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   Column(
//                     children: topRunners
//                         .map((runner) => Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: Text(
//                         '${runner.name} - ${runner.totalDistance} km',
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ))
//                         .toList(),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Mời người tham gia
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       decoration: const InputDecoration(
//                         labelText: 'Invite by Name or Email',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Xử lý mời người
//                     },
//                     child: const Text('Invite'),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Danh sách đã tham gia
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Participants:',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       Column(
//                         children: participants
//                             .map((participant) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4.0),
//                           child: Text(
//                             participant.name,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ))
//                             .toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
