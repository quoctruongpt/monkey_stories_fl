import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:monkey_stories/core/constants/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:monkey_stories/core/network/dio_config.dart';
import 'package:monkey_stories/models/api.dart';
import 'package:monkey_stories/models/auth/login_data.dart';
import 'package:monkey_stories/models/auth/user.dart';
import 'package:monkey_stories/services/api/auth_api_service.dart';
import 'package:logging/logging.dart';

final logger = Logger('AuthRepository');

class AuthRepository {
  static const String _accessTokenKey = SharedPrefKeys.token;
  static const String _refreshTokenKey = SharedPrefKeys.refreshToken;
  static const String _userIdKey = SharedPrefKeys.userId;

  final AuthApiService _authApiService;
  final Dio _dio;

  AuthRepository({AuthApiService? authApiService, Dio? dio})
    : _authApiService = authApiService ?? AuthApiService(),
      _dio = dio ?? DioConfig.createDio();

  // Lấy token từ bộ nhớ cục bộ
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Lưu token vào bộ nhớ cục bộ
  Future<void> _saveTokens(
    String accessToken,
    String refreshToken,
    int userId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setInt(_userIdKey, userId);
  }

  // Đăng nhập với email
  Future<LoginResponseData?> loginWithEmail(
    String email,
    String password,
  ) async {
    final loginData = LoginRequestData(
      email: email,
      password: password,
      loginType: LoginType.email,
    );

    return _login(loginData);
  }

  // Đăng nhập với số điện thoại
  Future<LoginResponseData?> loginWithPhone(
    String phone,
    String password,
  ) async {
    final loginData = LoginRequestData(
      phone: phone,
      password: password,
      loginType: LoginType.phone,
    );

    return _login(loginData);
  }

  // Hàm đăng nhập chung
  Future<LoginResponseData?> _login(LoginRequestData loginData) async {
    try {
      final response = await _authApiService.login(loginData);

      if (response.status == ApiStatus.success && response.data != null) {
        // Lưu token vào local storage
        await _saveTokens(
          response.data!.accessToken,
          response.data!.refreshToken,
          response.data!.userId,
        );

        return response.data;
      } else {
        throw (response.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    try {
      final token = await getAccessToken();
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';

        // Tạm thời xử lý đăng xuất ở local nếu chưa có API endpoint
        // TODO: Thêm endpoint API đăng xuất khi có
        // await _dio.post('logout_endpoint');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi gọi API đăng xuất: $e');
      }
    } finally {
      await _clearAuthData();
    }
  }

  // Xóa dữ liệu xác thực
  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
  }

  // Kiểm tra đã đăng nhập chưa
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    logger.info('isLoggedIn: $token');
    return token != null && token.isNotEmpty;
  }

  // Lấy thông tin người dùng hiện tại
  Future<User?> getCurrentUser() async {
    try {
      final token = await getAccessToken();
      if (token == null) {
        throw Exception('Chưa đăng nhập');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      // TODO: Thêm endpoint API lấy thông tin user khi có
      // final response = await _dio.get('user_profile_endpoint');

      // Giả định lấy user ID từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt(_userIdKey);

      if (userId != null) {
        // Tạo một User giả định nếu chưa có API endpoint
        return User(
          id: userId,
          // Các thông tin khác có thể lấy từ API sau khi có endpoint
        );
      } else {
        throw Exception('Không thể lấy thông tin người dùng');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi lấy thông tin người dùng: $e');
      }
      return null;
    }
  }

  // Làm mới token khi hết hạn
  Future<String?> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(_refreshTokenKey);

      if (refreshToken == null) {
        throw Exception('Không có refresh token');
      }

      // TODO: Thêm endpoint API refresh token khi có
      // final response = await _dio.post(
      //   'refresh_token_endpoint',
      //   data: {
      //     'refresh_token': refreshToken,
      //   },
      // );

      // Giả định không thể làm mới token, đăng xuất người dùng
      await _clearAuthData();
      return null;

      // Phần code dưới đây sẽ được sử dụng khi có API endpoint
      /*
      if (response.statusCode == 200) {
        final newAccessToken = response.data['data']['access_token'];
        final newRefreshToken = response.data['data']['refresh_token'];
        final userId = response.data['data']['user_id'];
        
        await _saveTokens(newAccessToken, newRefreshToken, userId);
        
        return newAccessToken;
      } else {
        await _clearAuthData();
        throw Exception('Không thể làm mới token');
      }
      */
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi làm mới token: $e');
      }
      await _clearAuthData();
      return null;
    }
  }
}
