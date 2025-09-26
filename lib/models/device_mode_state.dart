import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_mode_state.freezed.dart';

@freezed
class DeviceModeState with _$DeviceModeState {
  const factory DeviceModeState({
    @Default(false) bool isDoNotDisturb,
    @Default(false) bool isAirplaneMode,
    @Default('normal') String ringerMode,
  }) = _DeviceModeState;

  const DeviceModeState._();

  bool get isAnyModeActive =>
      isDoNotDisturb || isAirplaneMode || ringerMode == 'silent';
}

