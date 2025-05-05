import 'package:monkey_stories/domain/repositories/unity_repository.dart';

/// Use case xử lý tin nhắn nhận được từ Unity
class HandleUnityMessageUseCase {
  final UnityRepository repository;

  /// Constructor nhận repository dependency
  const HandleUnityMessageUseCase(this.repository);

  /// Thực thi use case, xử lý tin nhắn từ Unity
  ///
  /// [message] chuỗi JSON nhận được từ Unity
  /// Trả về Future<bool> cho biết tin nhắn đã được xử lý hay chưa
  Future<bool> call(String message) {
    return repository.handleUnityMessage(message);
  }
}
