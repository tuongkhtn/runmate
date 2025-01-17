import 'dart:convert';
import 'package:runmate/features/let_run/models/run_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/run_data.dart';

class RunStorageService {
  static const String _runsKey = 'runs_data';
  final _uuid = const Uuid();

  // Lưu một lần chạy mới
  Future<void> saveRun(RunData run) async {
    final prefs = await SharedPreferences.getInstance();
    final runs = await getRuns();
    runs.add(run);

    final runsJson = runs.map((run) => run.toJson()).toList();
    await prefs.setString(_runsKey, jsonEncode(runsJson));
  }

  // Lấy tất cả các lần chạy
  Future<List<RunData>> getRuns() async {
    final prefs = await SharedPreferences.getInstance();
    final runsString = prefs.getString(_runsKey);

    if (runsString == null) return [];

    final runsJson = jsonDecode(runsString) as List;
    return runsJson.map((json) => RunData.fromJson(json)).toList();
  }

  // Lấy lần chạy gần nhất
  Future<RunData?> getLastRun() async {
    final runs = await getRuns();
    if (runs.isEmpty) return null;

    runs.sort((a, b) => b.date.compareTo(a.date));
    return runs.first;
  }

  // Lấy tổng thống kê
  Future<RunStats> getStats() async {
    final runs = await getRuns();
    if (runs.isEmpty) {
      return RunStats.empty();
    }

    return RunStats(
      totalRuns: runs.length,
      totalDistance: runs.fold(0.0, (sum, run) => sum + run.distance),
      totalDuration: runs.fold(
        Duration.zero,
            (sum, run) => sum + run.duration,
      ),
      totalCalories: runs.fold(0.0, (sum, run) => sum + run.calories),
      totalSteps: runs.fold(0, (sum, run) => sum + run.steps),
    );
  }

  // Xóa một lần chạy
  Future<void> deleteRun(String id) async {
    final runs = await getRuns();
    runs.removeWhere((run) => run.id == id);

    final prefs = await SharedPreferences.getInstance();
    final runsJson = runs.map((run) => run.toJson()).toList();
    await prefs.setString(_runsKey, jsonEncode(runsJson));
  }

  // Tạo ID mới cho lần chạy
  String generateRunId() {
    return _uuid.v4();
  }
}