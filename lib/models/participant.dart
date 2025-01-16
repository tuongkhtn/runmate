class Participant {
  String? id;
  final String userId;
  final String? challengeId;
  final double totalDistance;
  final DateTime createdAt;

  Participant({
    required this.userId,
    this.challengeId,
    required this.totalDistance,
    DateTime? createdAt ,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      userId: json['userId'] as String,
      challengeId: json['challengeId'] as String,
      totalDistance: (json['totalDistance'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'challengeId': challengeId,
      'totalDistance': totalDistance,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}