import 'package:runmate/enums/invitation_status_enum.dart';

class Invitation {
  String? id;
  final String challengeId;
  final String email;
  final InvitationStatusEnum status;
  final DateTime sentAt;

  Invitation({
    required this.challengeId,
    required this.email,
    required this.status,
    DateTime? sentAt,
  }) : sentAt = sentAt ?? DateTime.now();

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      challengeId: json['challengeId'] as String,
      email: json['email'] as String,
      status: InvitationStatusEnum.values.firstWhere((e) => e.toString() == "InvitationStatusEnum.${json['status']}"),
      sentAt: DateTime.parse(json['sentAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challengeId': challengeId,
      'email': email,
      'status': status.toString().split('.').last,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}