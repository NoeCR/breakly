import 'package:flutter_test/flutter_test.dart';
import 'package:breakly/services/device_mode_service_impl.dart';

void main() {
  group('DeviceModeServiceImpl - Basic Tests', () {
    late DeviceModeServiceImpl deviceModeService;

    setUp(() {
      deviceModeService = DeviceModeServiceImpl();
    });

    test('debería crear instancia correctamente', () {
      // Assert
      expect(deviceModeService, isNotNull);
      expect(deviceModeService, isA<DeviceModeServiceImpl>());
    });

    test('debería manejar setDoNotDisturb sin errores', () async {
      // Act & Assert
      expect(
        () => deviceModeService.setDoNotDisturb(true),
        returnsNormally,
      );
    });

    test('debería manejar toggleRinger sin errores', () async {
      // Act & Assert
      expect(
        () => deviceModeService.toggleRinger('silent'),
        returnsNormally,
      );
    });

    test('debería manejar openDoNotDisturbSettings sin errores', () async {
      // Act & Assert
      expect(
        () => deviceModeService.openDoNotDisturbSettings(),
        returnsNormally,
      );
    });

    test('debería obtener stream de modo de dispositivo', () {
      // Act
      final stream = deviceModeService.deviceModeStream;

      // Assert
      expect(stream, isNotNull);
      expect(stream, isA<Stream<Map<String, dynamic>>>());
    });
  });
}
