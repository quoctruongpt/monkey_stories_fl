import 'dart:async';
import 'dart:io'; // Để kiểm tra Platform.isIOS, Platform.isAndroid

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart'; // Để kiểm tra kIsWeb
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/utils/language.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/exceptions.dart';
import 'package:monkey_stories/core/routes/routes.dart';
import 'package:monkey_stories/presentation/widgets/dialogs/lost_connect_dialog.dart';
import 'package:monkey_stories/di/injection_container.dart';

class DioInterceptor extends Interceptor {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final Logger _logger = Logger('DioInterceptor');

  DioInterceptor();

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

  // Hàm private để lấy access token
  Future<String?> _getAccessToken(RequestOptions options) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken;
    // Ưu tiên token được truyền trực tiếp trong queryParameters của request
    final String? externalToken = options.queryParameters['token'] as String?;

    if (externalToken != null && externalToken.isNotEmpty) {
      accessToken = externalToken;
      _logger.info(
        'Using externally provided token from queryParameters: "$accessToken"',
      );
      // Xóa token khỏi queryParameters vì nó sẽ được chuyển vào header
      options.queryParameters.remove('token');
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
    return accessToken;
  }

  // Hàm private để lấy dữ liệu chung
  Future<Map<String, dynamic>> _getCommonRequestData() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

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
    };

    return commonParams;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // --- Lấy Access Token và thêm vào Header ---
    final String? accessToken = await _getAccessToken(options);
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['token'] = accessToken;
      _logger.info('Added Authorization header.');
    }

    // --- 1. Lấy thông tin chung từ hàm helper ---
    final commonParams = await _getCommonRequestData();

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
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    _logger.severe(
      '[${err.requestOptions.method}] Error from: ${err.requestOptions.uri} -> ${err.response?.statusCode ?? 'N/A'}',
      err.error,
      err.stackTrace,
    );

    final isNetworkError = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      DioExceptionType.unknown => err.error is SocketException,
      _ => false,
    };

    if (isNetworkError) {
      return _handleConnectionError(err, handler);
    }

    // Ghi log và bỏ qua cho các lỗi khác
    if (err.response?.data != null) {
      _logger.warning('Error response data: ${err.response!.data}');
    }
    return super.onError(err, handler);
  }

  Future<void> _handleConnectionError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Đọc cờ từ `extra`. Mặc định là `true` nếu không được đặt.
    final bool shouldShowDialog =
        err.requestOptions.extra[AppConstants.showConnectionErrorDialog]
            as bool? ??
        true;

    if (!shouldShowDialog) {
      _logger.info(
        'Connection error dialog is disabled for this request. Passing error along.',
      );
      return handler.next(err);
    }

    final context = navigatorKey.currentContext;
    if (context == null) {
      _logger.warning(
        'Cannot show lost connection dialog because navigatorKey.currentContext is null. Passing error along.',
      );
      return handler.next(err);
    }

    final shouldRetry = await showLostConnectDialog(
      context: context,
      isCloseable:
          err.requestOptions.extra[AppConstants.isCloseable] as bool? ?? true,
    );

    if (shouldRetry) {
      try {
        _logger.info('Retrying request to ${err.requestOptions.uri}');
        final response = await sl<Dio>().fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        _logger.severe('Retry failed: ${e.toString()}');
        return handler.next(e is DioException ? e : err);
      }
    } else {
      _logger.info('User chose not to retry. Rejecting with original error.');
      final networkException = NetworkException(
        message: 'Không có kết nối internet. Vui lòng kiểm tra và thử lại.',
      );
      final customError = DioException(
        requestOptions: err.requestOptions,
        error: networkException,
        type: err.type,
        response: err.response,
      );
      return handler.reject(customError);
    }
  }
}
