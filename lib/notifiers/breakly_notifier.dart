import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_state.dart';
import '../models/device_mode_state.dart';
import '../interfaces/preferences_repository.dart';
import '../interfaces/notification_service.dart';
import '../interfaces/device_mode_service.dart';
import '../interfaces/remote_session_repository.dart';
import '../services/session_sync_service.dart';
import 'providers.dart';

class BreaklyNotifier extends StateNotifier<AppState> {
  BreaklyNotifier({
    required PreferencesRepository preferencesRepository,
    required NotificationService notificationService,
    required DeviceModeService deviceModeService,
    required SessionSyncService sessionSyncService,
  }) : _preferencesRepository = preferencesRepository,
       _notificationService = notificationService,
       _deviceModeService = deviceModeService,
       _sessionSyncService = sessionSyncService,
       super(const AppState()) {
    _initialize();
  }

  final PreferencesRepository _preferencesRepository;
  final NotificationService _notificationService;
  final DeviceModeService _deviceModeService;
  final SessionSyncService _sessionSyncService;

  StreamSubscription<Map<String, dynamic>>? _deviceModeSubscription;
  Timer? _timer;
  bool _notificationShown = false;

  // Callback para controlar el video desde la UI
  void Function(bool)? _onVideoStateChanged;

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);

    try {
      await _notificationService.initialize();
      await _sessionSyncService.initialize();

      // Establecer el callback para obtener el estado actual
      _sessionSyncService.setStateCallback(() => state);

      // Intentar sincronizar con sesión remota al inicio
      final restoredState = await _sessionSyncService.syncOnStartup(state);
      if (restoredState != null) {
        state = restoredState;
      } else {
        await _restoreSessionIfAny();
      }

      await _loadMinutesTarget();
      _listenToDeviceModeChanges();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _loadMinutesTarget() async {
    final minutesTarget = await _preferencesRepository.getMinutesTarget() ?? 30;
    state = state.copyWith(
      session: state.session.copyWith(minutesTarget: minutesTarget),
    );
  }

  Future<void> _restoreSessionIfAny() async {
    final millis = await _preferencesRepository.getActiveSessionStartedAt();
    if (millis != null) {
      final activatedAt = DateTime.fromMillisecondsSinceEpoch(millis);
      state = state.copyWith(
        session: state.session.copyWith(activatedAt: activatedAt),
      );
      _startTimer();
    }
  }

  void _listenToDeviceModeChanges() {
    _deviceModeSubscription?.cancel();
    _deviceModeSubscription = _deviceModeService.deviceModeStream.listen((
      event,
    ) {
      final dnd = event['dnd'] == true;
      final airplane = event['airplane'] == true;
      final ringer = (event['ringer'] as String?) ?? 'normal';
      final active = dnd || airplane || ringer == 'silent';

      state = state.copyWith(
        deviceMode: DeviceModeState(
          isDoNotDisturb: dnd,
          isAirplaneMode: airplane,
          ringerMode: ringer,
        ),
      );

      _handleActiveState(active);

      // Sincronizar cambios de estado del dispositivo después de actualizar el estado
      _sessionSyncService.syncCurrentState(state);
    });
  }

  void _handleActiveState(bool active) {
    if (active) {
      if (!state.session.isActive) {
        final now = DateTime.now();
        _notificationShown = false; // Reset notification flag
        state = state.copyWith(
          session: state.session.copyWith(activatedAt: now),
        );
        _startTimer();
        _persistStart();
        _scheduleEndNotification();

        // Sincronizar con remoto
        _sessionSyncService.syncCurrentState(state);
        _sessionSyncService.startPeriodicSync();
      }
      // Reproducir video cuando se activa
      _onVideoStateChanged?.call(true);
    } else {
      _notificationShown = false; // Reset notification flag

      // Sincronizar estado final antes de resetear la sesión
      _sessionSyncService.syncCurrentState(state);

      state = state.copyWith(
        session: state.session.copyWith(
          activatedAt: null,
          elapsed: Duration.zero,
        ),
      );
      _stopTimer();
      _clearPersistedStart();
      _cancelEndNotification();

      // Finalizar sesión remota y detener sincronización
      _sessionSyncService.endRemoteSession();
      _sessionSyncService.stopPeriodicSync();

      // Pausar video cuando se desactiva
      _onVideoStateChanged?.call(false);
    }
  }

  Future<void> _persistStart() async {
    if (state.session.activatedAt != null) {
      await _preferencesRepository.setActiveSessionStartedAt(
        state.session.activatedAt!.millisecondsSinceEpoch,
      );
    }
  }

  Future<void> _clearPersistedStart() async {
    await _preferencesRepository.clearActiveSessionStartedAt();
  }

  Future<void> _scheduleEndNotification() async {
    await _notificationService.scheduleEndNotification(
      state.session.minutesTarget,
    );
  }

  Future<void> _cancelEndNotification() async {
    await _notificationService.cancelEndNotification();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.session.activatedAt != null) {
        final elapsed = DateTime.now().difference(state.session.activatedAt!);
        final targetDuration = Duration(minutes: state.session.minutesTarget);

        // Verificar si se alcanzó el tiempo objetivo
        if (elapsed >= targetDuration && !_notificationShown) {
          _notificationShown = true;
          // Mostrar notificación inmediata usando el timer
          _showImmediateNotification();
        }

        state = state.copyWith(
          session: state.session.copyWith(elapsed: elapsed),
        );

        // Sincronizar estado cada 30 segundos
        if (elapsed.inSeconds % 30 == 0) {
          _sessionSyncService.syncCurrentState(state);
        }
      }
    });
  }

  Future<void> _showImmediateNotification() async {
    try {
      // Cancelar la notificación programada para evitar duplicados
      await _cancelEndNotification();
      // Mostrar notificación inmediata
      await _notificationService.scheduleEndNotification(0);
    } catch (e) {
      // Handle error silently - no interrumpir la funcionalidad principal
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> updateMinutesTarget(int minutes) async {
    state = state.copyWith(
      session: state.session.copyWith(minutesTarget: minutes),
    );

    await _preferencesRepository.setMinutesTarget(minutes);

    // Si hay sesión activa, reprogramamos la notificación
    if (state.session.isActive) {
      await _cancelEndNotification();
      await _scheduleEndNotification();
    }
  }

  Future<void> disableAllModes() async {
    try {
      final hasAccess = await _deviceModeService.hasDoNotDisturbAccess();
      if (hasAccess) {
        await _deviceModeService.setDoNotDisturb(false);
      }
      await _deviceModeService.toggleRinger('normal');
    } catch (e) {
      // Handle error silently - no interrumpir la funcionalidad principal
    }
  }

  Future<void> enablePreferredMode() async {
    try {
      final hasAccess = await _deviceModeService.hasDoNotDisturbAccess();
      if (hasAccess) {
        await _deviceModeService.setDoNotDisturb(true);
      } else {
        // Fallback: silenciar y abrir ajustes para conceder permiso DND
        try {
          await _deviceModeService.toggleRinger('silent');
        } catch (e) {
          // Handle error silently
        }
        await _deviceModeService.openDoNotDisturbSettings();
      }
    } catch (e) {
      // Handle error silently - no interrumpir la funcionalidad principal
    }
  }

  void setVideoInitialized(bool initialized) {
    state = state.copyWith(isVideoInitialized: initialized);
  }

  void setVideoController(void Function(bool) onVideoStateChanged) {
    _onVideoStateChanged = onVideoStateChanged;
  }

  Future<bool> checkExactAlarmsPermission() async {
    return await _notificationService.checkExactAlarmsPermission();
  }

  Future<bool> areNotificationsEnabled() async {
    return await _notificationService.areNotificationsEnabled();
  }

  Future<void> checkPendingNotifications() async {
    await _notificationService.checkPendingNotifications();
  }

  /// Obtiene el estado de sincronización
  Future<SyncStatus> getSyncStatus() async {
    return await _sessionSyncService.getSyncStatus();
  }

  /// Verifica si hay conectividad
  Future<bool> isConnected() async {
    return await _sessionSyncService.isConnected();
  }

  /// Fuerza una sincronización completa
  Future<void> forceSync() async {
    await _sessionSyncService.forceSync();
  }

  void dispose() {
    _deviceModeSubscription?.cancel();
    _stopTimer();
    _sessionSyncService.dispose();
    super.dispose();
  }
}

// Provider for the main notifier
final breaklyNotifierProvider =
    StateNotifierProvider<BreaklyNotifier, AppState>((ref) {
      return BreaklyNotifier(
        preferencesRepository: ref.watch(preferencesRepositoryProvider),
        notificationService: ref.watch(notificationServiceProvider),
        deviceModeService: ref.watch(deviceModeServiceProvider),
        sessionSyncService: ref.watch(sessionSyncServiceProvider),
      );
    });
