import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _tokenKey = 'backpacker_token';
  static const _userIdKey = 'backpacker_user_id';
  static const _usernameKey = 'backpacker_username';
  static const _nickNameKey = 'backpacker_nick_name';
  static const _rememberMeKey = 'backpacker_remember_me';
  static const _rememberUsernameKey = 'backpacker_remember_username';
  static const _rememberPasswordKey = 'backpacker_remember_password';

  Future<void> saveSession({
    required String token,
    required int userId,
    required String username,
    required String nickName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_nickNameKey, nickName);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<String?> getNickName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nickNameKey);
  }

  Future<void> updateNickName(String nickName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nickNameKey, nickName);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_nickNameKey);
  }

  Future<void> saveRememberMe({
    required bool rememberMe,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, rememberMe);
    if (rememberMe) {
      await prefs.setString(_rememberUsernameKey, username);
    } else {
      await prefs.remove(_rememberUsernameKey);
    }
    await prefs.remove(_rememberPasswordKey);
  }

  Future<({bool rememberMe, String username})> loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    await prefs.remove(_rememberPasswordKey);
    return (
      rememberMe: rememberMe,
      username: prefs.getString(_rememberUsernameKey) ?? '',
    );
  }
}
