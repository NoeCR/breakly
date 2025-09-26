import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../interfaces/preferences_repository.dart';
import '../interfaces/notification_service.dart';
import '../interfaces/device_mode_service.dart';
import '../interfaces/remote_session_repository.dart';
import '../services/preferences_repository_impl.dart';
import '../services/notification_service_impl.dart';
import '../services/device_mode_service_impl.dart';
import '../services/supabase_session_repository.dart';
import '../services/session_sync_service.dart';

// Providers for dependencies
final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepositoryImpl();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationServiceImpl();
});

final deviceModeServiceProvider = Provider<DeviceModeService>((ref) {
  return DeviceModeServiceImpl();
});

final remoteSessionRepositoryProvider = Provider<RemoteSessionRepository>((
  ref,
) {
  return SupabaseSessionRepository();
});

final sessionSyncServiceProvider = Provider<SessionSyncService>((ref) {
  return SessionSyncService(
    remoteRepository: ref.read(remoteSessionRepositoryProvider),
    preferencesRepository: ref.read(preferencesRepositoryProvider),
  );
});
