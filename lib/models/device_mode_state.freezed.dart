// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_mode_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DeviceModeState {
  bool get isDoNotDisturb => throw _privateConstructorUsedError;
  bool get isAirplaneMode => throw _privateConstructorUsedError;
  String get ringerMode => throw _privateConstructorUsedError;

  /// Create a copy of DeviceModeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceModeStateCopyWith<DeviceModeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceModeStateCopyWith<$Res> {
  factory $DeviceModeStateCopyWith(
    DeviceModeState value,
    $Res Function(DeviceModeState) then,
  ) = _$DeviceModeStateCopyWithImpl<$Res, DeviceModeState>;
  @useResult
  $Res call({bool isDoNotDisturb, bool isAirplaneMode, String ringerMode});
}

/// @nodoc
class _$DeviceModeStateCopyWithImpl<$Res, $Val extends DeviceModeState>
    implements $DeviceModeStateCopyWith<$Res> {
  _$DeviceModeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceModeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDoNotDisturb = null,
    Object? isAirplaneMode = null,
    Object? ringerMode = null,
  }) {
    return _then(
      _value.copyWith(
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeviceModeStateImplCopyWith<$Res>
    implements $DeviceModeStateCopyWith<$Res> {
  factory _$$DeviceModeStateImplCopyWith(
    _$DeviceModeStateImpl value,
    $Res Function(_$DeviceModeStateImpl) then,
  ) = __$$DeviceModeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isDoNotDisturb, bool isAirplaneMode, String ringerMode});
}

/// @nodoc
class __$$DeviceModeStateImplCopyWithImpl<$Res>
    extends _$DeviceModeStateCopyWithImpl<$Res, _$DeviceModeStateImpl>
    implements _$$DeviceModeStateImplCopyWith<$Res> {
  __$$DeviceModeStateImplCopyWithImpl(
    _$DeviceModeStateImpl _value,
    $Res Function(_$DeviceModeStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceModeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDoNotDisturb = null,
    Object? isAirplaneMode = null,
    Object? ringerMode = null,
  }) {
    return _then(
      _$DeviceModeStateImpl(
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
      ),
    );
  }
}

/// @nodoc

class _$DeviceModeStateImpl extends _DeviceModeState {
  const _$DeviceModeStateImpl({
    this.isDoNotDisturb = false,
    this.isAirplaneMode = false,
    this.ringerMode = 'normal',
  }) : super._();

  @override
  @JsonKey()
  final bool isDoNotDisturb;
  @override
  @JsonKey()
  final bool isAirplaneMode;
  @override
  @JsonKey()
  final String ringerMode;

  @override
  String toString() {
    return 'DeviceModeState(isDoNotDisturb: $isDoNotDisturb, isAirplaneMode: $isAirplaneMode, ringerMode: $ringerMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceModeStateImpl &&
            (identical(other.isDoNotDisturb, isDoNotDisturb) ||
                other.isDoNotDisturb == isDoNotDisturb) &&
            (identical(other.isAirplaneMode, isAirplaneMode) ||
                other.isAirplaneMode == isAirplaneMode) &&
            (identical(other.ringerMode, ringerMode) ||
                other.ringerMode == ringerMode));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isDoNotDisturb, isAirplaneMode, ringerMode);

  /// Create a copy of DeviceModeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceModeStateImplCopyWith<_$DeviceModeStateImpl> get copyWith =>
      __$$DeviceModeStateImplCopyWithImpl<_$DeviceModeStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DeviceModeState extends DeviceModeState {
  const factory _DeviceModeState({
    final bool isDoNotDisturb,
    final bool isAirplaneMode,
    final String ringerMode,
  }) = _$DeviceModeStateImpl;
  const _DeviceModeState._() : super._();

  @override
  bool get isDoNotDisturb;
  @override
  bool get isAirplaneMode;
  @override
  String get ringerMode;

  /// Create a copy of DeviceModeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceModeStateImplCopyWith<_$DeviceModeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
