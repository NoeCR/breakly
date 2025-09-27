import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import '../interfaces/notification_service.dart';
import '../models/alarm_settings.dart';
import 'alarm_sound_service.dart';

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

      // Create notification channels for better compatibility
      await _createNotificationChannel();
      await _createAlarmChannel();

      // Request permissions for Android 13+
      await _requestPermissions();

      // Request DND bypass permissions
      await _requestDndBypassPermissions();

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

  Future<void> _createAlarmChannel() async {
    try {
      final androidImplementation =
          _notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        const channel = AndroidNotificationChannel(
          'breakly_alarm',
          'Alarma de Break',
          description: 'Notificaciones de alarma para finalización de sesión',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );

        await androidImplementation.createNotificationChannel(channel);

        if (kDebugMode) {
          print(
            '📱 Alarm notification channel created successfully with DND bypass',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to create alarm notification channel: $e');
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

  Future<void> _requestDndBypassPermissions() async {
    try {
      if (kDebugMode) {
        print('🔓 Requesting DND bypass permissions during initialization...');
      }

      // Solicitar permisos de notificación
      final notificationStatus = await Permission.notification.request();

      // Solicitar permiso de ventana del sistema
      final systemAlertWindowStatus =
          await Permission.systemAlertWindow.request();

      if (kDebugMode) {
        print('🔓 Notification permission: $notificationStatus');
        print('🔓 System alert window permission: $systemAlertWindowStatus');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error requesting DND bypass permissions: $e');
      }
    }
  }

  /// Verifica si las alarmas exactas están permitidas y guía al usuario si no
  @override
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
  @override
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

  /// Verifica si la aplicación puede saltarse el modo "No molestar"
  @override
  Future<bool> canBypassDnd() async {
    try {
      // Verificar si tenemos permisos de notificación
      final notificationStatus = await Permission.notification.status;
      final systemAlertWindowStatus = await Permission.systemAlertWindow.status;

      final canBypass =
          notificationStatus.isGranted && systemAlertWindowStatus.isGranted;

      if (kDebugMode) {
        print('🔓 Can bypass DND: $canBypass');
        print('🔓 Notification permission: $notificationStatus');
        print('🔓 System alert window permission: $systemAlertWindowStatus');
      }

      return canBypass;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking DND bypass permission: $e');
      }
    }

    return false;
  }

  /// Solicita permiso para saltarse el modo "No molestar"
  @override
  Future<bool> requestDndBypassPermission() async {
    try {
      if (kDebugMode) {
        print('🔓 Requesting DND bypass permissions...');
      }

      // Solicitar permisos de notificación
      final notificationStatus = await Permission.notification.request();

      // Solicitar permiso de ventana del sistema (necesario para saltarse DND)
      final systemAlertWindowStatus =
          await Permission.systemAlertWindow.request();

      final granted =
          notificationStatus.isGranted && systemAlertWindowStatus.isGranted;

      if (kDebugMode) {
        print('🔓 DND bypass permission granted: $granted');
        print('🔓 Notification permission: $notificationStatus');
        print('🔓 System alert window permission: $systemAlertWindowStatus');
      }

      return granted;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error requesting DND bypass permission: $e');
      }
    }

    return false;
  }

  /// Verifica si hay notificaciones pendientes
  @override
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

  @override
  Future<void> playAlarmSound(AlarmSettings alarmSettings) async {
    try {
      if (!alarmSettings.isEnabled) {
        if (kDebugMode) {
          print('🔇 Alarm sound is disabled');
        }
        return;
      }

      if (kDebugMode) {
        print('🔊 Playing alarm sound: ${alarmSettings.soundName}');
      }

      // Verificar si podemos saltarnos DND
      final canBypassDndPermission = await canBypassDnd();
      if (!canBypassDndPermission) {
        if (kDebugMode) {
          print('⚠️ Cannot bypass DND, requesting permission...');
        }
        final permissionGranted = await requestDndBypassPermission();
        if (!permissionGranted) {
          if (kDebugMode) {
            print(
              '⚠️ DND bypass permission not granted, alarm may not sound with DND active',
            );
          }
        }
      }

      // Reproducir sonido
      await AlarmSoundService.playAlarmSound(
        soundUri: alarmSettings.soundUri,
        duration: alarmSettings.duration,
        volume: alarmSettings.volume.toDouble(),
      );

      // Agregar vibración como respaldo
      if (alarmSettings.vibrate) {
        await _triggerVibration();
      }

      // Mostrar notificación de alarma con sonido para saltarse DND
      await _showAlarmNotification(alarmSettings);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to play alarm sound: $e');
      }
      // No rethrow para no interrumpir la funcionalidad principal
    }
  }

  /// Activa la vibración del dispositivo
  Future<void> _triggerVibration() async {
    try {
      // Crear el patrón de vibración
      final vibrationPattern = Int64List.fromList([0, 500, 200, 500, 200, 500]);

      // Mostrar una notificación con vibración para asegurar feedback
      await _notifications.show(
        9999,
        '🔔 Break Completado',
        '¡Es hora de tomar un descanso!',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'breakly_alarm',
            'Alarma de Break',
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
            vibrationPattern: vibrationPattern,
          ),
        ),
      );

      if (kDebugMode) {
        print('📳 Vibration triggered');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to trigger vibration: $e');
      }
    }
  }

  /// Muestra una notificación de alarma con sonido para saltarse DND
  Future<void> _showAlarmNotification(AlarmSettings alarmSettings) async {
    try {
      // Crear el patrón de vibración
      final vibrationPattern = Int64List.fromList([
        0,
        1000,
        500,
        1000,
        500,
        1000,
      ]);

      // Mostrar notificación de alarma con máxima prioridad
      await _notifications.show(
        8888,
        '🔔 ¡Break Completado!',
        'Es hora de tomar un descanso',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'breakly_alarm',
            'Alarma de Break',
            importance: Importance.max,
            priority: Priority.max,
            showWhen: true,
            enableVibration: true,
            playSound: true,
            fullScreenIntent: true,
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
            ongoing: false,
            autoCancel: true,
            channelShowBadge: true,
            vibrationPattern: vibrationPattern,
            // Configurar sonido específico
            sound: _getNotificationSound(alarmSettings.soundUri),
          ),
        ),
      );

      if (kDebugMode) {
        print(
          '🔔 Alarm notification shown with DND bypass: ${alarmSettings.soundName}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to show alarm notification: $e');
      }
    }
  }

  /// Obtiene el sonido de notificación basado en el soundUri
  AndroidNotificationSound? _getNotificationSound(String soundUri) {
    // Para la versión actual de flutter_local_notifications,
    // simplemente retornamos null para usar el sonido por defecto del canal
    return null;
  }

  @override
  Future<void> stopAlarmSound() async {
    try {
      await AlarmSoundService.stopAlarmSound();
      if (kDebugMode) {
        print('🔇 Alarm sound stopped');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to stop alarm sound: $e');
      }
    }
  }
}
