import 'package:flutter_test/flutter_test.dart';
import 'package:breakly/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('debería tener constantes de notificación definidas', () {
      // Assert
      expect(AppConstants.notificationChannelId, isNotEmpty);
      expect(AppConstants.notificationChannelName, isNotEmpty);
      expect(AppConstants.notificationChannelDescription, isNotEmpty);
    });

    test('debería tener claves de preferencias definidas', () {
      // Assert
      expect(AppConstants.minutesTargetKey, isNotEmpty);
      expect(AppConstants.activeSessionStartedAtKey, isNotEmpty);
    });

    test('debería tener duraciones predefinidas', () {
      // Assert
      expect(AppConstants.defaultSessionDurations, isNotEmpty);
      expect(AppConstants.defaultSessionDurations.length, greaterThan(0));
      
      // Verificar que todas las duraciones son positivas
      for (final duration in AppConstants.defaultSessionDurations) {
        expect(duration, greaterThan(0));
      }
    });

    test('debería tener configuración de video definida', () {
      // Assert
      expect(AppConstants.videoAssetPath, isNotEmpty);
      expect(AppConstants.videoAssetPath, endsWith('.mp4'));
    });

    test('debería tener configuración de validación', () {
      // Assert
      expect(AppConstants.minSessionDuration, greaterThan(0));
      expect(AppConstants.maxSessionDuration, greaterThan(AppConstants.minSessionDuration));
    });

    test('debería tener configuración de tiempo', () {
      // Assert
      expect(AppConstants.defaultTimeout, isA<Duration>());
      expect(AppConstants.shortTimeout, isA<Duration>());
      expect(AppConstants.longTimeout, isA<Duration>());
    });
  });
}
