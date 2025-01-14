class RunStats {
  final int totalRuns;
  final double totalDistance;
  final Duration totalDuration;
  final double totalCalories;
  final int totalSteps;

  RunStats({
    required this.totalRuns,
    required this.totalDistance,
    required this.totalDuration,
    required this.totalCalories,
    required this.totalSteps,
  });

  factory RunStats.empty() {
    return RunStats(
      totalRuns: 0,
      totalDistance: 0,
      totalDuration: Duration.zero,
      totalCalories: 0,
      totalSteps: 0,
    );
  }

  double get averageDistance => totalRuns == 0 ? 0 : totalDistance / totalRuns;
  double get averageCalories => totalRuns == 0 ? 0 : totalCalories / totalRuns;
  int get averageSteps => totalRuns == 0 ? 0 : totalSteps ~/ totalRuns;
}