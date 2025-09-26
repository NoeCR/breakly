// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SessionState {
  DateTime? get activatedAt => throw _privateConstructorUsedError;
  Duration get elapsed => throw _privateConstructorUsedError;
  int get minutesTarget => throw _privateConstructorUsedError;
  bool get isCustomMinutes => throw _privateConstructorUsedError;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionStateCopyWith<SessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionStateCopyWith<$Res> {
  factory $SessionStateCopyWith(
    SessionState value,
    $Res Function(SessionState) then,
  ) = _$SessionStateCopyWithImpl<$Res, SessionState>;
  @useResult
  $Res call({
    DateTime? activatedAt,
    Duration elapsed,
    int minutesTarget,
    bool isCustomMinutes,
  });
}

/// @nodoc
class _$SessionStateCopyWithImpl<$Res, $Val extends SessionState>
    implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activatedAt = freezed,
    Object? elapsed = null,
    Object? minutesTarget = null,
    Object? isCustomMinutes = null,
  }) {
    return _then(
      _value.copyWith(
            activatedAt:
                freezed == activatedAt
                    ? _value.activatedAt
                    : activatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            elapsed:
                null == elapsed
                    ? _value.elapsed
                    : elapsed // ignore: cast_nullable_to_non_nullable
                        as Duration,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionStateImplCopyWith<$Res>
    implements $SessionStateCopyWith<$Res> {
  factory _$$SessionStateImplCopyWith(
    _$SessionStateImpl value,
    $Res Function(_$SessionStateImpl) then,
  ) = __$$SessionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime? activatedAt,
    Duration elapsed,
    int minutesTarget,
    bool isCustomMinutes,
  });
}

/// @nodoc
class __$$SessionStateImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$SessionStateImpl>
    implements _$$SessionStateImplCopyWith<$Res> {
  __$$SessionStateImplCopyWithImpl(
    _$SessionStateImpl _value,
    $Res Function(_$SessionStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activatedAt = freezed,
    Object? elapsed = null,
    Object? minutesTarget = null,
    Object? isCustomMinutes = null,
  }) {
    return _then(
      _$SessionStateImpl(
        activatedAt:
            freezed == activatedAt
                ? _value.activatedAt
                : activatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        elapsed:
            null == elapsed
                ? _value.elapsed
                : elapsed // ignore: cast_nullable_to_non_nullable
                    as Duration,
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
      ),
    );
  }
}

/// @nodoc

class _$SessionStateImpl extends _SessionState {
  const _$SessionStateImpl({
    this.activatedAt,
    this.elapsed = Duration.zero,
    this.minutesTarget = 30,
    this.isCustomMinutes = false,
  }) : super._();

  @override
  final DateTime? activatedAt;
  @override
  @JsonKey()
  final Duration elapsed;
  @override
  @JsonKey()
  final int minutesTarget;
  @override
  @JsonKey()
  final bool isCustomMinutes;

  @override
  String toString() {
    return 'SessionState(activatedAt: $activatedAt, elapsed: $elapsed, minutesTarget: $minutesTarget, isCustomMinutes: $isCustomMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionStateImpl &&
            (identical(other.activatedAt, activatedAt) ||
                other.activatedAt == activatedAt) &&
            (identical(other.elapsed, elapsed) || other.elapsed == elapsed) &&
            (identical(other.minutesTarget, minutesTarget) ||
                other.minutesTarget == minutesTarget) &&
            (identical(other.isCustomMinutes, isCustomMinutes) ||
                other.isCustomMinutes == isCustomMinutes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activatedAt,
    elapsed,
    minutesTarget,
    isCustomMinutes,
  );

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionStateImplCopyWith<_$SessionStateImpl> get copyWith =>
      __$$SessionStateImplCopyWithImpl<_$SessionStateImpl>(this, _$identity);
}

abstract class _SessionState extends SessionState {
  const factory _SessionState({
    final DateTime? activatedAt,
    final Duration elapsed,
    final int minutesTarget,
    final bool isCustomMinutes,
  }) = _$SessionStateImpl;
  const _SessionState._() : super._();

  @override
  DateTime? get activatedAt;
  @override
  Duration get elapsed;
  @override
  int get minutesTarget;
  @override
  bool get isCustomMinutes;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionStateImplCopyWith<_$SessionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
