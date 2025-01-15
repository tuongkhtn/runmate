class Challenge {
  String? id;
  final String ownerId;
  final String name;
  final String description;
  final String longDescription;
  final DateTime startDate;
  final DateTime endDate;
  final double goalDistance;
  final int totalNumberOfParticipants;
  final DateTime createdAt;

  Challenge({
    required this.ownerId,
    required this.name,
    this.description = "",
    this.longDescription = "",
    required this.startDate,
    required this.endDate,
    required this.goalDistance,
    this.totalNumberOfParticipants = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      longDescription: json['longDescription'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      goalDistance: (json['goalDistance'] as num).toDouble(),
      totalNumberOfParticipants: json['totalNumberOfParticipants'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'longDescription': longDescription,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'goalDistance': goalDistance,
      'totalNumberOfParticipants': totalNumberOfParticipants,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}