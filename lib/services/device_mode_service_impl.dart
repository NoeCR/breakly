import 'dart:async';
import 'package:flutter/services.dart';
import '../interfaces/device_mode_service.dart';

class DeviceModeServiceImpl implements DeviceModeService {
  static const EventChannel _events = EventChannel('device_modes/events');
  static const MethodChannel _methods = MethodChannel('device_modes/methods');

  @override
  Stream<Map<String, dynamic>> get deviceModeStream {
    return _events.receiveBroadcastStream().map((event) {
      return Map<String, dynamic>.from(event as Map);
    });
  }

  @override
  Future<bool> hasDoNotDisturbAccess() async {
    try {
      final result = await _methods.invokeMethod('hasDndAccess') as bool?;
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> setDoNotDisturb(bool enable) async {
    try {
      await _methods.invokeMethod('setDoNotDisturb', {'enable': enable});
    } catch (e) {
      // Handle error silently - no interrumpir la funcionalidad principal
    }
  }

  @override
  Future<void> toggleRinger(String mode) async {
    try {
      await _methods.invokeMethod('toggleRinger', {'mode': mode});
    } catch (e) {
      // Handle error silently - no interrumpir la funcionalidad principal
    }
  }

  @override
  Future<void> openDoNotDisturbSettings() async {
    try {
      await _methods.invokeMethod('openDoNotDisturbSettings');
    } catch (e) {
      // Handle error silently - no interrumpir la funcionalidad principal
    }
  }
}
