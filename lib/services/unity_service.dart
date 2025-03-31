import 'dart:async';
import 'dart:convert';

import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/models/unity.dart';
import 'package:monkey_stories/models/unity_message.dart';
import 'package:monkey_stories/utils/uuid.dart';

final logger = Logger('UnityService');

class UnityService {
  static final Map<String, Completer<dynamic>> _messageQueue = {};
  static final Map<String, Timer> _timeoutTimers = {};
  static const int _timeoutDuration = 30000; // 30 seconds timeout

  static void sendToUnityWithoutResult(UnityMessage message) {
    final updatedMessage =
        message.id == null
            ? message.copyWith(id: generateShortId(), response: false)
            : message;

    logger.info('sendToUnityWithoutResult ${updatedMessage.toString()}');
    sendToUnity(
      UnityGameObjects.reactNativeBridge,
      UnityMethodNames.requestUnityAction,
      updatedMessage.toJsonString(),
    );
  }

  static Future<dynamic> sendToUnityWithResponse(UnityMessage message) async {
    final String id = generateShortId();
    final UnityMessage updatedMessage = message.copyWith(
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
      logger.info('sendToUnityWithResponse ${updatedMessage.toString()}');
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

  static Future<bool> handleUnityMessage(String data) async {
    try {
      final Map<String, dynamic> message = jsonDecode(data);
      logger.info('handleUnityMessage $data');
      final String? id = message['id'];
      final Map<String, dynamic>? payload =
          message['payload'] as Map<String, dynamic>?;

      if (id != null && _messageQueue.containsKey(id)) {
        _cleanupRequest(id, completeData: payload);
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  static void _cleanupRequest(String id, {dynamic completeData}) {
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
