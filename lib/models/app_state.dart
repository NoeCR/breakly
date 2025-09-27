import 'package:freezed_annotation/freezed_annotation.dart';
import 'device_mode_state.dart';
import 'session_state.dart';
import 'alarm_settings.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    @Default(DeviceModeState()) DeviceModeState deviceMode,
    @Default(SessionState()) SessionState session,
    @Default(AlarmSettings()) AlarmSettings alarmSettings,
    @Default(false) bool isVideoInitialized,
    @Default(false) bool isLoading,
    String? error,
  }) = _AppState;

  const AppState._();

  bool get isAnyModeActive => deviceMode.isAnyModeActive;
  bool get isSessionActive => session.isActive;
}
