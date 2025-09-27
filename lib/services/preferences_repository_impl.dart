import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../interfaces/preferences_repository.dart';
import '../models/alarm_settings.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  static const String _minutesTargetKey = 'minutes_target';
  static const String _activeSessionStartedAtKey = 'active_session_started_at';
  static const String _alarmSettingsKey = 'alarm_settings';

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

  @override
  Future<AlarmSettings> getAlarmSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_alarmSettingsKey);

      if (settingsJson != null) {
        final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
        return AlarmSettings.fromJson(settingsMap);
      }

      // Retornar configuración por defecto si no existe
      return const AlarmSettings();
    } catch (_) {
      // Retornar configuración por defecto en caso de error
      return const AlarmSettings();
    }
  }

  @override
  Future<void> setAlarmSettings(AlarmSettings alarmSettings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(alarmSettings.toJson());
      await prefs.setString(_alarmSettingsKey, settingsJson);
    } catch (_) {
      // Handle error silently or log it
    }
  }
}
