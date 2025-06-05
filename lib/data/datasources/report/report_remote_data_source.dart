import 'package:dio/dio.dart';
import 'package:monkey_stories/core/constants/api_endpoints.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/data/models/report/api_report.dart';

abstract class ReportRemoteDataSource {
  Future<ApiResponse<ApiReportResponse>> getLearningReport({
    required int userId,
    required int profileId,
    int? date,
  });
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final Dio _dio;

  ReportRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<ApiResponse<ApiReportResponse>> getLearningReport({
    required int userId,
    required int profileId,
    int? date,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.learningReport,
      queryParameters: {
        'user_id': userId,
        'profile_id': profileId,
        'date': date ?? DateTime.now().millisecondsSinceEpoch,
        'age': 1,
      },
    );

    return ApiResponse.fromJson(response.data, (json, response) {
      return ApiReportResponse.fromJson(
        (json! as Map<String, dynamic>)['Report'] as Map<String, dynamic>,
      );
    });
  }
}
