import 'package:flutter_test/flutter_test.dart';
import 'package:breakly/models/app_state.dart';
import 'package:breakly/models/session_state.dart';
import 'package:breakly/models/device_mode_state.dart';

void main() {
  group('AppState', () {
    test('debería crear estado inicial correctamente', () {
      // Act
      const appState = AppState();

      // Assert
      expect(appState.isLoading, isFalse);
      expect(appState.error, isNull);
      expect(appState.isVideoInitialized, isFalse);
      expect(appState.session.minutesTarget, equals(30));
      expect(appState.session.isActive, isFalse);
      expect(appState.deviceMode.isDoNotDisturb, isFalse);
    });

    test('debería copiar estado con nuevos valores', () {
      // Arrange
      const appState = AppState();

      // Act
      final newState = appState.copyWith(
        isLoading: true,
        error: 'Test error',
      );

      // Assert
      expect(newState.isLoading, isTrue);
      expect(newState.error, equals('Test error'));
      expect(newState.isVideoInitialized, isFalse); // No cambió
    });

    test('debería verificar si la sesión está activa', () {
      // Arrange
      const inactiveState = AppState();
      final activeState = AppState().copyWith(
        session: const SessionState().copyWith(
          activatedAt: DateTime.now(),
        ),
      );

      // Assert
      expect(inactiveState.isSessionActive, isFalse);
      expect(activeState.isSessionActive, isTrue);
    });
  });

  group('SessionState', () {
    test('debería crear sesión inicial correctamente', () {
      // Act
      const session = SessionState();

      // Assert
      expect(session.minutesTarget, equals(30));
      expect(session.isActive, isFalse);
      expect(session.activatedAt, isNull);
      expect(session.isCustomMinutes, isFalse);
    });

    test('debería manejar tiempo transcurrido correctamente', () {
      // Arrange
      const session = SessionState(
        elapsed: Duration(minutes: 5),
      );

      // Act
      final elapsed = session.elapsed;

      // Assert
      expect(elapsed.inMinutes, equals(5));
    });
  });

  group('DeviceModeState', () {
    test('debería crear estado de dispositivo inicial correctamente', () {
      // Act
      const deviceMode = DeviceModeState();

      // Assert
      expect(deviceMode.isDoNotDisturb, isFalse);
      expect(deviceMode.isAirplaneMode, isFalse);
      expect(deviceMode.ringerMode, equals('normal'));
    });

    test('debería copiar estado con nuevos valores', () {
      // Arrange
      const deviceMode = DeviceModeState();

      // Act
      final newMode = deviceMode.copyWith(
        isDoNotDisturb: true,
        ringerMode: 'silent',
      );

      // Assert
      expect(newMode.isDoNotDisturb, isTrue);
      expect(newMode.ringerMode, equals('silent'));
      expect(newMode.isAirplaneMode, isFalse); // No cambió
    });
  });
}