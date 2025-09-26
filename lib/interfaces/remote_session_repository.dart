import '../models/remote_session_data.dart';

/// Interfaz para el repositorio de sesiones remotas
/// Define las operaciones necesarias para sincronizar el estado de la sesión
/// con la base de datos remota (Supabase)
abstract class RemoteSessionRepository {
  /// Obtiene la sesión activa para un dispositivo específico
  /// Retorna null si no hay sesión activa
  Future<RemoteSessionData?> getActiveSession(String deviceId);

  /// Obtiene una sesión específica por su ID
  Future<RemoteSessionData?> getSessionById(String sessionId);

  /// Crea una nueva sesión en la base de datos remota
  Future<RemoteSessionData> createSession(RemoteSessionData session);

  /// Actualiza una sesión existente
  Future<RemoteSessionData> updateSession(RemoteSessionData session);

  /// Marca una sesión como inactiva (finalizada)
  Future<void> endSession(String sessionId);

  /// Elimina una sesión de la base de datos
  Future<void> deleteSession(String sessionId);

  /// Suscribe a cambios en tiempo real de una sesión específica
  /// Útil para sincronización automática entre dispositivos
  Stream<RemoteSessionData> watchSession(String sessionId);

  /// Suscribe a cambios en tiempo real de todas las sesiones activas de un dispositivo
  Stream<List<RemoteSessionData>> watchActiveSessions(String deviceId);

  /// Verifica la conectividad con el servidor
  Future<bool> isConnected();

  /// Obtiene el estado de sincronización
  Future<SyncStatus> getSyncStatus();

  /// Fuerza una sincronización completa
  Future<void> forceSync();
}

/// Estado de sincronización
enum SyncStatus {
  /// Sincronizado correctamente
  synced,

  /// Sincronizando actualmente
  syncing,

  /// Error en la sincronización
  error,

  /// Sin conexión
  offline,

  /// No inicializado
  notInitialized,
}

/// Excepción personalizada para errores de sincronización
class SyncException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const SyncException(this.message, {this.code, this.originalError});

  @override
  String toString() {
    return 'SyncException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Excepción para conflictos de sincronización
class SyncConflictException extends SyncException {
  final RemoteSessionData localData;
  final RemoteSessionData remoteData;

  const SyncConflictException(
    this.localData,
    this.remoteData, {
    String? message,
  }) : super(
         message ?? 'Conflicto de sincronización detectado',
         code: 'SYNC_CONFLICT',
       );
}

