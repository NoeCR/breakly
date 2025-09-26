// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppState {
  DeviceModeState get deviceMode => throw _privateConstructorUsedError;
  SessionState get session => throw _privateConstructorUsedError;
  bool get isVideoInitialized => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppStateCopyWith<AppState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) then) =
      _$AppStateCopyWithImpl<$Res, AppState>;
  @useResult
  $Res call({
    DeviceModeState deviceMode,
    SessionState session,
    bool isVideoInitialized,
    bool isLoading,
    String? error,
  });

  $DeviceModeStateCopyWith<$Res> get deviceMode;
  $SessionStateCopyWith<$Res> get session;
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res, $Val extends AppState>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceMode = null,
    Object? session = null,
    Object? isVideoInitialized = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            deviceMode:
                null == deviceMode
                    ? _value.deviceMode
                    : deviceMode // ignore: cast_nullable_to_non_nullable
                        as DeviceModeState,
            session:
                null == session
                    ? _value.session
                    : session // ignore: cast_nullable_to_non_nullable
                        as SessionState,
            isVideoInitialized:
                null == isVideoInitialized
                    ? _value.isVideoInitialized
                    : isVideoInitialized // ignore: cast_nullable_to_non_nullable
                        as bool,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeviceModeStateCopyWith<$Res> get deviceMode {
    return $DeviceModeStateCopyWith<$Res>(_value.deviceMode, (value) {
      return _then(_value.copyWith(deviceMode: value) as $Val);
    });
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionStateCopyWith<$Res> get session {
    return $SessionStateCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppStateImplCopyWith<$Res>
    implements $AppStateCopyWith<$Res> {
  factory _$$AppStateImplCopyWith(
    _$AppStateImpl value,
    $Res Function(_$AppStateImpl) then,
  ) = __$$AppStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DeviceModeState deviceMode,
    SessionState session,
    bool isVideoInitialized,
    bool isLoading,
    String? error,
  });

  @override
  $DeviceModeStateCopyWith<$Res> get deviceMode;
  @override
  $SessionStateCopyWith<$Res> get session;
}

/// @nodoc
class __$$AppStateImplCopyWithImpl<$Res>
    extends _$AppStateCopyWithImpl<$Res, _$AppStateImpl>
    implements _$$AppStateImplCopyWith<$Res> {
  __$$AppStateImplCopyWithImpl(
    _$AppStateImpl _value,
    $Res Function(_$AppStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceMode = null,
    Object? session = null,
    Object? isVideoInitialized = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _$AppStateImpl(
        deviceMode:
            null == deviceMode
                ? _value.deviceMode
                : deviceMode // ignore: cast_nullable_to_non_nullable
                    as DeviceModeState,
        session:
            null == session
                ? _value.session
                : session // ignore: cast_nullable_to_non_nullable
                    as SessionState,
        isVideoInitialized:
            null == isVideoInitialized
                ? _value.isVideoInitialized
                : isVideoInitialized // ignore: cast_nullable_to_non_nullable
                    as bool,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$AppStateImpl extends _AppState {
  const _$AppStateImpl({
    this.deviceMode = const DeviceModeState(),
    this.session = const SessionState(),
    this.isVideoInitialized = false,
    this.isLoading = false,
    this.error,
  }) : super._();

  @override
  @JsonKey()
  final DeviceModeState deviceMode;
  @override
  @JsonKey()
  final SessionState session;
  @override
  @JsonKey()
  final bool isVideoInitialized;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'AppState(deviceMode: $deviceMode, session: $session, isVideoInitialized: $isVideoInitialized, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppStateImpl &&
            (identical(other.deviceMode, deviceMode) ||
                other.deviceMode == deviceMode) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.isVideoInitialized, isVideoInitialized) ||
                other.isVideoInitialized == isVideoInitialized) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    deviceMode,
    session,
    isVideoInitialized,
    isLoading,
    error,
  );

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppStateImplCopyWith<_$AppStateImpl> get copyWith =>
      __$$AppStateImplCopyWithImpl<_$AppStateImpl>(this, _$identity);
}

abstract class _AppState extends AppState {
  const factory _AppState({
    final DeviceModeState deviceMode,
    final SessionState session,
    final bool isVideoInitialized,
    final bool isLoading,
    final String? error,
  }) = _$AppStateImpl;
  const _AppState._() : super._();

  @override
  DeviceModeState get deviceMode;
  @override
  SessionState get session;
  @override
  bool get isVideoInitialized;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppStateImplCopyWith<_$AppStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
