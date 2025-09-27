import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'remote_session_data.freezed.dart';
part 'remote_session_data.g.dart';

@freezed
class RemoteSessionData with _$RemoteSessionData {
  const factory RemoteSessionData({
    String? id, // UUID de la fila en la base de datos
    required String userId, // Número de teléfono cifrado o device_id fallback
    required String deviceId, // Identificador único del dispositivo
    required String sessionId, // UUID de la sesión
    // Estado de la sesión
    DateTime? activatedAt,
    @Default(0) int elapsedSeconds,
    @Default(30) int minutesTarget,
    @Default(false) bool isCustomMinutes,
    @Default(false) bool isActive,

    // Estado del dispositivo
    @Default(false) bool isDoNotDisturb,
    @Default(false) bool isAirplaneMode,
    @Default('normal') String ringerMode,

    // Metadatos
    String? appVersion,
    @Default(false) bool phoneNumberAvailable, // Si se pudo obtener el número de teléfono
    DateTime? lastSyncAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RemoteSessionData;

  const RemoteSessionData._();

  factory RemoteSessionData.fromJson(Map<String, dynamic> json) =>
      _$RemoteSessionDataFromJson(json);

  /// Crea una nueva sesión remota con valores por defecto
  factory RemoteSessionData.create({
    required String deviceId,
    required String userId,
    String? appVersion,
    bool phoneNumberAvailable = false,
  }) {
    const uuid = Uuid();
    return RemoteSessionData(
      deviceId: deviceId,
      sessionId: uuid.v4(),
      userId: userId,
      appVersion: appVersion,
      phoneNumberAvailable: phoneNumberAvailable,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastSyncAt: DateTime.now(),
    );
  }

  /// Convierte a formato para insertar en Supabase
  Map<String, dynamic> toSupabaseJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'device_id': deviceId,
      'session_id': sessionId,
      'activated_at': activatedAt?.toIso8601String(),
      'elapsed_seconds': elapsedSeconds,
      'minutes_target': minutesTarget,
      'is_custom_minutes': isCustomMinutes,
      'is_active': isActive,
      'is_do_not_disturb': isDoNotDisturb,
      'is_airplane_mode': isAirplaneMode,
      'ringer_mode': ringerMode,
      if (appVersion != null) 'app_version': appVersion,
      'phone_number_available': phoneNumberAvailable,
      'last_sync_at': lastSyncAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Crea desde datos de Supabase
  factory RemoteSessionData.fromSupabaseJson(Map<String, dynamic> json) {
    return RemoteSessionData(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      deviceId: json['device_id'] as String,
      sessionId: json['session_id'] as String,
      activatedAt:
          json['activated_at'] != null
              ? DateTime.parse(json['activated_at'] as String)
              : null,
      elapsedSeconds: json['elapsed_seconds'] as int? ?? 0,
      minutesTarget: json['minutes_target'] as int? ?? 30,
      isCustomMinutes: json['is_custom_minutes'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? false,
      isDoNotDisturb: json['is_do_not_disturb'] as bool? ?? false,
      isAirplaneMode: json['is_airplane_mode'] as bool? ?? false,
      ringerMode: json['ringer_mode'] as String? ?? 'normal',
      appVersion: json['app_version'] as String?,
      phoneNumberAvailable: json['phone_number_available'] as bool? ?? false,
      lastSyncAt:
          json['last_sync_at'] != null
              ? DateTime.parse(json['last_sync_at'] as String)
              : null,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
    );
  }

  /// Actualiza los timestamps de sincronización
  RemoteSessionData markAsSynced() {
    return copyWith(lastSyncAt: DateTime.now(), updatedAt: DateTime.now());
  }

  /// Verifica si la sesión necesita sincronización
  bool needsSync(DateTime lastLocalSync) {
    if (lastSyncAt == null) return true;
    return lastSyncAt!.isBefore(lastLocalSync);
  }
}

