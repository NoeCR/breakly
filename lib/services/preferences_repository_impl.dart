import 'package:shared_preferences/shared_preferences.dart';
import '../interfaces/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  static const String _minutesTargetKey = 'minutes_target';
  static const String _activeSessionStartedAtKey = 'active_session_started_at';

  @override
  Future<int?> getMinutesTarget() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_minutesTargetKey);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> setMinutesTarget(int minutes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_minutesTargetKey, minutes);
    } catch (_) {
      // Handle error silently or log it
    }
  }

  @override
  Future<int?> getActiveSessionStartedAt() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_activeSessionStartedAtKey);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> setActiveSessionStartedAt(int milliseconds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_activeSessionStartedAtKey, milliseconds);
    } catch (_) {
      // Handle error silently or log it
    }
  }

  @override
  Future<void> clearActiveSessionStartedAt() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_activeSessionStartedAtKey);
    } catch (_) {
      // Handle error silently or log it
    }
  }
}

