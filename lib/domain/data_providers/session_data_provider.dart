import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const sessionId = 'session_id';
  static const accountId = 'account_id';
}

class SessionDataProvider {
  static const _secureStorage = FlutterSecureStorage();

  Future<String?> getSessionId() => _secureStorage.read(key: _Keys.sessionId);

  Future<void> setSessionId(String? value) {
    if (value != null) {
      return _secureStorage.write(key: _Keys.sessionId, value: value);
    } else {
      return _secureStorage.delete(key: _Keys.sessionId);
    }
  }

  Future<int?> getAccountId() async {
    final id = await _secureStorage.read(key: _Keys.accountId);

    return id != null ? int.tryParse(id) : null;
  }

  Future<void> setAccountId(int? accountId) {
    if (accountId != null) {
      return _secureStorage.write(
        key: _Keys.accountId,
        value: accountId.toString(),
      );
    } else {
      return _secureStorage.delete(key: _Keys.accountId);
    }
  }
}
