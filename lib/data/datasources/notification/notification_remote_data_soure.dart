import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/utils/language.dart';
import 'package:monkey_stories/data/models/api_response.dart';

abstract class NotificationRemoteDataSource {
  Future<String?> getFcmToken();
  Future<void> saveFcmToken(String token);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseMessaging _firebaseMessaging;
  final Dio _dio;

  final Logger _logger = Logger('NotificationRemoteDataSourceImpl');

  NotificationRemoteDataSourceImpl({
    FirebaseMessaging? firebaseMessaging,
    required Dio dio,
  }) : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
       _dio = dio;

  @override
  Future<String?> getFcmToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      _logger.info('FCM token: $token');
      return token;
    } catch (e) {
      // Log a more specific error or rethrow a custom exception
      _logger.severe('Failed to get FCM token: $e');
      return null;
    }
  }

  @override
  Future<void> saveFcmToken(String token) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.registerDevice,
        data: {'fcm': token, 'country': await LanguageUtils.getCountryFcm()},
        options: Options(
          extra: {AppConstants.showConnectionErrorDialog: false},
        ),
      );

      final result = ApiResponse.fromJson(response.data, (json, jsonMap) {
        return null;
      });

      if (result.status == ApiStatus.success) {
        _logger.info('FCM token saved to server: $token');
      } else {
        _logger.severe('FCM token saved to server: $token');
        throw Exception(result.message);
      }
    } catch (e) {
      _logger.severe('Failed to save FCM token to server: $e');
      // Rethrow a custom exception or handle as needed
      rethrow;
    }
  }
}
