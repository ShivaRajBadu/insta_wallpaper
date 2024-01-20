import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageKeys {
  SecureStorageKeys._();

  static const String accessToken = "09u2etjiou0f98q3u9r";
}

class SecureStorage {
  SecureStorage._();

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<String?> get(String key) {
    return _secureStorage.read(key: key);
  }

  static Future<void> set(String key, String value) {
    return _secureStorage.write(key: key, value: value);
  }

  static Future<void> delete(String key) {
    return _secureStorage.delete(key: key);
  }

  static Future<void> deleteAll() {
    return _secureStorage.deleteAll();
  }
}
