import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';
import 'package:monkey_stories/domain/repositories/unity_repository.dart';

/// Use case gửi tin nhắn đến Unity mà không cần phản hồi
class SendMessageToUnityUseCase {
  final UnityRepository repository;

  /// Constructor nhận repository dependency
  const SendMessageToUnityUseCase(this.repository);

  /// Thực thi use case, gửi tin nhắn đến Unity
  ///
  /// [message] tin nhắn cần gửi đi
  /// Trả về Future void
  Future<void> call(UnityMessageEntity message) {
    return repository.sendMessageToUnity(message);
  }
}
