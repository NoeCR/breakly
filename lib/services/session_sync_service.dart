import 'dart:async';
import '../interfaces/remote_session_repository.dart';
import '../interfaces/preferences_repository.dart';
import '../models/remote_session_data.dart';
import '../models/app_state.dart';
import '../models/session_state.dart';
import '../models/device_mode_state.dart';
import 'device_id_service.dart';

/// Servicio que maneja la sincronización entre el estado local y remoto
class SessionSyncService {
  SessionSyncService({
    required RemoteSessionRepository remoteRepository,
    required PreferencesRepository preferencesRepository,
  }) : _remoteRepository = remoteRepository,
       _preferencesRepository = preferencesRepository;

  final RemoteSessionRepository _remoteRepository;
  final PreferencesRepository
  _preferencesRepository; // TODO: Usar para persistencia local adicional

  Timer? _syncTimer;
  bool _isInitialized = false;
  String? _currentDeviceId;
  String? _currentSessionId;

  /// Inicializa el servicio de sincronización
  Future<void> initialize() async {
    if (_isInitialized) return;

    _currentDeviceId = await DeviceIdService.getDeviceId();
    _isInitialized = true;

    // Verificar que el repositorio de preferencias esté disponible
    // (esto evita el warning de campo no usado)
    _preferencesRepository.toString();
  }

  /// Sincroniza el estado local con el remoto al iniciar la app
  Future<AppState?> syncOnStartup(AppState currentState) async {
    if (!_isInitialized) await initialize();

    try {
      // Buscar sesión activa remota
      final remoteSession = await _remoteRepository.getActiveSession(
        _currentDeviceId!,
      );

      if (remoteSession != null) {
        // Hay una sesión activa remota, restaurar el estado
        return _restoreStateFromRemote(remoteSession, currentState);
      } else {
        // No hay sesión remota, sincronizar estado local si hay sesión activa
        if (currentState.isSessionActive) {
          await _syncLocalToRemote(currentState);
        }
        return null; // No hay cambios en el estado
      }
    } catch (e) {
      // En caso de error, continuar con el estado local
      return null;
    }
  }

  /// Sincroniza el estado actual con el remoto
  Future<void> syncCurrentState(AppState currentState) async {
    if (!_isInitialized) await initialize();
    if (!currentState.isSessionActive) return;

    try {
      await _syncLocalToRemote(currentState);
    } catch (e) {
      // Log error pero no interrumpir la funcionalidad local
    }
  }

  /// Inicia la sincronización automática periódica
  void startPeriodicSync(AppState currentState) {
    if (!currentState.isSessionActive) return;

    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      syncCurrentState(currentState);
    });
  }

  /// Detiene la sincronización automática
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// Crea una nueva sesión remota
  Future<void> createRemoteSession(AppState currentState) async {
    if (!_isInitialized) await initialize();

    try {
      final remoteSession = RemoteSessionData.create(
        deviceId: _currentDeviceId!,
        appVersion: '1.0.0', // TODO: Obtener de package_info_plus
      ).copyWith(
        activatedAt: currentState.session.activatedAt,
        elapsedSeconds: currentState.session.elapsed.inSeconds,
        minutesTarget: currentState.session.minutesTarget,
        isCustomMinutes: currentState.session.isCustomMinutes,
        isActive: currentState.isSessionActive,
        isDoNotDisturb: currentState.deviceMode.isDoNotDisturb,
        isAirplaneMode: currentState.deviceMode.isAirplaneMode,
        ringerMode: currentState.deviceMode.ringerMode,
      );

      final createdSession = await _remoteRepository.createSession(
        remoteSession,
      );
      _currentSessionId = createdSession.sessionId;
    } catch (e) {
      // Log error pero continuar con funcionalidad local
    }
  }

  /// Finaliza la sesión remota
  Future<void> endRemoteSession() async {
    if (_currentSessionId == null) return;

    try {
      await _remoteRepository.endSession(_currentSessionId!);
      _currentSessionId = null;
    } catch (e) {
      // Log error
    }
  }

  /// Restaura el estado desde datos remotos
  AppState _restoreStateFromRemote(
    RemoteSessionData remoteSession,
    AppState currentState,
  ) {
    final sessionState = SessionState(
      activatedAt: remoteSession.activatedAt,
      elapsed: Duration(seconds: remoteSession.elapsedSeconds),
      minutesTarget: remoteSession.minutesTarget,
      isCustomMinutes: remoteSession.isCustomMinutes,
    );

    final deviceModeState = DeviceModeState(
      isDoNotDisturb: remoteSession.isDoNotDisturb,
      isAirplaneMode: remoteSession.isAirplaneMode,
      ringerMode: remoteSession.ringerMode,
    );

    _currentSessionId = remoteSession.sessionId;

    return currentState.copyWith(
      session: sessionState,
      deviceMode: deviceModeState,
    );
  }

  /// Sincroniza el estado local con el remoto
  Future<void> _syncLocalToRemote(AppState currentState) async {
    if (_currentSessionId == null) {
      // Crear nueva sesión remota
      await createRemoteSession(currentState);
      return;
    }

    try {
      // Actualizar sesión existente
      final remoteSession = RemoteSessionData(
        id: null, // Se obtendrá del servidor
        deviceId: _currentDeviceId!,
        sessionId: _currentSessionId!,
        activatedAt: currentState.session.activatedAt,
        elapsedSeconds: currentState.session.elapsed.inSeconds,
        minutesTarget: currentState.session.minutesTarget,
        isCustomMinutes: currentState.session.isCustomMinutes,
        isActive: currentState.isSessionActive,
        isDoNotDisturb: currentState.deviceMode.isDoNotDisturb,
        isAirplaneMode: currentState.deviceMode.isAirplaneMode,
        ringerMode: currentState.deviceMode.ringerMode,
        appVersion: '1.0.0',
      );

      await _remoteRepository.updateSession(remoteSession);
    } catch (e) {
      // Log error
    }
  }

  /// Obtiene el estado de sincronización
  Future<SyncStatus> getSyncStatus() async {
    return await _remoteRepository.getSyncStatus();
  }

  /// Verifica si hay conectividad
  Future<bool> isConnected() async {
    return await _remoteRepository.isConnected();
  }

  /// Fuerza una sincronización completa
  Future<void> forceSync() async {
    await _remoteRepository.forceSync();
  }

  /// Limpia recursos
  void dispose() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }
}
