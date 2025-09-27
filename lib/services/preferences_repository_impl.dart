import 'package:shared_preferences/shared_preferences.dart';
import '../interfaces/preferences_repository.dart';
import '../constants/app_constants.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  @override
  Future<int?> getMinutesTarget() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(AppConstants.minutesTargetKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setMinutesTarget(int minutes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.minutesTargetKey, minutes);
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Future<int?> getActiveSessionStartedAt() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(AppConstants.activeSessionStartedAtKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setActiveSessionStartedAt(int milliseconds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.activeSessionStartedAtKey, milliseconds);
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Future<void> clearActiveSessionStartedAt() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.activeSessionStartedAtKey);
    } catch (e) {
      // Handle error silently
    }
  }
}
