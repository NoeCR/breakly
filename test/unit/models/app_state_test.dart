import 'package:flutter_test/flutter_test.dart';
import 'package:breakly/models/app_state.dart';
import 'package:breakly/models/device_mode_state.dart';
import 'package:breakly/models/session_state.dart';

void main() {
  group('AppState', () {
    test('should create default state', () {
      // Act
      const state = AppState();

      // Assert
      expect(state.deviceMode, equals(const DeviceModeState()));
      expect(state.session, equals(const SessionState()));
      expect(state.isVideoInitialized, isFalse);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
    });

    test('should create state with custom values', () {
      // Arrange
      const deviceMode = DeviceModeState(isDoNotDisturb: true);
      const session = SessionState(minutesTarget: 60);
      const error = 'Test error';

      // Act
      const state = AppState(
        deviceMode: deviceMode,
        session: session,
        isVideoInitialized: true,
        isLoading: true,
        error: error,
      );

      // Assert
      expect(state.deviceMode, equals(deviceMode));
      expect(state.session, equals(session));
      expect(state.isVideoInitialized, isTrue);
      expect(state.isLoading, isTrue);
      expect(state.error, equals(error));
    });

    test('should copy with new values', () {
      // Arrange
      const originalState = AppState();
      const newDeviceMode = DeviceModeState(isAirplaneMode: true);
      const newSession = SessionState(minutesTarget: 90);

      // Act
      final newState = originalState.copyWith(
        deviceMode: newDeviceMode,
        session: newSession,
        isVideoInitialized: true,
        isLoading: true,
        error: 'New error',
      );

      // Assert
      expect(newState.deviceMode, equals(newDeviceMode));
      expect(newState.session, equals(newSession));
      expect(newState.isVideoInitialized, isTrue);
      expect(newState.isLoading, isTrue);
      expect(newState.error, equals('New error'));
    });

    test('should preserve original values when copying with null', () {
      // Arrange
      const originalState = AppState(
        deviceMode: DeviceModeState(isDoNotDisturb: true),
        session: SessionState(minutesTarget: 45),
        isVideoInitialized: true,
        isLoading: true,
        error: 'Original error',
      );

      // Act
      final newState = originalState.copyWith();

      // Assert
      expect(newState.deviceMode, equals(originalState.deviceMode));
      expect(newState.session, equals(originalState.session));
      expect(
        newState.isVideoInitialized,
        equals(originalState.isVideoInitialized),
      );
      expect(newState.isLoading, equals(originalState.isLoading));
      expect(newState.error, equals(originalState.error));
    });

    test('should check if any mode is active', () {
      // Test with DND active
      const stateWithDND = AppState(
        deviceMode: DeviceModeState(isDoNotDisturb: true),
      );
      expect(stateWithDND.isAnyModeActive, isTrue);

      // Test with airplane mode active
      const stateWithAirplane = AppState(
        deviceMode: DeviceModeState(isAirplaneMode: true),
      );
      expect(stateWithAirplane.isAnyModeActive, isTrue);

      // Test with silent ringer
      const stateWithSilent = AppState(
        deviceMode: DeviceModeState(ringerMode: 'silent'),
      );
      expect(stateWithSilent.isAnyModeActive, isTrue);

      // Test with no active modes
      const stateInactive = AppState(
        deviceMode: DeviceModeState(
          isDoNotDisturb: false,
          isAirplaneMode: false,
          ringerMode: 'normal',
        ),
      );
      expect(stateInactive.isAnyModeActive, isFalse);
    });

    test('should check if session is active', () {
      // Test with active session
      final activeState = AppState(
        session: SessionState(activatedAt: DateTime.now()),
      );
      expect(activeState.isSessionActive, isTrue);

      // Test with inactive session
      const inactiveState = AppState(session: SessionState(activatedAt: null));
      expect(inactiveState.isSessionActive, isFalse);
    });

    test('should be immutable', () {
      // Arrange
      const state = AppState();

      // Act & Assert
      expect(() => state.copyWith(), returnsNormally);
      expect(state, equals(const AppState()));
    });

    test('should support equality', () {
      // Arrange
      const state1 = AppState(
        deviceMode: DeviceModeState(isDoNotDisturb: true),
        session: SessionState(minutesTarget: 30),
      );
      const state2 = AppState(
        deviceMode: DeviceModeState(isDoNotDisturb: true),
        session: SessionState(minutesTarget: 30),
      );
      const state3 = AppState(
        deviceMode: DeviceModeState(isDoNotDisturb: false),
        session: SessionState(minutesTarget: 30),
      );

      // Assert
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
      expect(state1.hashCode, equals(state2.hashCode));
      expect(state1.hashCode, isNot(equals(state3.hashCode)));
    });
  });
}
