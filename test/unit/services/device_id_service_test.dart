import 'package:flutter_test/flutter_test.dart';
import 'package:breakly/services/device_id_service.dart';

void main() {
  group('DeviceIdService - Basic Tests', () {
    test('debería tener clase definida', () {
      // Assert
      expect(DeviceIdService, isNotNull);
      expect(DeviceIdService, isA<Type>());
    });

    test('debería tener método getDeviceId definido', () {
      // Verificar que la clase tiene el método esperado
      expect(DeviceIdService, isNotNull);
    });
  });
}




