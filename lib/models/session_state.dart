import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_state.freezed.dart';

@freezed
class SessionState with _$SessionState {
  const factory SessionState({
    DateTime? activatedAt,
    @Default(Duration.zero) Duration elapsed,
    @Default(30) int minutesTarget,
    @Default(false) bool isCustomMinutes,
  }) = _SessionState;

  const SessionState._();

  bool get isActive => activatedAt != null;

  String get formattedElapsed {
    return elapsed.toString().split('.').first.padLeft(8, '0');
  }

  String get formattedEndTime {
    final base = activatedAt ?? DateTime.now();
    final end = base.add(Duration(minutes: minutesTarget));
    final hh = end.hour.toString().padLeft(2, '0');
    final mm = end.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  bool get isCustomDuration => !const {30, 60, 90}.contains(minutesTarget);
}

