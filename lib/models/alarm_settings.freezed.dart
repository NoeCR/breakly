// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AlarmSettings _$AlarmSettingsFromJson(Map<String, dynamic> json) {
  return _AlarmSettings.fromJson(json);
}

/// @nodoc
mixin _$AlarmSettings {
  bool get isEnabled =>
      throw _privateConstructorUsedError; // Si la alarma está habilitada
  String get soundUri =>
      throw _privateConstructorUsedError; // URI del sonido seleccionado
  String get soundName =>
      throw _privateConstructorUsedError; // Nombre del sonido
  bool get vibrate => throw _privateConstructorUsedError; // Si debe vibrar
  int get volume =>
      throw _privateConstructorUsedError; // Volumen de la alarma (0.0 - 1.0)
  int get duration => throw _privateConstructorUsedError;

  /// Serializes this AlarmSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlarmSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlarmSettingsCopyWith<AlarmSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlarmSettingsCopyWith<$Res> {
  factory $AlarmSettingsCopyWith(
    AlarmSettings value,
    $Res Function(AlarmSettings) then,
  ) = _$AlarmSettingsCopyWithImpl<$Res, AlarmSettings>;
  @useResult
  $Res call({
    bool isEnabled,
    String soundUri,
    String soundName,
    bool vibrate,
    int volume,
    int duration,
  });
}

/// @nodoc
class _$AlarmSettingsCopyWithImpl<$Res, $Val extends AlarmSettings>
    implements $AlarmSettingsCopyWith<$Res> {
  _$AlarmSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlarmSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? soundUri = null,
    Object? soundName = null,
    Object? vibrate = null,
    Object? volume = null,
    Object? duration = null,
  }) {
    return _then(
      _value.copyWith(
            isEnabled:
                null == isEnabled
                    ? _value.isEnabled
                    : isEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            soundUri:
                null == soundUri
                    ? _value.soundUri
                    : soundUri // ignore: cast_nullable_to_non_nullable
                        as String,
            soundName:
                null == soundName
                    ? _value.soundName
                    : soundName // ignore: cast_nullable_to_non_nullable
                        as String,
            vibrate:
                null == vibrate
                    ? _value.vibrate
                    : vibrate // ignore: cast_nullable_to_non_nullable
                        as bool,
            volume:
                null == volume
                    ? _value.volume
                    : volume // ignore: cast_nullable_to_non_nullable
                        as int,
            duration:
                null == duration
                    ? _value.duration
                    : duration // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlarmSettingsImplCopyWith<$Res>
    implements $AlarmSettingsCopyWith<$Res> {
  factory _$$AlarmSettingsImplCopyWith(
    _$AlarmSettingsImpl value,
    $Res Function(_$AlarmSettingsImpl) then,
  ) = __$$AlarmSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isEnabled,
    String soundUri,
    String soundName,
    bool vibrate,
    int volume,
    int duration,
  });
}

/// @nodoc
class __$$AlarmSettingsImplCopyWithImpl<$Res>
    extends _$AlarmSettingsCopyWithImpl<$Res, _$AlarmSettingsImpl>
    implements _$$AlarmSettingsImplCopyWith<$Res> {
  __$$AlarmSettingsImplCopyWithImpl(
    _$AlarmSettingsImpl _value,
    $Res Function(_$AlarmSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlarmSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? soundUri = null,
    Object? soundName = null,
    Object? vibrate = null,
    Object? volume = null,
    Object? duration = null,
  }) {
    return _then(
      _$AlarmSettingsImpl(
        isEnabled:
            null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        soundUri:
            null == soundUri
                ? _value.soundUri
                : soundUri // ignore: cast_nullable_to_non_nullable
                    as String,
        soundName:
            null == soundName
                ? _value.soundName
                : soundName // ignore: cast_nullable_to_non_nullable
                    as String,
        vibrate:
            null == vibrate
                ? _value.vibrate
                : vibrate // ignore: cast_nullable_to_non_nullable
                    as bool,
        volume:
            null == volume
                ? _value.volume
                : volume // ignore: cast_nullable_to_non_nullable
                    as int,
        duration:
            null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlarmSettingsImpl extends _AlarmSettings {
  const _$AlarmSettingsImpl({
    this.isEnabled = true,
    this.soundUri = 'default',
    this.soundName = 'Sonido por defecto',
    this.vibrate = true,
    this.volume = 1,
    this.duration = 5,
  }) : super._();

  factory _$AlarmSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlarmSettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool isEnabled;
  // Si la alarma está habilitada
  @override
  @JsonKey()
  final String soundUri;
  // URI del sonido seleccionado
  @override
  @JsonKey()
  final String soundName;
  // Nombre del sonido
  @override
  @JsonKey()
  final bool vibrate;
  // Si debe vibrar
  @override
  @JsonKey()
  final int volume;
  // Volumen de la alarma (0.0 - 1.0)
  @override
  @JsonKey()
  final int duration;

  @override
  String toString() {
    return 'AlarmSettings(isEnabled: $isEnabled, soundUri: $soundUri, soundName: $soundName, vibrate: $vibrate, volume: $volume, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlarmSettingsImpl &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.soundUri, soundUri) ||
                other.soundUri == soundUri) &&
            (identical(other.soundName, soundName) ||
                other.soundName == soundName) &&
            (identical(other.vibrate, vibrate) || other.vibrate == vibrate) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isEnabled,
    soundUri,
    soundName,
    vibrate,
    volume,
    duration,
  );

  /// Create a copy of AlarmSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlarmSettingsImplCopyWith<_$AlarmSettingsImpl> get copyWith =>
      __$$AlarmSettingsImplCopyWithImpl<_$AlarmSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlarmSettingsImplToJson(this);
  }
}

abstract class _AlarmSettings extends AlarmSettings {
  const factory _AlarmSettings({
    final bool isEnabled,
    final String soundUri,
    final String soundName,
    final bool vibrate,
    final int volume,
    final int duration,
  }) = _$AlarmSettingsImpl;
  const _AlarmSettings._() : super._();

  factory _AlarmSettings.fromJson(Map<String, dynamic> json) =
      _$AlarmSettingsImpl.fromJson;

  @override
  bool get isEnabled; // Si la alarma está habilitada
  @override
  String get soundUri; // URI del sonido seleccionado
  @override
  String get soundName; // Nombre del sonido
  @override
  bool get vibrate; // Si debe vibrar
  @override
  int get volume; // Volumen de la alarma (0.0 - 1.0)
  @override
  int get duration;

  /// Create a copy of AlarmSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlarmSettingsImplCopyWith<_$AlarmSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AlarmSound {
  String get uri => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Create a copy of AlarmSound
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlarmSoundCopyWith<AlarmSound> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlarmSoundCopyWith<$Res> {
  factory $AlarmSoundCopyWith(
    AlarmSound value,
    $Res Function(AlarmSound) then,
  ) = _$AlarmSoundCopyWithImpl<$Res, AlarmSound>;
  @useResult
  $Res call({String uri, String name, String description});
}

/// @nodoc
class _$AlarmSoundCopyWithImpl<$Res, $Val extends AlarmSound>
    implements $AlarmSoundCopyWith<$Res> {
  _$AlarmSoundCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlarmSound
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uri = null,
    Object? name = null,
    Object? description = null,
  }) {
    return _then(
      _value.copyWith(
            uri:
                null == uri
                    ? _value.uri
                    : uri // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlarmSoundImplCopyWith<$Res>
    implements $AlarmSoundCopyWith<$Res> {
  factory _$$AlarmSoundImplCopyWith(
    _$AlarmSoundImpl value,
    $Res Function(_$AlarmSoundImpl) then,
  ) = __$$AlarmSoundImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uri, String name, String description});
}

/// @nodoc
class __$$AlarmSoundImplCopyWithImpl<$Res>
    extends _$AlarmSoundCopyWithImpl<$Res, _$AlarmSoundImpl>
    implements _$$AlarmSoundImplCopyWith<$Res> {
  __$$AlarmSoundImplCopyWithImpl(
    _$AlarmSoundImpl _value,
    $Res Function(_$AlarmSoundImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlarmSound
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uri = null,
    Object? name = null,
    Object? description = null,
  }) {
    return _then(
      _$AlarmSoundImpl(
        uri:
            null == uri
                ? _value.uri
                : uri // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$AlarmSoundImpl implements _AlarmSound {
  const _$AlarmSoundImpl({
    required this.uri,
    required this.name,
    required this.description,
  });

  @override
  final String uri;
  @override
  final String name;
  @override
  final String description;

  @override
  String toString() {
    return 'AlarmSound(uri: $uri, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlarmSoundImpl &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uri, name, description);

  /// Create a copy of AlarmSound
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlarmSoundImplCopyWith<_$AlarmSoundImpl> get copyWith =>
      __$$AlarmSoundImplCopyWithImpl<_$AlarmSoundImpl>(this, _$identity);
}

abstract class _AlarmSound implements AlarmSound {
  const factory _AlarmSound({
    required final String uri,
    required final String name,
    required final String description,
  }) = _$AlarmSoundImpl;

  @override
  String get uri;
  @override
  String get name;
  @override
  String get description;

  /// Create a copy of AlarmSound
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlarmSoundImplCopyWith<_$AlarmSoundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
