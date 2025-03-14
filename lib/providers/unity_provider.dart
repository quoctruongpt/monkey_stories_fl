import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monkey_stories/constants/unity.dart';
import 'package:monkey_stories/services/unity_service.dart';
import 'package:monkey_stories/types/unity.dart';

class UnityProvider extends ChangeNotifier {
  bool _isUnityVisible = false;
  // Sử dụng kiểu dynamic cho phương thức handler để có thể chấp nhận cả hàm đồng bộ và bất đồng bộ
  final Map<String, dynamic Function(UnityMessage)> _messageHandlers = {};

  bool get isUnityVisible => _isUnityVisible;

  void showUnity() {
    if (!_isUnityVisible) {
      _isUnityVisible = true;
      notifyListeners();
    }
  }

  void hideUnity() {
    if (_isUnityVisible) {
      _isUnityVisible = false;
      notifyListeners();
    }
  }

  // Giữ nguyên phương thức đăng ký với kiểu dữ liệu cũ
  void registerHandler(String type, Function(UnityMessage) handler) {
    _messageHandlers[type] = handler;
  }

  void unregisterHandler(String type) {
    _messageHandlers.remove(type);
  }

  void sendMessageToUnity(UnityMessage message) {
    UnityService.sendToUnityWithoutResult(message);
  }

  Future<dynamic> sendMessageToUnityWithResponse(UnityMessage message) {
    return UnityService.sendToUnityWithResponse(message);
  }

  Future<void> handleUnityMessage(String message) async {
    try {
      final unityMessage = UnityMessage.fromJson(jsonDecode(message));

      // First check if this is a response to a queued message
      if (unityMessage.id != null) {
        final isQueuedMessage = await UnityService.handleUnityMessage(message);
        if (isQueuedMessage) {
          return;
        }
      }

      final handler = _messageHandlers[unityMessage.type];
      dynamic result;

      try {
        // Kiểm tra handler và thực thi
        if (handler != null) {
          // Gọi handler và đợi kết quả, bất kể nó trả về Future hay giá trị thường
          result = await Future.value(handler(unityMessage));
        } else {
          result = await _handleDefaultLogic(unityMessage);
        }

        // Gửi phản hồi thành công về Unity
        _sendResponse(unityMessage, true, result);
      } catch (handlerError) {
        // Gửi phản hồi lỗi về Unity
        _sendResponse(unityMessage, false, handlerError.toString());
      }
    } catch (parseError) {
      print('Error parsing Unity message: $parseError');
    }
  }

  void _sendResponse(
    UnityMessage originalMessage,
    bool success,
    dynamic result,
  ) {
    // Chỉ gửi phản hồi nếu message gốc có ID
    if (originalMessage.id != null) {
      final responseMessage = UnityMessage(
        id: originalMessage.id,
        type: originalMessage.type,
        payload: {'success': success, 'result': result},
      );

      sendMessageToUnity(responseMessage);
    }
  }

  // Default handler logic for messages without specific handlers
  Future<dynamic> _handleDefaultLogic(UnityMessage message) async {
    print('Using default handler for message type: ${message.type}');

    switch (message.type) {
      case MessageTypes.closeUnity:
        hideUnity();
        return null;
      case 'getVersion':
        return '1.0.0';
      default:
        return 'Received message of type: ${message.type}';
    }
  }
}
