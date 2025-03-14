import 'dart:async';
import 'dart:convert';

import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:monkey_stories/constants/unity.dart';
import 'package:monkey_stories/types/unity.dart';
import 'package:monkey_stories/utils/uuid.dart';

class UnityService {
  static final Map<String, Completer<dynamic>> _messageQueue = {};
  static final Map<String, Timer> _timeoutTimers = {};
  static const int _timeoutDuration = 30000; // 30 seconds timeout

  static void sendToUnityWithoutResult(UnityMessage message) {
    final updatedMessage =
        message.id == null ? message.copyWith(id: generateShortId()) : message;

    sendToUnity(
      UnityGameObjects.reactNativeBridge,
      UnityMethodNames.requestUnityAction,
      updatedMessage.toJsonString(),
    );
  }

  static Future<dynamic> sendToUnityWithResponse(UnityMessage message) async {
    final String id = generateShortId();
    final UnityMessage updatedMessage = message.copyWith(id: id);
    final completer = Completer<dynamic>();

    // Add to message queue
    _messageQueue[id] = completer;

    // Set timeout
    _timeoutTimers[id] = Timer(Duration(milliseconds: _timeoutDuration), () {
      if (_messageQueue.containsKey(id)) {
        _messageQueue[id]?.completeError('Unity response timeout');
        _messageQueue.remove(id);
        _timeoutTimers.remove(id);
      }
    });

    try {
      // Send message to Unity
      sendToUnity(
        UnityGameObjects.reactNativeBridge,
        UnityMethodNames.requestUnityAction,
        updatedMessage.toJsonString(),
      );
    } catch (e) {
      // Clean up resources in case of exception
      _cleanupRequest(id);
      throw e;
    }

    return completer.future;
  }

  static Future<bool> handleUnityMessage(String data) async {
    try {
      final Map<String, dynamic> message = jsonDecode(data);
      final String? id = message['id'];
      final Map<String, dynamic>? payload =
          message['payload'] as Map<String, dynamic>?;

      if (id != null && _messageQueue.containsKey(id)) {
        _cleanupRequest(id, completeData: payload);
        return true;
      }
      return false;
    } catch (error) {
      print('Error handling Unity message: $error');
      return false;
    }
  }

  static void _cleanupRequest(String id, {dynamic completeData}) {
    if (_messageQueue.containsKey(id)) {
      if (completeData != null) {
        if (completeData['status'] == 'success') {
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
