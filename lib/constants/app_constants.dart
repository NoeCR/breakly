/// Constantes de la aplicación Breakly
class AppConstants {
  // Duración de sesiones por defecto
  static const List<int> defaultSessionDurations = [30, 60, 90];
  static const int defaultSessionDuration = 30;

  // Archivos de assets
  static const String videoAssetPath = 'assets/black_hole.mp4';
  static const String canyonImagePath = 'assets/canyon.avif';
  static const String monkImagePath = 'assets/monk.png';

  // Configuración de video
  static const double videoVolume = 0.0;
  static const bool videoLooping = true;

  // Configuración de notificaciones
  static const String notificationChannelId = 'breakly_session';
  static const String notificationChannelName = 'Fin de sesión';
  static const String notificationChannelDescription =
      'Notificaciones de finalización de sesión de trabajo';

  // Configuración de sincronización
  static const Duration syncInterval = Duration(seconds: 30);
  static const String appVersion = '1.0.0';

  // Configuración de cifrado
  static const String phoneEncryptionKey = 'breakly_phone_encryption_key_2024';

  // Configuración de dispositivo
  static const String deviceIdPrefix = 'breakly_device_';
  static const String deviceIdKey = 'device_id';

  // Configuración de preferencias
  static const String minutesTargetKey = 'minutes_target';
  static const String activeSessionStartedAtKey = 'active_session_started_at';

  // Configuración de Supabase
  static const String supabaseTableName = 'device_sessions';

  // Configuración de UI
  static const String appTitle = 'Breakly';
  static const String addButtonText = 'Add';
  static const String clearButtonText = 'Clear';

  // Configuración de canales nativos
  static const String phoneNumberChannel = 'phone_number/methods';
  static const String deviceModesChannel = 'device_modes/methods';
  static const String deviceModesEventsChannel = 'device_modes/events';

  // Configuración de video player
  static const String videoPlayerChannel = 'video_player/methods';

  // Configuración de notificaciones locales
  static const String localNotificationsChannel = 'flutter_local_notifications';

  // Configuración de tiempo
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
  static const Duration longTimeout = Duration(minutes: 2);

  // Configuración de retry
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Configuración de validación
  static const int minSessionDuration = 1; // 1 minuto
  static const int maxSessionDuration = 480; // 8 horas

  // Configuración de logging
  static const bool enableDebugLogging = true;
  static const bool enableErrorLogging = true;
}





