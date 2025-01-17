// lib/screens/run_screen.dart
import 'dart:math';
import 'dart:async';
import "../../../common/utils/constants.dart";
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../services/location_service.dart';
// import '../services/streak_service.dart';
// import '../services/run_storage_service.dart';
import '../widgets/run_card.dart';
import '../../../models/user.dart';
import '../../../models/user.dart';
import 'package:runmate/repositories/user_repository.dart';
import 'package:runmate/models/run.dart';
import 'package:runmate/repositories/run_repository.dart';



class RunScreen extends StatefulWidget {
  const RunScreen({super.key});

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  final LocationService _locationService = LocationService();
  // final StreakService _streakService = StreakService();
  // final RunStorageService _runStorageService = RunStorageService();
  GoogleMapController? _mapController;
  final String userID = 'EkVYecoAlIP7gjJHItCdVuYORrl2';
  // final UserRepository _userRepository = UserRepository();
  // final RunRepository _runRepository = RunRepository();
  User ?_user;

  int _streak = 0;
  bool _isLoading = true;
  Run? _lastRun;
  bool _isRunning = false;
  List<LatLngPoint> _currentRoute = [];
  DateTime? _startTime;
  int _currentSteps = 0;
  Timer? _timer;


  // Step detection variables
  double _lastMagnitude = 0;
  bool _stepCounterActive = false;
  static const double _stepThreshold = 12.0; // Adjust based on testing
  static const double _stepResetThreshold = 8.0;
  DateTime? _lastStepTime;
  static const minStepInterval = Duration(
      milliseconds: 200); // Minimum time between steps

  @override
  void initState() {
    super.initState();
    _initializeServices();

  }

  Future<void> _initializeServices() async {
    final hasPermission = await _locationService.checkPermissions();
    if (!hasPermission) {
      // Handle permission denied
      return;
    }

    // final streak = await _runRepository.getStreakByUserID(userID);
    // final lastRun = await _runRepository.getRunLatestByUserId(userID);
    // final user = await _userRepository.getUserById(userID);


    setState(() {
      _streak = streak;
      _lastRun = lastRun;
      _isLoading = false;
      _user = user;
    });

    // Initialize step detection
    accelerometerEventStream().listen((AccelerometerEvent event) {
      if (_isRunning) {
        _processAccelerometerData(event);
      }
    });


    _locationService.getLocationStream().listen((position) {
      print("position: $position"); // Debug print
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );

        if (_isRunning) {
          setState(() {
            _currentRoute.add(LatLngPoint(
              latitude: position.latitude,
              longitude: position.longitude,
              timestamp: DateTime.now(),
            ));
          });
        }
      }
    });
  }

  void _startRun() async {
    Position currentPosition = await _locationService.getCurrentLocation();
    setState(() {
      _isRunning = true;
      _startTime = DateTime.now();
      _currentRoute = [new LatLngPoint(
        latitude: currentPosition.latitude,
        longitude:  currentPosition.longitude,
        timestamp: DateTime.now(),
      )];
      _currentSteps = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {}); // This will rebuild the UI every second
    });
  }

  Future<void> _stopRun() async {
    if (_startTime == null) return;

    final duration = DateTime.now().difference(_startTime!);
    final distance = _calculateDistance(_currentRoute); // Implement this method
    final calories = _calculateCalories(
        duration.inMinutes, distance); // Implement this method

    print("duration: ${duration.inMicroseconds}"); // Debug print
    final newRun = new Run(
      userId: userID,
      challengeId: null,
      date: _startTime!,
      duration: duration,
      distance: distance,
      steps: _currentSteps,
      calories: calories,
      route: _currentRoute,
      averagePace: distance > 0 ? duration.inMinutes / distance : 0,
      averageSpeed: distance > 0 && duration.inMicroseconds > 0 ? distance * 3600 / duration.inSeconds  : 0,
      createdAt: DateTime.now(),
    );

    print(newRun.toJson().toString()); // Debug print
    await _runRepository.addRun(newRun);
    final newStreak = await _runRepository.getStreakByUserID(userID);


    _timer?.cancel();
    _timer = null;

    setState(() {
      _isRunning = false;
      _lastRun = newRun;
      // _streak = (duration.inMinutes > 1 && distance > 0.1) ?  _streak + 1 : _streak;
      _streak = newStreak;
    });
  }


  void _processAccelerometerData(AccelerometerEvent event) {
    // Calculate magnitude of acceleration
    double magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z
    );

    // Detect step pattern
    if (!_stepCounterActive && magnitude > _stepThreshold) {
      _stepCounterActive = true;
      DateTime now = DateTime.now();
      if (_lastStepTime == null ||
          now.difference(_lastStepTime!) > minStepInterval) {
        setState(() {
          _currentSteps++;
          _lastStepTime = now;
        });
      }
    } else if (_stepCounterActive && magnitude < _stepResetThreshold) {
      _stepCounterActive = false;
    }

    _lastMagnitude = magnitude;
  }

  double _calculateDistance(List<LatLngPoint> route) {
    print("route: $route"); // Debug print
    if (route.length < 2) return 0;

    double totalDistance = 0;
    for (int i = 0; i < route.length - 1; i++) {
      totalDistance += _calculateHaversineDistance(
        route[i].latitude,
        route[i].longitude,
        route[i + 1].latitude,
        route[i + 1].longitude,
      );
    }

    return totalDistance;
  }

  double _calculateHaversineDistance(double lat1,
      double lon1,
      double lat2,
      double lon2,) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    // Convert degrees to radians
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    lat1 = _toRadians(lat1);
    lat2 = _toRadians(lat2);

    // Haversine formula
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  double _calculateCalories(int minutes, double distance) {
    // Approximate calorie calculation based on average running MET
    const double runningMET = 7.0; // Moderate running intensity
    const double weightKg = 70.0; // Default weight, could be made configurable

    // Calories = MET × Weight (kg) × Time (hours)
    double hours = minutes / 60.0;
    double calories = runningMET * weightKg * hours;

    // Adjust calories based on distance and intensity
    double pace = (distance > 0 ) ?  minutes / distance : 0; // minutes per kilometer

    if (pace < 5) { // Fast running
      calories *= 1.2;
    } else if (pace > 8) { // Slow running/jogging
      calories *= 0.8;
    }

    return calories;
  }

  @override
  @override
  Widget build(BuildContext context)  {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (controller) => { _mapController = controller},
              style: ''' 
            [
                {
                  "elementType": "geometry",
                  "stylers": [
                    {
                      "color": "#212121"
                    }
                  ]
                },
                {
                  "elementType": "labels.icon",
                  "stylers": [
                    {
                      "visibility": "off"
                    }
                  ]
                },
                {
                  "elementType": "labels.text.fill",
                  "stylers": [
                    {
                      "color": "#757575"
                    }
                  ]
                },
                {
                  "elementType": "labels.text.stroke",
                  "stylers": [
                    {
                      "color": "#212121"
                    }
                  ]
                },
                {
                  "featureType": "administrative",
                  "elementType": "geometry",
                  "stylers": [
                    {
                      "color": "#757575"
                    }
                  ]
                },
                {
                  "featureType": "road",
                  "elementType": "geometry.fill",
                  "stylers": [
                    {
                      "color": "#2c2c2c"
                    }
                  ]
                },
                {
                  "featureType": "water",
                  "elementType": "geometry",
                  "stylers": [
                    {
                      "color": "#000000"
                    }
                  ]
                }
              ]
            ''',
              polylines: {
                if (_currentRoute.isNotEmpty)
                  Polyline(
                    polylineId: const PolylineId('route'),
                    points: _currentRoute
                        .map((point) => LatLng(point.latitude, point.longitude))
                        .toList(),
                    color: kPrimaryColor,
                    width: 5,
                  ),
              },
            ),
            Positioned(
              right: 4,
              top: MediaQuery.of(context).size.height / 2 - 20,
              child: Column(
                children: [
                  // Nút Zoom In
                  ElevatedButton(
                    onPressed: () {
                      _mapController?.animateCamera(CameraUpdate.zoomIn());
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(2),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 4),
                  // Nút Zoom Out
                  ElevatedButton(
                    onPressed: () {
                      _mapController?.animateCamera(CameraUpdate.zoomOut());
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(height: 4),
                  // Nút My Location
                  ElevatedButton(
                    onPressed: () async {
                      final position = await _locationService.getCurrentLocation();
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(position.latitude, position.longitude),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Icon(Icons.my_location),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  if (!_isRunning) ... [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack( // Use Stack to overlay the ring
                                  alignment: Alignment.centerRight, // Align the ring to the left
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        // Icon with white circular background
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: kPrimaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                              Icons.local_fire_department,
                                              color: Colors.black
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, // Add this line
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$_streak Run Streak',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: kPrimaryColor,
                                              ),
                                            ),
                                            Text(
                                              ' ${(_streak ~/ 10 + 1) * 10 - _streak} more run to ${(_streak ~/ 10 + 1) * 10} run streak',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Percentage ring
                                    SizedBox(
                                      width: 40, // Adjust size as needed
                                      height: 40,
                                      child: CustomPaint(
                                        painter: PercentageRing(
                                          target: (_streak ~/ 10 + 1) * 10 ,
                                          current: _streak,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_isRunning) ...[
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatColumn(
                              'Distance',
                              '${_calculateDistance(_currentRoute)
                                  .toStringAsFixed(2)} km',
                              Icons.straighten,
                            ),
                            _buildStatColumn(
                              'Time',
                              _formatDuration(
                                  DateTime.now().difference(_startTime!)),
                              Icons.timer,
                            ),
                            _buildStatColumn(
                              'Steps',
                              _currentSteps.toString(),
                              Icons.directions_walk,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  if (!_isRunning) RunCard(lastRun: _lastRun),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _isRunning ? _stopRun : _startRun,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: _isRunning ? Colors.red : kPrimaryColor,
                        foregroundColor:  _isRunning ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_isRunning ? Icons.stop : Icons.play_arrow),
                          const SizedBox(width: 8),
                          Text(
                            _isRunning ? 'Stop Run' : 'Tap to Start',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: kPrimaryColor ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }
}

class PercentageRing extends CustomPainter {
  final int target;
  final int current;
  final Color color;

  PercentageRing({required this.target, required this.current, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle (optional, if you want a background color)
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]! // Or any desired background color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Percentage arc
    final percentage = current / target;
    final arcAngle = 2 * pi * percentage;
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -pi / 2, // Start angle at the top
      arcAngle, // Angle of the arc based on percentage
      false,
      arcPaint,
    );

    final textSpan = TextSpan(
      text: '$current/$target',
      style: TextStyle(
        color: color,
        fontSize: size.width / 3.5, // Adjust font size as needed
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final textOffset = Offset(
      size.width / 2 - textPainter.width / 2,
      size.height / 2 - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is PercentageRing &&
        (oldDelegate.target != target || oldDelegate.current != current || oldDelegate.color != color);
  }
}