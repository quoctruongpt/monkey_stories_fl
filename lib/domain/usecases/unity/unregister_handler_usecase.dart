import 'package:monkey_stories/domain/repositories/unity_repository.dart';

/// Use case hủy đăng ký handler cho một loại tin nhắn
class UnregisterHandlerUseCase {
  final UnityRepository repository;

  /// Constructor nhận repository dependency
  const UnregisterHandlerUseCase(this.repository);

  /// Thực thi use case, hủy đăng ký handler
  ///
  /// [type] loại tin nhắn cần hủy đăng ký
  void call(String type) {
    repository.unregisterHandler(type);
  }
}
