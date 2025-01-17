class RunData {
  final String id;
  final DateTime date;
  final Duration duration;
  final double distance; // in kilometers
  final int steps;
  final double calories;
  final List<LatLngPoint> route;
  final double averagePace; // minutes per kilometer
  final double averageSpeed; // kilometers per hour

  RunData({
    required this.id,
    required this.date,
    required this.duration,
    required this.distance,
    required this.steps,
    required this.calories,
    required this.route,
    required this.averagePace,
    required this.averageSpeed,
  });

  factory RunData.fromJson(Map<String, dynamic> json) {
    return RunData(
      id: json['id'],
      date: DateTime.parse(json['date']),
      duration: Duration(seconds: json['duration']),
      distance: json['distance'],
      steps: json['steps'],
      calories: json['calories'],
      route: (json['route'] as List)
          .map((point) => LatLngPoint.fromJson(point))
          .toList(),
      averagePace: json['averagePace'],
      averageSpeed: json['averageSpeed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'duration': duration.inSeconds,
      'distance': distance,
      'steps': steps,
      'calories': calories,
      'route': route.map((point) => point.toJson()).toList(),
      'averagePace': averagePace,
      'averageSpeed': averageSpeed,
    };
  }
}

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