import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/device_repository.dart';

class RegisterDeviceUseCase implements UseCase<String, NoParams> {
  final DeviceRepository repository;

  RegisterDeviceUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    // Logic ở đây có thể là: kiểm tra xem đã có device ID chưa,
    // nếu chưa thì gọi repository.registerDevice()
    // Tạm thời chỉ gọi registerDevice()
    return await repository.registerDevice();
  }
}
