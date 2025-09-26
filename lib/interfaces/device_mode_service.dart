abstract class DeviceModeService {
  Stream<Map<String, dynamic>> get deviceModeStream;
  Future<bool> hasDoNotDisturbAccess();
  Future<void> setDoNotDisturb(bool enable);
  Future<void> toggleRinger(String mode);
  Future<void> openDoNotDisturbSettings();
}

