import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:monkey_stories/data/models/auth/last_login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monkey_stories/core/constants/constants.dart'; // Assuming SharedPrefKeys is exported here
import 'package:monkey_stories/core/error/exceptions.dart'; // Cần tạo file này

abstract class AuthLocalDataSource {
  Future<bool> isLoggedIn();
  Future<void> cacheToken(String token); // Ví dụ
  Future<String?> getToken(); // Ví dụ
  Future<void> cacheRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<void> cacheLastLogin(LastLoginModel lastLogin);
  Future<LastLoginModel?> getLastLogin();
  Future<void> clearAllData();
  Future<void> cacheHasLoggedBefore();
  Future<bool> getHasLoggedBefore();
}

final logger = Logger('AuthLocalDataSourceImpl');

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> isLoggedIn() async {
    final token = sharedPreferences.getString(SharedPrefKeys.token);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      await sharedPreferences.setString(SharedPrefKeys.token, token);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();

      for (final key in allKeys) {
        if (!keysToKeep.contains(key)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return sharedPreferences.getString(SharedPrefKeys.token);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheRefreshToken(String refreshToken) async {
    try {
      await sharedPreferences.setString(
        SharedPrefKeys.refreshToken,
        refreshToken,
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return sharedPreferences.getString(SharedPrefKeys.refreshToken);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheLastLogin(LastLoginModel lastLogin) async {
    try {
      await sharedPreferences.setString(
        SharedPrefKeys.lastLogin,
        jsonEncode(lastLogin.toJson()),
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<LastLoginModel?> getLastLogin() async {
    try {
      final lastLoginJson = sharedPreferences.getString(
        SharedPrefKeys.lastLogin,
      );
      if (lastLoginJson == null) {
        return null;
      }
      return LastLoginModel.fromJson(jsonDecode(lastLoginJson));
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheHasLoggedBefore() async {
    try {
      await sharedPreferences.setBool(SharedPrefKeys.hasLoggedBefore, true);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> getHasLoggedBefore() async {
    try {
      return sharedPreferences.getBool(SharedPrefKeys.hasLoggedBefore) ?? false;
    } catch (e) {
      throw CacheException();
    }
  }
}
