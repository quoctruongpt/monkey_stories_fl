import 'dart:async';
import 'dart:convert';

import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core1/constants/unity_constants.dart';
import 'package:monkey_stories/data/models/unity/unity_message_model.dart';
import 'package:monkey_stories/utils/uuid.dart';

/// Data source để giao tiếp trực tiếp với Unity engine
class UnityDataSource {
  static final Map<String, Completer<dynamic>> _messageQueue = {};
  static final Map<String, Timer> _timeoutTimers = {};
  static const int _timeoutDuration = 30000; // 30 seconds timeout
  final Logger _logger = Logger('UnityDataSource');

  /// Gửi tin nhắn đến Unity mà không cần phản hồi
  void sendToUnityWithoutResult(UnityMessageModel message) {
    final updatedMessage =
        message.id == null
            ? message.copyWith(id: generateShortId(), response: false)
            : message;

    _logger.info('sendToUnityWithoutResult ${updatedMessage.toJsonString()}');
    sendToUnity(
      UnityGameObjects.reactNativeBridge,
      UnityMethodNames.requestUnityAction,
      updatedMessage.toJsonString(),
    );
  }

  /// Gửi tin nhắn đến Unity và đợi phản hồi
  Future<dynamic> sendToUnityWithResponse(UnityMessageModel message) async {
    final String id = generateShortId();
    final UnityMessageModel updatedMessage = message.copyWith(
      id: id,
      response: true,
    );
    final completer = Completer<dynamic>();

    // Add to message queue
    _messageQueue[id] = completer;

    // Set timeout
    _timeoutTimers[id] = Timer(
      const Duration(milliseconds: _timeoutDuration),
      () {
        if (_messageQueue.containsKey(id)) {
          _messageQueue[id]?.completeError('Unity response timeout');
          _messageQueue.remove(id);
          _timeoutTimers.remove(id);
        }
      },
    );

    try {
      _logger.info('sendToUnityWithResponse ${updatedMessage.toJsonString()}');
      // Send message to Unity
      sendToUnity(
        UnityGameObjects.reactNativeBridge,
        UnityMethodNames.requestUnityAction,
        updatedMessage.toJsonString(),
      );
    } catch (e) {
      // Clean up resources in case of exception
      _cleanupRequest(id);
      rethrow;
    }

    return completer.future;
  }

  /// Xử lý tin nhắn nhận được từ Unity
  Future<bool> handleUnityMessage(String data) async {
    try {
      final Map<String, dynamic> message = jsonDecode(data);
      _logger.info('handleUnityMessage $data');
      final String? id = message['id'];
      final Map<String, dynamic>? payload =
          message['payload'] as Map<String, dynamic>?;

      if (id != null && _messageQueue.containsKey(id)) {
        _cleanupRequest(id, completeData: payload);
        return true;
      }
      return false;
    } catch (error) {
      _logger.severe('Error handling Unity message: $error');
      return false;
    }
  }

  /// Dọn dẹp tài nguyên sau khi xử lý tin nhắn
  void _cleanupRequest(String id, {dynamic completeData}) {
    if (_messageQueue.containsKey(id)) {
      if (completeData != null) {
        if (completeData['success'] == true) {
          _messageQueue[id]?.complete(completeData);
        } else {
          _messageQueue[id]?.completeError(completeData);
        }
      }
      _messageQueue.remove(id);
    }

    if (_timeoutTimers.containsKey(id)) {
      _timeoutTimers[id]?.cancel();
      _timeoutTimers.remove(id);
    }
  }
}
