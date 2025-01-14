class User {
  final String userId;
  final String name;
  final String email;
  final String avatarUrl;
  final double totalDistance;
  final int totalTime;
  final DateTime createdAt;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.totalDistance,
    required this.totalTime,
    required this.createdAt,
  });

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