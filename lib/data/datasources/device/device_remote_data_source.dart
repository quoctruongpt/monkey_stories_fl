import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/error/exceptions.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/data/models/device/device_reponse_model.dart';

abstract class DeviceRemoteDataSource {
  Future<RegisterLocationData> registerDevice(); // Trả về deviceId từ API
}

final logger = Logger('DeviceRemoteDataSourceImpl');

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final Dio dioClient;

  DeviceRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<RegisterLocationData> registerDevice() async {
    try {
      // Logic gọi API giống trong splash_screen.dart cũ
      // Sử dụng dioClient đã được inject với interceptor
      final response = await dioClient.get(
        ApiEndpoints.registerLocation,
        options: Options(extra: {AppConstants.isCloseable: false}),
      );

      final data = ApiResponse.fromJson(
        response.data,
        RegisterLocationData.fromJson,
      );

      if (data.status == ApiStatus.success && data.data != null) {
        // Giả sử API trả về JSON có trường 'device_id' hoặc tương tự
        // Cần parse response.data một cách an toàn
        return data.data!;
      } else {
        throw ServerException(
          message:
              'Failed to register device. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // Xử lý lỗi Dio (network, timeout,...)
      throw ServerException(
        message: e.message ?? 'Dio Error during device registration',
      );
    } catch (e) {
      // Các lỗi khác
      throw ServerException(message: e.toString());
    }
  }
}
