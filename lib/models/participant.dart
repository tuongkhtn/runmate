class Participant {
  final String? participantId;
  final String userId;
  final String status;
  final double totalDistance;
  final DateTime createdAt;

  Participant({
    this.participantId,
    required this.userId,
    required this.status,
    required this.totalDistance,
    DateTime? createdAt ,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      participantId: json['participantId'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
      totalDistance: (json['totalDistance'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantId': participantId,
      'userId': userId,
      'status': status,
      'totalDistance': totalDistance,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}