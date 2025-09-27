import '../models/alarm_settings.dart';

abstract class NotificationService {
  Future<void> initialize();
  Future<void> scheduleEndNotification(int minutes);
  Future<void> cancelEndNotification();
  Future<bool> checkExactAlarmsPermission();
  Future<bool> areNotificationsEnabled();
  Future<void> checkPendingNotifications();

  /// Verifica si la aplicación puede saltarse el modo "No molestar"
  Future<bool> canBypassDnd();

  /// Solicita permiso para saltarse el modo "No molestar"
  Future<bool> requestDndBypassPermission();

  /// Reproduce la alarma sonora cuando termina el break
  Future<void> playAlarmSound(AlarmSettings alarmSettings);

  /// Detiene la alarma sonora
  Future<void> stopAlarmSound();
}
