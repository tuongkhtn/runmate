class User {
  String? id; // ID từ Firebase Authentication
  final String name;
  final String email;
  final String avatarUrl;
  final double totalDistance;
  final int totalTime;
  final String phoneNumber;
  final String address;
  final DateTime dateOfBirth;
  final DateTime createdAt;

  User({
    this.id, // Gán id nếu có
    required this.name,
    required this.email,
    this.avatarUrl = "",
    this.totalDistance = 0.0,
    this.totalTime = 0,
    this.phoneNumber = "",
    this.address = "",
    DateTime? dateOfBirth,
    DateTime? createdAt,
  })  : dateOfBirth = dateOfBirth ?? DateTime(2000, 1, 1),
        createdAt = createdAt ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json, {String? id}) {
    return User(
      id: id, // ID có thể được truyền từ bên ngoài
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String,
      totalDistance: (json['totalDistance'] as num).toDouble(),
      totalTime: json['totalTime'] as int,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'totalDistance': totalDistance,
      'totalTime': totalTime,
      'phoneNumber': phoneNumber,
      'address': address,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
