import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const sessionId = 'session-id';
}

class SessionDataProvider {
  static const _securityStorage = FlutterSecureStorage();

  Future<String?> getSessionId() => _securityStorage.read(key: _Keys.sessionId);
  Future<void> setSessionId(String? value) {
    if (value != null) {
      return _securityStorage.write(key: _Keys.sessionId, value: value);
    } else {
      return _securityStorage.delete(key: _Keys.sessionId);
    }
  }
}
