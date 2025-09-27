import 'package:flutter_test/flutter_test.dart';
import 'package:breakly/services/phone_number_service.dart';

void main() {
  group('PhoneNumberService - Pruebas Simples', () {
    test('debería generar userId con fallback cuando no hay teléfono', () async {
      // Act
      final userId = await PhoneNumberService.generateUserId('test_device_123');

      // Assert
      expect(userId, startsWith('device_'));
      expect(userId, isNotEmpty);
    });

    test('debería cifrar números de teléfono de forma consistente', () {
      // Arrange
      const phoneNumber = '+34123456789';

      // Act
      final encrypted1 = PhoneNumberService.encryptPhoneNumber(phoneNumber);
      final encrypted2 = PhoneNumberService.encryptPhoneNumber(phoneNumber);

      // Assert
      expect(encrypted1, equals(encrypted2));
      expect(encrypted1, isNotEmpty);
      expect(encrypted1.length, greaterThan(10)); // SHA-256 hash length
    });

    test('debería normalizar números de teléfono', () {
      // Arrange
      const testCases = [
        '+34 123 456 789',
        '123-456-789',
        '(123) 456-789',
        '123.456.789',
      ];

      for (final phoneNumber in testCases) {
        // Act
        final result = PhoneNumberService.encryptPhoneNumber(phoneNumber);

        // Assert
        expect(result, isNotEmpty);
        expect(result, isA<String>());
      }
    });

    test('debería verificar acceso al número de teléfono', () async {
      // Act
      final canAccess = await PhoneNumberService.canAccessPhoneNumber();

      // Assert
      expect(canAccess, isA<bool>());
    });

    test('debería obtener información del dispositivo', () async {
      // Act
      final deviceInfo = await PhoneNumberService.getDeviceInfo();

      // Assert
      expect(deviceInfo, isA<Map<String, String>>());
      expect(deviceInfo['platform'], isNotEmpty);
      expect(deviceInfo['has_phone_access'], isA<String>());
    });
  });
}




