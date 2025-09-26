import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../interfaces/remote_session_repository.dart';
import '../models/remote_session_data.dart';

/// Implementación concreta del repositorio de sesiones remotas usando Supabase
class SupabaseSessionRepository implements RemoteSessionRepository {
  SupabaseSessionRepository() : _client = SupabaseConfig.client;

  final SupabaseClient _client;
  final Map<String, dynamic> _subscriptions = {};
  SyncStatus _currentSyncStatus = SyncStatus.notInitialized;

  @override
  Future<RemoteSessionData?> getActiveSession(String deviceId) async {
    try {
      _updateSyncStatus(SyncStatus.syncing);

      final response =
          await _client
              .from('sessions')
              .select()
              .eq('device_id', deviceId)
              .eq('is_active', true)
              .maybeSingle();

      if (response == null) {
        _updateSyncStatus(SyncStatus.synced);
        return null;
      }

      final session = RemoteSessionData.fromSupabaseJson(response);
      _updateSyncStatus(SyncStatus.synced);
      return session;
    } catch (e) {
      _updateSyncStatus(SyncStatus.error);
      throw SyncException(
        'Error al obtener sesión activa: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<RemoteSessionData?> getSessionById(String sessionId) async {
    try {
      _updateSyncStatus(SyncStatus.syncing);

      final response =
          await _client
              .from('sessions')
              .select()
              .eq('session_id', sessionId)
              .maybeSingle();

      if (response == null) {
        _updateSyncStatus(SyncStatus.synced);
        return null;
      }

      final session = RemoteSessionData.fromSupabaseJson(response);
      _updateSyncStatus(SyncStatus.synced);
      return session;
    } catch (e) {
      _updateSyncStatus(SyncStatus.error);
      throw SyncException(
        'Error al obtener sesión por ID: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<RemoteSessionData> createSession(RemoteSessionData session) async {
    try {
      _updateSyncStatus(SyncStatus.syncing);

      final sessionData = session.toSupabaseJson();
      sessionData.remove(
        'id',
      ); // No incluir ID para que se genere automáticamente

      final response =
          await _client.from('sessions').insert(sessionData).select().single();

      final createdSession = RemoteSessionData.fromSupabaseJson(response);
      _updateSyncStatus(SyncStatus.synced);
      return createdSession;
    } catch (e) {
      _updateSyncStatus(SyncStatus.error);
      throw SyncException(
        'Error al crear sesión: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<RemoteSessionData> updateSession(RemoteSessionData session) async {
    try {
      _updateSyncStatus(SyncStatus.syncing);

      if (session.id == null) {
        throw SyncException('No se puede actualizar una sesión sin ID');
      }

      final sessionData = session.markAsSynced().toSupabaseJson();
      sessionData.remove('id'); // No actualizar el ID
      sessionData.remove('created_at'); // No actualizar fecha de creación

      final response =
          await _client
              .from('sessions')
              .update(sessionData)
              .eq('id', session.id!)
              .select()
              .single();

      final updatedSession = RemoteSessionData.fromSupabaseJson(response);
      _updateSyncStatus(SyncStatus.synced);
      return updatedSession;
    } catch (e) {
      _updateSyncStatus(SyncStatus.error);
      throw SyncException(
        'Error al actualizar sesión: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> endSession(String sessionId) async {
    try {
      _updateSyncStatus(SyncStatus.syncing);

      await _client
          .from('sessions')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('session_id', sessionId);

      _updateSyncStatus(SyncStatus.synced);
    } catch (e) {
      _updateSyncStatus(SyncStatus.error);
      throw SyncException(
        'Error al finalizar sesión: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    try {
      _updateSyncStatus(SyncStatus.syncing);

      await _client.from('sessions').delete().eq('session_id', sessionId);

      _updateSyncStatus(SyncStatus.synced);
    } catch (e) {
      _updateSyncStatus(SyncStatus.error);
      throw SyncException(
        'Error al eliminar sesión: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Stream<RemoteSessionData> watchSession(String sessionId) {
    final controller = StreamController<RemoteSessionData>.broadcast();
    final channel = _client.channel('session_$sessionId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'sessions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'session_id',
            value: sessionId,
          ),
          callback: (payload) {
            try {
              final session = RemoteSessionData.fromSupabaseJson(
                payload.newRecord,
              );
              controller.add(session);
            } catch (e) {
              controller.addError(
                SyncException(
                  'Error al procesar cambio de sesión: ${e.toString()}',
                  originalError: e,
                ),
              );
            }
          },
        )
        .subscribe();

    _subscriptions['session_$sessionId'] = channel;

    // Cleanup cuando se cancele el stream
    controller.onCancel = () {
      channel.unsubscribe();
      _subscriptions.remove('session_$sessionId');
    };

    return controller.stream;
  }

  @override
  Stream<List<RemoteSessionData>> watchActiveSessions(String deviceId) {
    final controller = StreamController<List<RemoteSessionData>>.broadcast();
    final channel = _client.channel('active_sessions_$deviceId');
    final List<RemoteSessionData> activeSessions = [];

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'sessions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'device_id',
            value: deviceId,
          ),
          callback: (payload) {
            try {
              final session = RemoteSessionData.fromSupabaseJson(
                payload.newRecord,
              );

              // Filtrar solo sesiones activas
              if (session.isActive) {
                switch (payload.eventType) {
                  case PostgresChangeEvent.insert:
                  case PostgresChangeEvent.update:
                    // Actualizar o agregar sesión activa
                    final existingIndex = activeSessions.indexWhere(
                      (s) => s.sessionId == session.sessionId,
                    );
                    if (existingIndex >= 0) {
                      activeSessions[existingIndex] = session;
                    } else {
                      activeSessions.add(session);
                    }
                    break;
                  case PostgresChangeEvent.delete:
                    // Remover sesión de la lista
                    activeSessions.removeWhere(
                      (s) => s.sessionId == session.sessionId,
                    );
                    break;
                  case PostgresChangeEvent.all:
                    // Para el caso 'all', manejamos como update
                    final existingIndex = activeSessions.indexWhere(
                      (s) => s.sessionId == session.sessionId,
                    );
                    if (existingIndex >= 0) {
                      activeSessions[existingIndex] = session;
                    } else {
                      activeSessions.add(session);
                    }
                    break;
                }
              } else {
                // Si la sesión no está activa, removerla de la lista
                activeSessions.removeWhere(
                  (s) => s.sessionId == session.sessionId,
                );
              }

              controller.add(List.from(activeSessions));
            } catch (e) {
              controller.addError(
                SyncException(
                  'Error al procesar cambio de sesiones activas: ${e.toString()}',
                  originalError: e,
                ),
              );
            }
          },
        )
        .subscribe();

    _subscriptions['active_sessions_$deviceId'] = channel;

    // Cleanup cuando se cancele el stream
    controller.onCancel = () {
      channel.unsubscribe();
      _subscriptions.remove('active_sessions_$deviceId');
    };

    return controller.stream;
  }

  @override
  Future<bool> isConnected() async {
    try {
      // Hacer una query simple para verificar conectividad
      await _client.from('sessions').select('id').limit(1);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<SyncStatus> getSyncStatus() async {
    return _currentSyncStatus;
  }

  @override
  Future<void> forceSync() async {
    try {
      _updateSyncStatus(SyncStatus.syncing);

      // Verificar conectividad
      final connected = await isConnected();
      if (!connected) {
        _updateSyncStatus(SyncStatus.offline);
        throw SyncException('Sin conexión al servidor');
      }

      // Aquí se podría implementar lógica adicional de sincronización
      // Por ejemplo, sincronizar datos pendientes, resolver conflictos, etc.

      _updateSyncStatus(SyncStatus.synced);
    } catch (e) {
      _updateSyncStatus(SyncStatus.error);
      rethrow;
    }
  }

  /// Actualiza el estado de sincronización
  void _updateSyncStatus(SyncStatus status) {
    _currentSyncStatus = status;
  }

  /// Limpia todas las suscripciones activas
  void dispose() {
    for (final subscription in _subscriptions.values) {
      if (subscription is StreamSubscription) {
        subscription.cancel();
      } else if (subscription is RealtimeChannel) {
        subscription.unsubscribe();
      }
    }
    _subscriptions.clear();
  }
}
