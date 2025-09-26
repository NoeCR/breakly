// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_session_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RemoteSessionData _$RemoteSessionDataFromJson(Map<String, dynamic> json) {
  return _RemoteSessionData.fromJson(json);
}

/// @nodoc
mixin _$RemoteSessionData {
  String? get id =>
      throw _privateConstructorUsedError; // UUID de la fila en la base de datos
  String? get userId =>
      throw _privateConstructorUsedError; // UUID del usuario (opcional)
  String get deviceId =>
      throw _privateConstructorUsedError; // Identificador único del dispositivo
  String get sessionId =>
      throw _privateConstructorUsedError; // UUID de la sesión
  // Estado de la sesión
  DateTime? get activatedAt => throw _privateConstructorUsedError;
  int get elapsedSeconds => throw _privateConstructorUsedError;
  int get minutesTarget => throw _privateConstructorUsedError;
  bool get isCustomMinutes => throw _privateConstructorUsedError;
  bool get isActive =>
      throw _privateConstructorUsedError; // Estado del dispositivo
  bool get isDoNotDisturb => throw _privateConstructorUsedError;
  bool get isAirplaneMode => throw _privateConstructorUsedError;
  String get ringerMode => throw _privateConstructorUsedError; // Metadatos
  String? get appVersion => throw _privateConstructorUsedError;
  DateTime? get lastSyncAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RemoteSessionData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RemoteSessionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RemoteSessionDataCopyWith<RemoteSessionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoteSessionDataCopyWith<$Res> {
  factory $RemoteSessionDataCopyWith(
    RemoteSessionData value,
    $Res Function(RemoteSessionData) then,
  ) = _$RemoteSessionDataCopyWithImpl<$Res, RemoteSessionData>;
  @useResult
  $Res call({
    String? id,
    String? userId,
    String deviceId,
    String sessionId,
    DateTime? activatedAt,
    int elapsedSeconds,
    int minutesTarget,
    bool isCustomMinutes,
    bool isActive,
    bool isDoNotDisturb,
    bool isAirplaneMode,
    String ringerMode,
    String? appVersion,
    DateTime? lastSyncAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$RemoteSessionDataCopyWithImpl<$Res, $Val extends RemoteSessionData>
    implements $RemoteSessionDataCopyWith<$Res> {
  _$RemoteSessionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RemoteSessionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? deviceId = null,
    Object? sessionId = null,
    Object? activatedAt = freezed,
    Object? elapsedSeconds = null,
    Object? minutesTarget = null,
    Object? isCustomMinutes = null,
    Object? isActive = null,
    Object? isDoNotDisturb = null,
    Object? isAirplaneMode = null,
    Object? ringerMode = null,
    Object? appVersion = freezed,
    Object? lastSyncAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            userId:
                freezed == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String?,
            deviceId:
                null == deviceId
                    ? _value.deviceId
                    : deviceId // ignore: cast_nullable_to_non_nullable
                        as String,
            sessionId:
                null == sessionId
                    ? _value.sessionId
                    : sessionId // ignore: cast_nullable_to_non_nullable
                        as String,
            activatedAt:
                freezed == activatedAt
                    ? _value.activatedAt
                    : activatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            elapsedSeconds:
                null == elapsedSeconds
                    ? _value.elapsedSeconds
                    : elapsedSeconds // ignore: cast_nullable_to_non_nullable
                        as int,
            minutesTarget:
                null == minutesTarget
                    ? _value.minutesTarget
                    : minutesTarget // ignore: cast_nullable_to_non_nullable
                        as int,
            isCustomMinutes:
                null == isCustomMinutes
                    ? _value.isCustomMinutes
                    : isCustomMinutes // ignore: cast_nullable_to_non_nullable
                        as bool,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            isDoNotDisturb:
                null == isDoNotDisturb
                    ? _value.isDoNotDisturb
                    : isDoNotDisturb // ignore: cast_nullable_to_non_nullable
                        as bool,
            isAirplaneMode:
                null == isAirplaneMode
                    ? _value.isAirplaneMode
                    : isAirplaneMode // ignore: cast_nullable_to_non_nullable
                        as bool,
            ringerMode:
                null == ringerMode
                    ? _value.ringerMode
                    : ringerMode // ignore: cast_nullable_to_non_nullable
                        as String,
            appVersion:
                freezed == appVersion
                    ? _value.appVersion
                    : appVersion // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastSyncAt:
                freezed == lastSyncAt
                    ? _value.lastSyncAt
                    : lastSyncAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RemoteSessionDataImplCopyWith<$Res>
    implements $RemoteSessionDataCopyWith<$Res> {
  factory _$$RemoteSessionDataImplCopyWith(
    _$RemoteSessionDataImpl value,
    $Res Function(_$RemoteSessionDataImpl) then,
  ) = __$$RemoteSessionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String? userId,
    String deviceId,
    String sessionId,
    DateTime? activatedAt,
    int elapsedSeconds,
    int minutesTarget,
    bool isCustomMinutes,
    bool isActive,
    bool isDoNotDisturb,
    bool isAirplaneMode,
    String ringerMode,
    String? appVersion,
    DateTime? lastSyncAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$RemoteSessionDataImplCopyWithImpl<$Res>
    extends _$RemoteSessionDataCopyWithImpl<$Res, _$RemoteSessionDataImpl>
    implements _$$RemoteSessionDataImplCopyWith<$Res> {
  __$$RemoteSessionDataImplCopyWithImpl(
    _$RemoteSessionDataImpl _value,
    $Res Function(_$RemoteSessionDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RemoteSessionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? deviceId = null,
    Object? sessionId = null,
    Object? activatedAt = freezed,
    Object? elapsedSeconds = null,
    Object? minutesTarget = null,
    Object? isCustomMinutes = null,
    Object? isActive = null,
    Object? isDoNotDisturb = null,
    Object? isAirplaneMode = null,
    Object? ringerMode = null,
    Object? appVersion = freezed,
    Object? lastSyncAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$RemoteSessionDataImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
        userId:
            freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String?,
        deviceId:
            null == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                    as String,
        sessionId:
            null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                    as String,
        activatedAt:
            freezed == activatedAt
                ? _value.activatedAt
                : activatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        elapsedSeconds:
            null == elapsedSeconds
                ? _value.elapsedSeconds
                : elapsedSeconds // ignore: cast_nullable_to_non_nullable
                    as int,
        minutesTarget:
            null == minutesTarget
                ? _value.minutesTarget
                : minutesTarget // ignore: cast_nullable_to_non_nullable
                    as int,
        isCustomMinutes:
            null == isCustomMinutes
                ? _value.isCustomMinutes
                : isCustomMinutes // ignore: cast_nullable_to_non_nullable
                    as bool,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        isDoNotDisturb:
            null == isDoNotDisturb
                ? _value.isDoNotDisturb
                : isDoNotDisturb // ignore: cast_nullable_to_non_nullable
                    as bool,
        isAirplaneMode:
            null == isAirplaneMode
                ? _value.isAirplaneMode
                : isAirplaneMode // ignore: cast_nullable_to_non_nullable
                    as bool,
        ringerMode:
            null == ringerMode
                ? _value.ringerMode
                : ringerMode // ignore: cast_nullable_to_non_nullable
                    as String,
        appVersion:
            freezed == appVersion
                ? _value.appVersion
                : appVersion // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastSyncAt:
            freezed == lastSyncAt
                ? _value.lastSyncAt
                : lastSyncAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RemoteSessionDataImpl extends _RemoteSessionData {
  const _$RemoteSessionDataImpl({
    this.id,
    this.userId,
    required this.deviceId,
    required this.sessionId,
    this.activatedAt,
    this.elapsedSeconds = 0,
    this.minutesTarget = 30,
    this.isCustomMinutes = false,
    this.isActive = false,
    this.isDoNotDisturb = false,
    this.isAirplaneMode = false,
    this.ringerMode = 'normal',
    this.appVersion,
    this.lastSyncAt,
    this.createdAt,
    this.updatedAt,
  }) : super._();

  factory _$RemoteSessionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RemoteSessionDataImplFromJson(json);

  @override
  final String? id;
  // UUID de la fila en la base de datos
  @override
  final String? userId;
  // UUID del usuario (opcional)
  @override
  final String deviceId;
  // Identificador único del dispositivo
  @override
  final String sessionId;
  // UUID de la sesión
  // Estado de la sesión
  @override
  final DateTime? activatedAt;
  @override
  @JsonKey()
  final int elapsedSeconds;
  @override
  @JsonKey()
  final int minutesTarget;
  @override
  @JsonKey()
  final bool isCustomMinutes;
  @override
  @JsonKey()
  final bool isActive;
  // Estado del dispositivo
  @override
  @JsonKey()
  final bool isDoNotDisturb;
  @override
  @JsonKey()
  final bool isAirplaneMode;
  @override
  @JsonKey()
  final String ringerMode;
  // Metadatos
  @override
  final String? appVersion;
  @override
  final DateTime? lastSyncAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RemoteSessionData(id: $id, userId: $userId, deviceId: $deviceId, sessionId: $sessionId, activatedAt: $activatedAt, elapsedSeconds: $elapsedSeconds, minutesTarget: $minutesTarget, isCustomMinutes: $isCustomMinutes, isActive: $isActive, isDoNotDisturb: $isDoNotDisturb, isAirplaneMode: $isAirplaneMode, ringerMode: $ringerMode, appVersion: $appVersion, lastSyncAt: $lastSyncAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoteSessionDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.activatedAt, activatedAt) ||
                other.activatedAt == activatedAt) &&
            (identical(other.elapsedSeconds, elapsedSeconds) ||
                other.elapsedSeconds == elapsedSeconds) &&
            (identical(other.minutesTarget, minutesTarget) ||
                other.minutesTarget == minutesTarget) &&
            (identical(other.isCustomMinutes, isCustomMinutes) ||
                other.isCustomMinutes == isCustomMinutes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isDoNotDisturb, isDoNotDisturb) ||
                other.isDoNotDisturb == isDoNotDisturb) &&
            (identical(other.isAirplaneMode, isAirplaneMode) ||
                other.isAirplaneMode == isAirplaneMode) &&
            (identical(other.ringerMode, ringerMode) ||
                other.ringerMode == ringerMode) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.lastSyncAt, lastSyncAt) ||
                other.lastSyncAt == lastSyncAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    deviceId,
    sessionId,
    activatedAt,
    elapsedSeconds,
    minutesTarget,
    isCustomMinutes,
    isActive,
    isDoNotDisturb,
    isAirplaneMode,
    ringerMode,
    appVersion,
    lastSyncAt,
    createdAt,
    updatedAt,
  );

  /// Create a copy of RemoteSessionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoteSessionDataImplCopyWith<_$RemoteSessionDataImpl> get copyWith =>
      __$$RemoteSessionDataImplCopyWithImpl<_$RemoteSessionDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RemoteSessionDataImplToJson(this);
  }
}

abstract class _RemoteSessionData extends RemoteSessionData {
  const factory _RemoteSessionData({
    final String? id,
    final String? userId,
    required final String deviceId,
    required final String sessionId,
    final DateTime? activatedAt,
    final int elapsedSeconds,
    final int minutesTarget,
    final bool isCustomMinutes,
    final bool isActive,
    final bool isDoNotDisturb,
    final bool isAirplaneMode,
    final String ringerMode,
    final String? appVersion,
    final DateTime? lastSyncAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$RemoteSessionDataImpl;
  const _RemoteSessionData._() : super._();

  factory _RemoteSessionData.fromJson(Map<String, dynamic> json) =
      _$RemoteSessionDataImpl.fromJson;

  @override
  String? get id; // UUID de la fila en la base de datos
  @override
  String? get userId; // UUID del usuario (opcional)
  @override
  String get deviceId; // Identificador único del dispositivo
  @override
  String get sessionId; // UUID de la sesión
  // Estado de la sesión
  @override
  DateTime? get activatedAt;
  @override
  int get elapsedSeconds;
  @override
  int get minutesTarget;
  @override
  bool get isCustomMinutes;
  @override
  bool get isActive; // Estado del dispositivo
  @override
  bool get isDoNotDisturb;
  @override
  bool get isAirplaneMode;
  @override
  String get ringerMode; // Metadatos
  @override
  String? get appVersion;
  @override
  DateTime? get lastSyncAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of RemoteSessionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoteSessionDataImplCopyWith<_$RemoteSessionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
