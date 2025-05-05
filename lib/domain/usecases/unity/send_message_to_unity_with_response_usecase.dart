import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';
import 'package:monkey_stories/domain/repositories/unity_repository.dart';

/// Use case gửi tin nhắn đến Unity và chờ phản hồi
class SendMessageToUnityWithResponseUseCase {
  final UnityRepository repository;

  /// Constructor nhận repository dependency
  const SendMessageToUnityWithResponseUseCase(this.repository);

  /// Thực thi use case, gửi tin nhắn đến Unity và chờ phản hồi
  ///
  /// [message] tin nhắn cần gửi đi
  /// Trả về Future với dữ liệu phản hồi từ Unity
  Future<dynamic> call(UnityMessageEntity message) {
    return repository.sendMessageToUnityWithResponse(message);
  }
}
