import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para obtener un identificador único del dispositivo
/// Utiliza SharedPreferences para persistir el ID entre sesiones
class DeviceIdService {
  static const String _deviceIdKey = 'device_id';
  static const String _deviceIdPrefix = 'breakly_device_';

  /// Obtiene el ID único del dispositivo
  /// Si no existe, crea uno nuevo y lo persiste
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);

    if (deviceId == null) {
      deviceId = await _generateDeviceId();
      await prefs.setString(_deviceIdKey, deviceId);
    }

    return deviceId;
  }

  /// Genera un nuevo ID único del dispositivo
  static Future<String> _generateDeviceId() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final platform = Platform.operatingSystem;
    final random = (timestamp % 100000).toString().padLeft(5, '0');

    return '$_deviceIdPrefix${platform}_${timestamp}_$random';
  }

  /// Regenera el ID del dispositivo (útil para testing o reset)
  static Future<String> regenerateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final newDeviceId = await _generateDeviceId();
    await prefs.setString(_deviceIdKey, newDeviceId);
    return newDeviceId;
  }

  /// Obtiene información adicional del dispositivo
  static Future<Map<String, String>> getDeviceInfo() async {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'locale': Platform.localeName,
    };
  }
}
