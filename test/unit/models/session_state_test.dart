import 'package:flutter_test/flutter_test.dart';
import 'package:breakly/models/session_state.dart';

void main() {
  group('SessionState', () {
    test('should create default state', () {
      // Act
      const state = SessionState();

      // Assert
      expect(state.activatedAt, isNull);
      expect(state.elapsed, equals(Duration.zero));
      expect(state.minutesTarget, equals(30));
      expect(state.isCustomDuration, isFalse);
    });

    test('should create state with custom values', () {
      // Arrange
      final activatedAt = DateTime.now();
      const elapsed = Duration(minutes: 15);
      const minutesTarget = 60;
      const isCustomMinutes = true;

      // Act
      final state = SessionState(
        activatedAt: activatedAt,
        elapsed: elapsed,
        minutesTarget: minutesTarget,
        isCustomMinutes: isCustomMinutes,
      );

      // Assert
      expect(state.activatedAt, equals(activatedAt));
      expect(state.elapsed, equals(elapsed));
      expect(state.minutesTarget, equals(minutesTarget));
      expect(state.isCustomMinutes, equals(isCustomMinutes));
    });

    test('should copy with new values', () {
      // Arrange
      const originalState = SessionState();
      final newActivatedAt = DateTime.now();
      const newElapsed = Duration(minutes: 30);
      const newMinutesTarget = 90;

      // Act
      final newState = originalState.copyWith(
        activatedAt: newActivatedAt,
        elapsed: newElapsed,
        minutesTarget: newMinutesTarget,
        isCustomMinutes: true,
      );

      // Assert
      expect(newState.activatedAt, equals(newActivatedAt));
      expect(newState.elapsed, equals(newElapsed));
      expect(newState.minutesTarget, equals(newMinutesTarget));
      expect(newState.isCustomMinutes, isTrue);
    });

    test('should preserve original values when copying with null', () {
      // Arrange
      final activatedAt = DateTime.now();
      const elapsed = Duration(minutes: 20);
      final originalState = SessionState(
        activatedAt: activatedAt,
        elapsed: elapsed,
        minutesTarget: 45,
        isCustomMinutes: true,
      );

      // Act
      final newState = originalState.copyWith();

      // Assert
      expect(newState.activatedAt, equals(originalState.activatedAt));
      expect(newState.elapsed, equals(originalState.elapsed));
      expect(newState.minutesTarget, equals(originalState.minutesTarget));
      expect(newState.isCustomMinutes, equals(originalState.isCustomMinutes));
    });

    test('should check if session is active', () {
      // Test with active session
      final activeState = SessionState(activatedAt: DateTime.now());
      expect(activeState.isActive, isTrue);

      // Test with inactive session
      const inactiveState = SessionState(activatedAt: null);
      expect(inactiveState.isActive, isFalse);
    });

    test('should be immutable', () {
      // Arrange
      const state = SessionState();

      // Act & Assert
      expect(() => state.copyWith(), returnsNormally);
      expect(state, equals(const SessionState()));
    });

    test('should support equality', () {
      // Arrange
      final activatedAt = DateTime.now();
      final state1 = SessionState(
        activatedAt: activatedAt,
        elapsed: Duration(minutes: 15),
        minutesTarget: 60,
        isCustomMinutes: true,
      );
      final state2 = SessionState(
        activatedAt: activatedAt,
        elapsed: Duration(minutes: 15),
        minutesTarget: 60,
        isCustomMinutes: true,
      );
      const state3 = SessionState(
        activatedAt: null,
        elapsed: Duration(minutes: 15),
        minutesTarget: 60,
        isCustomMinutes: true,
      );

      // Assert
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
      expect(state1.hashCode, equals(state2.hashCode));
      expect(state1.hashCode, isNot(equals(state3.hashCode)));
    });

    test('should handle different target durations', () {
      // Test default duration
      const defaultState = SessionState();
      expect(defaultState.minutesTarget, equals(30));
      expect(defaultState.isCustomDuration, isFalse);

      // Test custom duration
      const customState = SessionState(
        minutesTarget: 120,
        isCustomMinutes: true,
      );
      expect(customState.minutesTarget, equals(120));
      expect(customState.isCustomDuration, isTrue);

      // Test standard duration
      const standardState = SessionState(
        minutesTarget: 60,
        isCustomMinutes: false,
      );
      expect(standardState.minutesTarget, equals(60));
      expect(standardState.isCustomDuration, isFalse);
    });

    test('should handle elapsed time calculations', () {
      // Arrange
      final startTime = DateTime.now().subtract(const Duration(minutes: 10));
      const elapsed = Duration(minutes: 10);

      // Act
      final state = SessionState(activatedAt: startTime, elapsed: elapsed);

      // Assert
      expect(state.activatedAt, equals(startTime));
      expect(state.elapsed, equals(elapsed));
      expect(state.isActive, isTrue);
    });
  });
}
