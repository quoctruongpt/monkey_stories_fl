import 'package:flutter/services.dart';

abstract class SystemSettingsDataSource {
  Future<void> setPreferredOrientations(List<DeviceOrientation> orientations);
}

class SystemSettingsDataSourceImpl implements SystemSettingsDataSource {
  @override
  Future<void> setPreferredOrientations(
    List<DeviceOrientation> orientations,
  ) async {
    try {
      // Gọi trực tiếp hàm của Flutter framework
      await SystemChrome.setPreferredOrientations(orientations);
    } catch (e) {
      // Có thể không có exception cụ thể, nhưng bắt lỗi chung đề phòng
      throw SystemException(
        message: 'Failed to set preferred orientations: $e',
      );
    }
  }
}

// Định nghĩa SystemException nếu chưa có trong core/error/exceptions.dart
class SystemException implements Exception {
  final String message;
  SystemException({this.message = 'System Exception'});
}
