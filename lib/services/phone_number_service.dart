import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

/// Servicio para obtener y manejar el número de teléfono del dispositivo
/// Incluye funcionalidades de cifrado para mayor seguridad
class PhoneNumberService {
  static const MethodChannel _channel = MethodChannel('phone_number/methods');
  
  /// Clave secreta para el cifrado (en producción debería estar en variables de entorno)
  static const String _encryptionKey = 'breakly_phone_encryption_key_2024';
  
  /// Obtiene el número de teléfono del dispositivo
  /// Retorna null si no se puede obtener o no hay permisos
  static Future<String?> getPhoneNumber() async {
    try {
      if (Platform.isAndroid) {
        return await _getAndroidPhoneNumber();
      } else if (Platform.isIOS) {
        return await _getIOSPhoneNumber();
      }
      return null;
    } catch (e) {
      // En caso de error, retornar null
      return null;
    }
  }
  
  /// Obtiene el número de teléfono en Android
  static Future<String?> _getAndroidPhoneNumber() async {
    try {
      final result = await _channel.invokeMethod('getPhoneNumber') as String?;
      return result;
    } catch (e) {
      return null;
    }
  }
  
  /// Obtiene el número de teléfono en iOS
  static Future<String?> _getIOSPhoneNumber() async {
    try {
      final result = await _channel.invokeMethod('getPhoneNumber') as String?;
      return result;
    } catch (e) {
      return null;
    }
  }
  
  /// Cifra un número de teléfono usando SHA-256
  /// Retorna un hash hexadecimal del número de teléfono
  static String encryptPhoneNumber(String phoneNumber) {
    // Normalizar el número de teléfono (remover espacios, guiones, etc.)
    final normalizedPhone = _normalizePhoneNumber(phoneNumber);
    
    // Crear el hash usando la clave secreta + número de teléfono
    final bytes = utf8.encode('$_encryptionKey$normalizedPhone');
    final digest = sha256.convert(bytes);
    
    return digest.toString();
  }
  
  /// Normaliza un número de teléfono removiendo caracteres especiales
  static String _normalizePhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
  }
  
  /// Genera un user_id único basado en el número de teléfono cifrado
  /// Si no se puede obtener el número de teléfono, usa el device_id como fallback
  static Future<String> generateUserId(String deviceId) async {
    final phoneNumber = await getPhoneNumber();
    
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      return encryptPhoneNumber(phoneNumber);
    }
    
    // Fallback: usar device_id si no se puede obtener el número de teléfono
    return 'device_${deviceId.hashCode.abs()}';
  }
  
  /// Verifica si se puede obtener el número de teléfono
  static Future<bool> canAccessPhoneNumber() async {
    final phoneNumber = await getPhoneNumber();
    return phoneNumber != null && phoneNumber.isNotEmpty;
  }
  
  /// Obtiene información del dispositivo incluyendo número de teléfono (si está disponible)
  static Future<Map<String, String>> getDeviceInfo() async {
    final phoneNumber = await getPhoneNumber();
    final canAccess = await canAccessPhoneNumber();
    
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'locale': Platform.localeName,
      'has_phone_access': canAccess.toString(),
      'phone_encrypted': phoneNumber != null ? encryptPhoneNumber(phoneNumber) : 'not_available',
    };
  }
}
