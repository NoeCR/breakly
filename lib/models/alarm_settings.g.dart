// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlarmSettingsImpl _$$AlarmSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AlarmSettingsImpl(
      isEnabled: json['isEnabled'] as bool? ?? true,
      soundUri: json['soundUri'] as String? ?? 'default',
      soundName: json['soundName'] as String? ?? 'Sonido por defecto',
      vibrate: json['vibrate'] as bool? ?? true,
      volume: (json['volume'] as num?)?.toInt() ?? 1,
      duration: (json['duration'] as num?)?.toInt() ?? 5,
    );

Map<String, dynamic> _$$AlarmSettingsImplToJson(_$AlarmSettingsImpl instance) =>
    <String, dynamic>{
      'isEnabled': instance.isEnabled,
      'soundUri': instance.soundUri,
      'soundName': instance.soundName,
      'vibrate': instance.vibrate,
      'volume': instance.volume,
      'duration': instance.duration,
    };
