class LatLngPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LatLngPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory LatLngPoint.fromJson(Map<String, dynamic> json) {
    return LatLngPoint(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class Run {
  String? id;
  final String userId;
  final String? challengeId;
  final double distance;
  final int duration;
  final DateTime date;
  final int steps;
  final double calories;
  final double averagePace; // minutes per kilometer
  final double averageSpeed; // kilometers per hour
  final List<LatLngPoint> route;
  final DateTime createdAt;

  Run({
    required this.userId,
    this.challengeId,
    this.distance = 0,
    this.duration = 0,
    required this.date,
    this.steps = 0,
    this.calories = 0,
    this.averagePace = 0,
    this.averageSpeed = 0,
    this.route = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      userId: json['userId'],
      challengeId: json['challengeId'],
      distance: json['distance'],
      duration: json['duration'],
      date: DateTime.parse(json['date']),
      steps: json['steps'],
      calories: json['calories'],
      averagePace: json['averagePace'],
      averageSpeed: json['averageSpeed'],
      route: (json['route'] as List)
          .map((point) => LatLngPoint.fromJson(point))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'challengeId': challengeId,
      'distance': distance,
      'duration': duration,
      'date': date.toIso8601String(),
      'steps': steps,
      'calories': calories,
      'averagePace': averagePace,
      'averageSpeed': averageSpeed,
      'route': route.map((point) => point.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}