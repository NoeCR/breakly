import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_settings.freezed.dart';
part 'alarm_settings.g.dart';

@freezed
class AlarmSettings with _$AlarmSettings {
  const factory AlarmSettings({
    @Default(true) bool isEnabled, // Si la alarma está habilitada
    @Default('default') String soundUri, // URI del sonido seleccionado
    @Default('Sonido por defecto') String soundName, // Nombre del sonido
    @Default(true) bool vibrate, // Si debe vibrar
    @Default(1) int volume, // Volumen de la alarma (0.0 - 1.0)
    @Default(5) int duration, // Duración en segundos
  }) = _AlarmSettings;

  factory AlarmSettings.fromJson(Map<String, dynamic> json) =>
      _$AlarmSettingsFromJson(json);

  const AlarmSettings._();

  /// Sonidos predefinidos del sistema
  static const List<AlarmSound> systemSounds = [
    AlarmSound(
      uri: 'default',
      name: 'Sonido por defecto',
      description: 'Sonido de notificación del sistema',
    ),
    AlarmSound(
      uri: 'alarm',
      name: 'Alarma',
      description: 'Sonido de alarma del sistema',
    ),
    AlarmSound(
      uri: 'notification',
      name: 'Notificación',
      description: 'Sonido de notificación',
    ),
    AlarmSound(
      uri: 'ringtone',
      name: 'Llamada',
      description: 'Sonido de llamada',
    ),
  ];

  /// Obtiene el sonido actual basado en el URI
  AlarmSound? get currentSound {
    return systemSounds.firstWhere(
      (sound) => sound.uri == soundUri,
      orElse: () => systemSounds.first,
    );
  }
}

/// Modelo para representar un sonido de alarma
@freezed
class AlarmSound with _$AlarmSound {
  const factory AlarmSound({
    required String uri,
    required String name,
    required String description,
  }) = _AlarmSound;
}
