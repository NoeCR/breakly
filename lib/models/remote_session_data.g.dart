// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_session_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RemoteSessionDataImpl _$$RemoteSessionDataImplFromJson(
  Map<String, dynamic> json,
) => _$RemoteSessionDataImpl(
  id: json['id'] as String?,
  userId: json['userId'] as String,
  deviceId: json['deviceId'] as String,
  sessionId: json['sessionId'] as String,
  activatedAt:
      json['activatedAt'] == null
          ? null
          : DateTime.parse(json['activatedAt'] as String),
  elapsedSeconds: (json['elapsedSeconds'] as num?)?.toInt() ?? 0,
  minutesTarget: (json['minutesTarget'] as num?)?.toInt() ?? 30,
  isCustomMinutes: json['isCustomMinutes'] as bool? ?? false,
  isActive: json['isActive'] as bool? ?? false,
  isDoNotDisturb: json['isDoNotDisturb'] as bool? ?? false,
  isAirplaneMode: json['isAirplaneMode'] as bool? ?? false,
  ringerMode: json['ringerMode'] as String? ?? 'normal',
  appVersion: json['appVersion'] as String?,
  phoneNumberAvailable: json['phoneNumberAvailable'] as bool? ?? false,
  lastSyncAt:
      json['lastSyncAt'] == null
          ? null
          : DateTime.parse(json['lastSyncAt'] as String),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$RemoteSessionDataImplToJson(
  _$RemoteSessionDataImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'deviceId': instance.deviceId,
  'sessionId': instance.sessionId,
  'activatedAt': instance.activatedAt?.toIso8601String(),
  'elapsedSeconds': instance.elapsedSeconds,
  'minutesTarget': instance.minutesTarget,
  'isCustomMinutes': instance.isCustomMinutes,
  'isActive': instance.isActive,
  'isDoNotDisturb': instance.isDoNotDisturb,
  'isAirplaneMode': instance.isAirplaneMode,
  'ringerMode': instance.ringerMode,
  'appVersion': instance.appVersion,
  'phoneNumberAvailable': instance.phoneNumberAvailable,
  'lastSyncAt': instance.lastSyncAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
