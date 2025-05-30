import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';

class AuthService {
  static const _defaultUsername = String.fromEnvironment('DEFAULT_USERNAME');
  static const _defaultPassword = String.fromEnvironment('DEFAULT_PASSWORD');

  static String _hash(String text) {
    return sha256.convert(utf8.encode(text)).toString();
  }

  static Future<bool> verifyCredentials(
      String username, String password) async {
    final inputUsernameHash = _hash(username);
    final inputPasswordHash = _hash(password);
    final isMatch = _defaultUsername == inputUsernameHash &&
        _defaultPassword == inputPasswordHash;
    log('[AuthService] Login ${isMatch ? 'successful' : 'failed'} for username: $username');
    return isMatch;
  }
}
