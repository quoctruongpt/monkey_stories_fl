import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:monkey_stories/data/datasources/unity_datasource.dart';
import 'package:monkey_stories/data/models/unity/unity_message_model.dart';
import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';
import 'package:monkey_stories/domain/repositories/unity_repository.dart';

/// Triển khai repository để giao tiếp với Unity
class UnityRepositoryImpl implements UnityRepository {
  final UnityDataSource dataSource;
  final Map<String, Function(UnityMessageEntity)> _messageHandlers = {};
  final Logger _logger = Logger('UnityRepositoryImpl');
  bool _isUnityVisible = false;

  UnityRepositoryImpl({required this.dataSource});

  @override
  Future<void> sendMessageToUnity(UnityMessageEntity message) async {
    try {
      final messageModel = UnityMessageModel.fromEntity(message);
      dataSource.sendToUnityWithoutResult(messageModel);
    } catch (e) {
      _logger.severe('Error sending message to Unity: $e');
      rethrow;
    }
  }

  @override
  Future<dynamic> sendMessageToUnityWithResponse(
    UnityMessageEntity message,
  ) async {
    try {
      final messageModel = UnityMessageModel.fromEntity(message);
      return await dataSource.sendToUnityWithResponse(messageModel);
    } catch (e) {
      _logger.severe('Error sending message to Unity with response: $e');
      rethrow;
    }
  }

  @override
  Future<bool> handleUnityMessage(String message) async {
    try {
      final isQueuedMessage = await dataSource.handleUnityMessage(message);

      // Nếu tin nhắn đã được xử lý bởi queue, không cần xử lý tiếp
      if (isQueuedMessage) {
        return true;
      }

      // Xử lý tin nhắn bằng các handler đã đăng ký
      final Map<String, dynamic> parsedMessage = jsonDecode(message);
      final String type = parsedMessage['type'] as String;
      final bool? response = parsedMessage['response'] as bool?;

      // Chỉ xử lý tin nhắn yêu cầu phản hồi
      if (response == false) {
        return false;
      }

      // Tìm handler tương ứng
      final handler = _messageHandlers[type];
      if (handler != null) {
        final unityMessage = UnityMessageEntity(
          id: parsedMessage['id'] as String?,
          type: type,
          payload: parsedMessage['payload'],
          response: response,
        );

        await Future.value(handler(unityMessage));
        return true;
      }

      return false;
    } catch (e) {
      _logger.severe('Error handling Unity message: $e');
      return false;
    }
  }

  @override
  void showUnity() {
    _isUnityVisible = true;
  }

  @override
  void hideUnity() {
    _isUnityVisible = false;
  }

  @override
  void registerHandler(String type, Function(UnityMessageEntity) handler) {
    _messageHandlers[type] = handler;
  }

  @override
  void unregisterHandler(String type) {
    _messageHandlers.remove(type);
  }

  @override
  bool get isUnityVisible => _isUnityVisible;
}
