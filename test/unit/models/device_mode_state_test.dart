import 'package:flutter_test/flutter_test.dart';
import 'package:breakly/models/device_mode_state.dart';

void main() {
  group('DeviceModeState', () {
    test('should create default state', () {
      // Act
      const state = DeviceModeState();

      // Assert
      expect(state.isDoNotDisturb, isFalse);
      expect(state.isAirplaneMode, isFalse);
      expect(state.ringerMode, equals('normal'));
    });

    test('should create state with custom values', () {
      // Act
      const state = DeviceModeState(
        isDoNotDisturb: true,
        isAirplaneMode: true,
        ringerMode: 'silent',
      );

      // Assert
      expect(state.isDoNotDisturb, isTrue);
      expect(state.isAirplaneMode, isTrue);
      expect(state.ringerMode, equals('silent'));
    });

    test('should copy with new values', () {
      // Arrange
      const originalState = DeviceModeState();

      // Act
      final newState = originalState.copyWith(
        isDoNotDisturb: true,
        isAirplaneMode: true,
        ringerMode: 'vibrate',
      );

      // Assert
      expect(newState.isDoNotDisturb, isTrue);
      expect(newState.isAirplaneMode, isTrue);
      expect(newState.ringerMode, equals('vibrate'));
    });

    test('should preserve original values when copying with null', () {
      // Arrange
      const originalState = DeviceModeState(
        isDoNotDisturb: true,
        isAirplaneMode: false,
        ringerMode: 'silent',
      );

      // Act
      final newState = originalState.copyWith();

      // Assert
      expect(newState.isDoNotDisturb, equals(originalState.isDoNotDisturb));
      expect(newState.isAirplaneMode, equals(originalState.isAirplaneMode));
      expect(newState.ringerMode, equals(originalState.ringerMode));
    });

    test('should check if any mode is active', () {
      // Test with DND active
      const stateWithDND = DeviceModeState(isDoNotDisturb: true);
      expect(stateWithDND.isAnyModeActive, isTrue);

      // Test with airplane mode active
      const stateWithAirplane = DeviceModeState(isAirplaneMode: true);
      expect(stateWithAirplane.isAnyModeActive, isTrue);

      // Test with silent ringer
      const stateWithSilent = DeviceModeState(ringerMode: 'silent');
      expect(stateWithSilent.isAnyModeActive, isTrue);

      // Test with vibrate ringer (not considered active in current implementation)
      const stateWithVibrate = DeviceModeState(ringerMode: 'vibrate');
      expect(stateWithVibrate.isAnyModeActive, isFalse);

      // Test with no active modes
      const stateInactive = DeviceModeState(
        isDoNotDisturb: false,
        isAirplaneMode: false,
        ringerMode: 'normal',
      );
      expect(stateInactive.isAnyModeActive, isFalse);
    });

    test('should be immutable', () {
      // Arrange
      const state = DeviceModeState();

      // Act & Assert
      expect(() => state.copyWith(), returnsNormally);
      expect(state, equals(const DeviceModeState()));
    });

    test('should support equality', () {
      // Arrange
      const state1 = DeviceModeState(
        isDoNotDisturb: true,
        isAirplaneMode: false,
        ringerMode: 'silent',
      );
      const state2 = DeviceModeState(
        isDoNotDisturb: true,
        isAirplaneMode: false,
        ringerMode: 'silent',
      );
      const state3 = DeviceModeState(
        isDoNotDisturb: false,
        isAirplaneMode: false,
        ringerMode: 'silent',
      );

      // Assert
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
      expect(state1.hashCode, equals(state2.hashCode));
      expect(state1.hashCode, isNot(equals(state3.hashCode)));
    });

    test('should handle different ringer modes', () {
      // Test normal mode
      const normalState = DeviceModeState(ringerMode: 'normal');
      expect(normalState.isAnyModeActive, isFalse);

      // Test silent mode
      const silentState = DeviceModeState(ringerMode: 'silent');
      expect(silentState.isAnyModeActive, isTrue);

      // Test vibrate mode (not considered active in current implementation)
      const vibrateState = DeviceModeState(ringerMode: 'vibrate');
      expect(vibrateState.isAnyModeActive, isFalse);

      // Test unknown mode
      const unknownState = DeviceModeState(ringerMode: 'unknown');
      expect(unknownState.isAnyModeActive, isFalse);
    });
  });
}
