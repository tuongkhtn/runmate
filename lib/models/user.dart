class User {
  final String? userId;
  final String name;
  final String email;
  final String avatarUrl;
  final double totalDistance;
  final int totalTime;
  final DateTime createdAt;

  User({
    this.userId,
    required this.name,
    required this.email,
    this.avatarUrl = "",
    this.totalDistance = 0.0 ,
    this.totalTime = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String,
      totalDistance: (json['totalDistance'] as num).toDouble(),
      totalTime: json['totalTime'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'totalDistance': totalDistance,
      'totalTime': totalTime,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}