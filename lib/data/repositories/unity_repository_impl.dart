// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:logging/logging.dart';

// Project imports:
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

  /// Xử lý tin nhắn nhận được từ Unity
  /// [message] tin nhắn nhận được từ Unity
  /// Trả về true nếu tin nhắn đã được xử lý
  /// Trả về false nếu tin nhắn chưa được xử lý
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
      _logger.info('Đã tìm thấy handler: $handler');
      if (handler != null) {
        final unityMessage = UnityMessageEntity(
          id: parsedMessage['id'] as String?,
          type: type,
          payload: parsedMessage['payload'],
          response: response,
        );

        try {
          // Thực thi handler và nhận kết quả trả về
          final result = await Future.value(handler(unityMessage));

          // Nếu tin nhắn ban đầu có ID, gửi phản hồi thành công
          if (unityMessage.id != null) {
            _sendResponseMessage(unityMessage, result);
          }
        } catch (e, s) {
          _logger.severe('Error executing handler for type "$type"', e, s);
          // Nếu có lỗi, và tin nhắn gốc cần phản hồi, gửi lại tin nhắn lỗi cho Unity
          if (unityMessage.id != null) {
            _sendErrorMessage(unityMessage, e);
          }
        }

        return true;
      }

      return false;
    } catch (e) {
      _logger.severe('Error handling Unity message: $e');
      return false;
    }
  }

  void _sendResponseMessage(UnityMessageEntity message, dynamic result) {
    final responseMessage = UnityMessageEntity(
      id: message.id,
      type: message.type,
      payload: {...result, 'success': true},
      response: false,
    );
    sendMessageToUnity(responseMessage);
  }

  void _sendErrorMessage(UnityMessageEntity message, Object error) {
    final errorMessage = UnityMessageEntity(
      id: message.id,
      type: message.type,
      payload: {'success': false, 'message': error.toString()},
      response: false,
    );
    sendMessageToUnity(errorMessage);
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
