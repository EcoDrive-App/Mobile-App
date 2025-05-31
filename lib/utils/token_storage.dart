import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const String _key = 'authToken';
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static Future<void> storeToken(String authToken) async {
    try {
      await _storage.write(key: _key, value: authToken);
    } catch (error) {
      throw Exception('Failed to store token');
    }
  }

  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _key);
    } catch (error) {
      throw Exception('Failed to get token');
    }
  }

  static Future<void> removeToken() async {
    try {
      await _storage.delete(key: _key);
    } catch (error) {
      throw Exception('Failed to remove token');
    }
  }
}