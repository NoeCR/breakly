import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import '../interfaces/notification_service.dart';

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

      if (kDebugMode) {
        print('✅ Notifications initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize notifications: $e');
      }
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
          'breakly_session',
          'Fin de sesión',
          description: 'Notificaciones de finalización de sesión de trabajo',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );

        await androidImplementation.createNotificationChannel(channel);

        if (kDebugMode) {
          print('📱 Notification channel created successfully');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to create notification channel: $e');
      }
    }
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

        if (kDebugMode) {
          print('🔍 Exact alarms permission status: $canScheduleExactAlarms');
        }

        return canScheduleExactAlarms == true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking exact alarms permission: $e');
      }
    }

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

        if (kDebugMode) {
          print('🔔 Notifications enabled status: $areEnabled');
        }

        return areEnabled == true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking notifications enabled status: $e');
      }
    }

    return false;
  }

  /// Verifica si hay notificaciones pendientes
  Future<void> checkPendingNotifications() async {
    try {
      final pendingNotifications =
          await _notifications.pendingNotificationRequests();

      if (kDebugMode) {
        print('📋 Pending notifications count: ${pendingNotifications.length}');
        for (final notification in pendingNotifications) {
          print(
            '📋 Pending notification ID: ${notification.id}, Title: ${notification.title}',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking pending notifications: $e');
      }
    }
  }

  @override
  Future<void> scheduleEndNotification(int minutes) async {
    try {
      final now = DateTime.now();
      final scheduled = now.add(Duration(minutes: minutes));
      final tzScheduled = tz.TZDateTime.from(scheduled, tz.local);

      if (kDebugMode) {
        print(
          '📅 Scheduling notification for ${scheduled.toString()} (in $minutes minutes)',
        );
        print('🕐 Current time: ${now.toString()}');
        print('⏰ Scheduled time: ${scheduled.toString()}');
      }

      // Si es una notificación inmediata (0 minutos), usar show
      if (minutes == 0) {
        await _notifications.show(
          1001,
          'Tiempo cumplido',
          'Has completado la sesión de trabajo',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'breakly_session',
              'Fin de sesión',
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
              'breakly_session',
              'Fin de sesión',
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
      if (kDebugMode) {
        print('❌ Failed to schedule notification: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> cancelEndNotification() async {
    try {
      await _notifications.cancel(1001);
      if (kDebugMode) {
        print('🗑️ Notification cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to cancel notification: $e');
      }
      rethrow;
    }
  }
}
