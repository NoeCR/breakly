import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../interfaces/notification_service.dart';
import '../constants/app_constants.dart';

class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize() async {
    try {
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit);
      await _notifications.initialize(initSettings);
      tz.initializeTimeZones();

      // Create notification channel for better compatibility
      await _createNotificationChannel();

      // Request permissions for Android 13+
      await _requestPermissions();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _createNotificationChannel() async {
    try {
      final androidImplementation =
          _notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        const channel = AndroidNotificationChannel(
          AppConstants.notificationChannelId,
          AppConstants.notificationChannelName,
          description: AppConstants.notificationChannelDescription,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );

        await androidImplementation.createNotificationChannel(channel);
      }
    } catch (e) {}
  }

  Future<void> _requestPermissions() async {
    try {
      final androidImplementation =
          _notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        // Request basic notification permission
        await androidImplementation.requestNotificationsPermission();
      }
    } catch (e) {
      // Handle error silently
    }
  }

  /// Verifica si las alarmas exactas están permitidas y guía al usuario si no
  Future<bool> checkExactAlarmsPermission() async {
    try {
      final androidImplementation =
          _notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        final canScheduleExactAlarms =
            await androidImplementation.canScheduleExactNotifications();

        return canScheduleExactAlarms == true;
      }
    } catch (e) {}

    return false;
  }

  /// Verifica si las notificaciones están habilitadas en el sistema
  Future<bool> areNotificationsEnabled() async {
    try {
      final androidImplementation =
          _notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        final areEnabled =
            await androidImplementation.areNotificationsEnabled();

        return areEnabled == true;
      }
    } catch (e) {}

    return false;
  }

  /// Verifica si hay notificaciones pendientes
  Future<void> checkPendingNotifications() async {
    try {
      await _notifications.pendingNotificationRequests();
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Future<void> scheduleEndNotification(int minutes) async {
    try {
      final now = DateTime.now();
      final scheduled = now.add(Duration(minutes: minutes));
      final tzScheduled = tz.TZDateTime.from(scheduled, tz.local);

      // Si es una notificación inmediata (0 minutos), usar show
      if (minutes == 0) {
        await _notifications.show(
          1001,
          'Tiempo cumplido',
          'Has completado la sesión de trabajo',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              AppConstants.notificationChannelId,
              AppConstants.notificationChannelName,
              importance: Importance.max,
              priority: Priority.high,
              showWhen: true,
              enableVibration: true,
              playSound: true,
              fullScreenIntent: true,
              category: AndroidNotificationCategory.alarm,
              visibility: NotificationVisibility.public,
              ongoing: false,
              autoCancel: true,
              channelShowBadge: true,
            ),
          ),
        );
      } else {
        // Para notificaciones programadas, usar modo inexacto (más simple)
        await _notifications.zonedSchedule(
          1001,
          'Tiempo cumplido',
          'Has completado $minutes minutos en modo sin interrupciones',
          tzScheduled,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              AppConstants.notificationChannelId,
              AppConstants.notificationChannelName,
              importance: Importance.max,
              priority: Priority.high,
              showWhen: true,
              enableVibration: true,
              playSound: true,
              fullScreenIntent: true,
              category: AndroidNotificationCategory.alarm,
              visibility: NotificationVisibility.public,
              ongoing: false,
              autoCancel: true,
              channelShowBadge: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: null,
        );
      }
    } catch (e) {
      // Handle error silently - no interrumpir la funcionalidad principal
    }
  }

  @override
  Future<void> cancelEndNotification() async {
    try {
      await _notifications.cancel(1001);
    } catch (e) {
      // Handle error silently - no interrumpir la funcionalidad principal
    }
  }
}
