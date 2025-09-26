abstract class NotificationService {
  Future<void> initialize();
  Future<void> scheduleEndNotification(int minutes);
  Future<void> cancelEndNotification();
  Future<bool> checkExactAlarmsPermission();
  Future<bool> areNotificationsEnabled();
  Future<void> checkPendingNotifications();
}
