import 'dart:io'; // Để kiểm tra Platform.isIOS, Platform.isAndroid

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart'; // Để kiểm tra kIsWeb
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/utils/language.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monkey_stories/core/constants/constants.dart';

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
  Future<Map<String, dynamic>> _getCommonRequestData(
    RequestOptions options,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String? accessToken;
    // Ưu tiên token được truyền trực tiếp trong queryParameters của request
    final String? externalToken = options.queryParameters['token'] as String?;

    if (externalToken != null && externalToken.isNotEmpty) {
      accessToken = externalToken;
      _logger.info(
        'Using externally provided token from queryParameters: "$accessToken"',
      );
    } else {
      // Nếu không có token bên ngoài, lấy từ SharedPreferences
      accessToken = prefs.getString(SharedPrefKeys.token);
      if (accessToken != null && accessToken.isNotEmpty) {
        _logger.info('Using token from SharedPreferences: "$accessToken"');
      } else {
        _logger.info(
          'No token provided externally or found in SharedPreferences.',
        );
      }
    }

    String? deviceId = await _getDeviceId();
    String subversion = packageInfo.version;

    // Lấy thông tin thiết bị
    int deviceType = 4;
    String os = 'unknown';
    String deviceInfoStr = '';
    String model = '';
    String systemVersion = '';
    final String lang = await LanguageUtils.getLocaleCode();

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
          'Application Version: $subversion OS: $os Model: $model System Version: $systemVersion';
      // Thêm các nền tảng khác nếu cần
    } catch (e, stackTrace) {
      _logger.severe('Failed to get device info in interceptor', e, stackTrace);
      // Giữ giá trị mặc định 'unknown'
    }

    final commonParams = <String, dynamic>{
      'app_id': AppConstants.appId,
      'device_type': deviceType,
      'os': os,
      'subversion': subversion,
      'device_id': deviceId,
      'info': deviceInfoStr,
      'lang': lang,
      if (accessToken != null && accessToken.isNotEmpty) 'token': accessToken,
    };

    return commonParams;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // --- 1. Lấy thông tin chung từ hàm helper, đã xử lý logic token ---
    final commonParams = await _getCommonRequestData(options);

    // --- 2. Luôn thêm thông tin chung vào queryParameters ---
    options.queryParameters.addAll(commonParams);
    _logger.info(
      'Common params added to queryParameters. Final queryParameters: ${options.queryParameters}',
    );

    // --- 3. Ghi log dữ liệu body nếu có (không thay đổi) ---
    if (options.data != null) {
      _logger.info('Request data: ${options.data}');
    }

    // --- 4. Tiếp tục request ---
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
