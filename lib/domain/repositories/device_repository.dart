import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';

abstract class DeviceRepository {
  // Đăng ký thiết bị và trả về Device ID hoặc Failure
  // Hoặc có thể trả về void nếu không cần device ID ngay lập tức
  Future<Either<Failure, String>> registerDevice();

  // Có thể thêm các phương thức khác liên quan đến device nếu cần
  // Future<Either<Failure, String>> getDeviceId();
}
