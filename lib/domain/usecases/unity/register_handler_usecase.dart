import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';
import 'package:monkey_stories/domain/repositories/unity_repository.dart';

/// Use case đăng ký handler cho một loại tin nhắn
class RegisterHandlerUseCase {
  final UnityRepository repository;

  /// Constructor nhận repository dependency
  const RegisterHandlerUseCase(this.repository);

  /// Thực thi use case, đăng ký handler
  ///
  /// [type] loại tin nhắn cần đăng ký
  /// [handler] hàm sẽ được gọi khi nhận được tin nhắn tương ứng
  void call(String type, Function(UnityMessageEntity) handler) {
    repository.registerHandler(type, handler);
  }
}
