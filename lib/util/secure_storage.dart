// ignore_for_file: prefer_const_constructors

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();
  static const _keyUserId = '';
  static const _keyAccessToken = '';

  static Future setUsername(String username) async =>
      await _storage.write(key: _keyUserId, value: username);

  static Future<String?> getUsername() async =>
      await _storage.read(key: _keyUserId);

  static Future setAccessToken(String accessToken) async =>
      await _storage.write(key: _keyAccessToken, value: accessToken);

  static Future<String?> getAccessToken() async =>
      await _storage.read(key: _keyAccessToken);
}
