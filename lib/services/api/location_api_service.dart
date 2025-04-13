import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/api_endpoints.dart';
import 'package:monkey_stories/core/network/dio_config.dart';
import 'package:monkey_stories/models/api.dart';
import 'package:monkey_stories/models/location/register_location_data.dart';

class LocationApiService {
  late final Dio _dio;
  final Logger _logger = Logger('LocationApiService');

  LocationApiService({Dio? dio}) {
    _dio = dio ?? DioConfig.createDio();
  }

  Future<ApiResponse<RegisterLocationData>> registerDeviceLocation() async {
    try {
      final response = await _dio.get(ApiEndpoints.registerLocation);
      return ApiResponse.fromJson(response.data, RegisterLocationData.fromJson);
    } on DioException catch (e) {
      _logger.severe('Error registering device', e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
