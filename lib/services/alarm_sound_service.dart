import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmSoundService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isPlaying = false;

  /// Reproduce el sonido de alarma configurado
  static Future<void> playAlarmSound({
    required String soundUri,
    required int duration,
    required double volume,
  }) async {
    try {
      if (kDebugMode) {
        print('🔊 [AlarmSoundService] Starting alarm sound playback');
        print('🔊 [AlarmSoundService] Sound URI: $soundUri');
        print('🔊 [AlarmSoundService] Duration: $duration seconds');
        print('🔊 [AlarmSoundService] Volume: $volume');
      }

      // Verificar permisos antes de reproducir
      final hasPermissions = await hasAudioPermissions();
      if (kDebugMode) {
        print('🔊 [AlarmSoundService] Has audio permissions: $hasPermissions');
      }

      if (!hasPermissions) {
        if (kDebugMode) {
          print('⚠️ [AlarmSoundService] Requesting audio permissions...');
        }
        final granted = await requestAudioPermissions();
        if (kDebugMode) {
          print('🔊 [AlarmSoundService] Audio permissions granted: $granted');
        }
      }

      // Detener cualquier sonido que esté reproduciéndose
      await stopAlarmSound();

      // Reproducir el sonido específico seleccionado
      await _playSystemSound(soundUri);

      // Activar vibración
      await triggerVibration(duration: 2000);

      // Programar parada automática después de la duración especificada
      if (duration > 0) {
        Future.delayed(Duration(seconds: duration), () {
          if (kDebugMode) {
            print(
              '🔊 [AlarmSoundService] Auto-stopping alarm after $duration seconds',
            );
          }
          stopAlarmSound();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ [AlarmSoundService] Error playing alarm sound: $e');
      }
      // Fallback al sonido por defecto
      if (kDebugMode) {
        print('🔊 [AlarmSoundService] Trying fallback to default sound...');
      }
      await _playSystemSound('default');
    }
  }

  /// Reproduce el sonido del sistema
  static Future<void> _playSystemSound(String soundUri) async {
    try {
      if (kDebugMode) {
        print(
          '🔊 [AlarmSoundService] Calling native method to play sound: $soundUri',
        );
      }

      // Usar el canal de método para reproducir sonido del sistema
      const platform = MethodChannel('alarm_sound/methods');
      final result = await platform.invokeMethod('playSystemSound', {
        'soundUri': soundUri,
      });

      if (kDebugMode) {
        print('🔊 [AlarmSoundService] Native method result: $result');
        if (result == true) {
          print('✅ [AlarmSoundService] Sound playback initiated successfully');
        } else {
          print('❌ [AlarmSoundService] Sound playback failed');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ [AlarmSoundService] Error playing system sound: $e');
        print('❌ [AlarmSoundService] Error type: ${e.runtimeType}');
        if (e is PlatformException) {
          print('❌ [AlarmSoundService] Platform error code: ${e.code}');
          print('❌ [AlarmSoundService] Platform error message: ${e.message}');
        }
      }
    }
  }

  /// Detiene el sonido de alarma
  static Future<void> stopAlarmSound() async {
    try {
      // Parar el sonido del sistema
      const platform = MethodChannel('alarm_sound/methods');
      await platform.invokeMethod('stopSystemSound');

      // También parar el audio player si está reproduciéndose
      if (_isPlaying) {
        await _audioPlayer.stop();
        _isPlaying = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping alarm sound: $e');
      }
    }
  }

  /// Activa la vibración del dispositivo
  static Future<void> triggerVibration({int duration = 1000}) async {
    try {
      if (kDebugMode) {
        print('📳 [AlarmSoundService] Triggering vibration for $duration ms');
      }

      const platform = MethodChannel('alarm_sound/methods');
      final result = await platform.invokeMethod('triggerVibration', {
        'duration': duration,
      });

      if (kDebugMode) {
        print('📳 [AlarmSoundService] Vibration result: $result');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ [AlarmSoundService] Error triggering vibration: $e');
      }
    }
  }

  /// Verifica si hay permisos para reproducir sonidos
  static Future<bool> hasAudioPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      return status.isGranted;
    }
    return true; // iOS no requiere permisos especiales para audio
  }

  /// Solicita permisos para reproducir sonidos
  static Future<bool> requestAudioPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }

  /// Obtiene la lista de sonidos disponibles del sistema
  static Future<List<Map<String, String>>> getSystemSounds() async {
    try {
      const platform = MethodChannel('alarm_sound/methods');
      final List<dynamic> sounds = await platform.invokeMethod(
        'getSystemSounds',
      );
      return sounds.cast<Map<String, String>>();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting system sounds: $e');
      }
      // Retornar sonidos por defecto
      return [
        {'uri': 'default', 'name': 'Sonido por defecto'},
        {'uri': 'alarm', 'name': 'Alarma'},
        {'uri': 'notification', 'name': 'Notificación'},
      ];
    }
  }

  /// Verifica si el servicio está reproduciendo sonido
  static bool get isPlaying => _isPlaying;
}
