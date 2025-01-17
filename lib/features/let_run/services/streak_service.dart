import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _lastRunKey = 'last_run_date';
  static const String _streakKey = 'current_streak';

  Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRunDate = prefs.getString(_lastRunKey);
    final currentDate = DateTime.now();

    if (lastRunDate != null) {
      final lastRun = DateTime.parse(lastRunDate);
      final difference = currentDate.difference(lastRun).inDays;

      if (difference == 1) {
        final currentStreak = prefs.getInt(_streakKey) ?? 0;
        await prefs.setInt(_streakKey, currentStreak + 1);
      } else if (difference > 1) {
        await prefs.setInt(_streakKey, 1);
      }
    } else {
      await prefs.setInt(_streakKey, 1);
    }

    await prefs.setString(_lastRunKey, currentDate.toIso8601String());
  }
}