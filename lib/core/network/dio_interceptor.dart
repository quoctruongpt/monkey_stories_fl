import 'dart:io'; // Để kiểm tra Platform.isIOS, Platform.isAndroid

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart'; // Để kiểm tra kIsWeb
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/app.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monkey_stories/core/constants/shared_pref_keys.dart';

class DioInterceptor extends Interceptor {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final Logger _logger = Logger('DioInterceptor');

  Future<String?> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(SharedPrefKeys.deviceId);
    if (deviceId == null) {
      if (Platform.isAndroid) {
        final androidId = await const AndroidId().getId();
        deviceId = '|$androidId|null|null';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = '|${iosInfo.identifierForVendor}|null|null';
      }
    }
    return deviceId;
  }

  // Hàm private để lấy dữ liệu chung
  Future<Map<String, dynamic>> _getCommonRequestData() async {
    final prefs = await SharedPreferences.getInstance();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // Sử dụng SharedPrefKeys.accessToken nếu bạn đã định nghĩa nó
    final String? accessToken = prefs.getString(
      'access_token',
    ); // Hoặc SharedPrefKeys.accessToken
    String? deviceId = await _getDeviceId();
    String subversion = packageInfo.version;

    // Lấy thông tin thiết bị
    int deviceType = 4;
    String os = 'unknown';
    String deviceInfoStr = '';
    String model = '';
    String systemVersion = '';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        os = 'android';
        deviceInfoStr = 'API ${androidInfo.version.sdkInt}';
        model = androidInfo.model;
        systemVersion = androidInfo.version.release;
        deviceId ??= await const AndroidId().getId();
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        os = 'ios';
        model = iosInfo.utsname.machine;
        systemVersion = iosInfo.systemVersion;
      }
      deviceInfoStr =
          'Application Version: ${subversion} OS: ${os} Model: $model System Version: $systemVersion';
      // Thêm các nền tảng khác nếu cần
    } catch (e, stackTrace) {
      _logger.severe('Failed to get device info in interceptor', e, stackTrace);
      // Giữ giá trị mặc định 'unknown'
    }

    // Lấy thông tin ngôn ngữ (ví dụ, cần điều chỉnh theo cách bạn quản lý ngôn ngữ)
    // Giả sử bạn lấy từ AppCubit hoặc prefs
    final String lang = prefs.getString(SharedPrefKeys.languageCode) ?? 'vi';
    final int langId = (lang == 'vi') ? 1 : 2; // Ví dụ mapping đơn giản

    final commonParams = <String, dynamic>{
      'app_id': AppConstants.appId,
      'device_type': deviceType,
      'os': os,
      'subversion': subversion,
      'device_id': deviceId,
      'info': deviceInfoStr,
      'lang': lang,
      'lang_id': langId,
      if (accessToken != null && accessToken.isNotEmpty)
        'access_token': accessToken,
    };

    return commonParams;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // --- 1. Lấy thông tin chung từ hàm helper ---
    final commonParams = await _getCommonRequestData();

    // --- 2. Thêm thông tin chung vào request ---
    final method = options.method.toUpperCase();
    if (method == 'GET') {
      options.queryParameters.addAll(commonParams);
    } else if (['POST', 'PUT', 'PATCH', 'DELETE'].contains(method)) {
      if (options.data == null) {
        options.data = commonParams;
      } else if (options.data is Map<String, dynamic>) {
        // Clone map gốc để tránh thay đổi trực tiếp nếu không muốn
        final originalData = Map<String, dynamic>.from(options.data);
        originalData.addAll(commonParams);
        options.data = originalData;
      } else {
        // Nếu data không phải Map (ví dụ: FormData), thêm vào query params
        _logger.warning(
          'Request data is not a Map. Adding common params to query parameters instead.',
        );
        options.queryParameters.addAll(commonParams);
      }
    }
    if (options.data != null) {
      _logger.info('Final data: ${options.data}');
    }

    // --- 3. Tiếp tục request ---
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.info(
      '[${response.requestOptions.method}] Response from: ${response.requestOptions.uri} -> ${response.statusCode}',
    );
    if (response.data != null) {
      _logger.fine(
        'Response data: ${response.data}',
      ); // Use fine for potentially large data
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.severe(
      '[${err.requestOptions.method}] Error from: ${err.requestOptions.uri} -> ${err.response?.statusCode ?? 'N/A'}',
      err.error,
      err.stackTrace,
    );
    if (err.response?.data != null) {
      _logger.warning('Error response data: ${err.response!.data}');
    }
    super.onError(err, handler);
  }
}
