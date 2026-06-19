import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _tokenKey = 'backpacker_token';
  static const _usernameKey = 'backpacker_username';
  static const _nickNameKey = 'backpacker_nick_name';

  Future<void> saveSession({
    required String token,
    required String username,
    required String nickName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_nickNameKey, nickName);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<String?> getNickName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nickNameKey);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_nickNameKey);
  }
}
