import '../models/alarm_settings.dart';

abstract class PreferencesRepository {
  Future<int?> getMinutesTarget();
  Future<void> setMinutesTarget(int minutes);
  Future<int?> getActiveSessionStartedAt();
  Future<void> setActiveSessionStartedAt(int milliseconds);
  Future<void> clearActiveSessionStartedAt();

  // Configuración de alarma
  Future<AlarmSettings> getAlarmSettings();
  Future<void> setAlarmSettings(AlarmSettings alarmSettings);
}
