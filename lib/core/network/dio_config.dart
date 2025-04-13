import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:monkey_stories/core/network/dio_interceptor.dart';

class DioConfig {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL']!,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        contentType: 'application/json',
      ),
    );

    dio.interceptors.add(DioInterceptor());
    return dio;
  }
}
