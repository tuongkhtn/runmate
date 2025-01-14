class UserModel {
  final String userId;
  final String name;
  final String email;
  final String avatarUrl;
  final double totalDistance;
  final int totalTime;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.totalDistance,
    required this.totalTime,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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

  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? avatarUrl,
    double? totalDistance,
    int? totalTime,
    DateTime? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalDistance: totalDistance ?? this.totalDistance,
      totalTime: totalTime ?? this.totalTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
