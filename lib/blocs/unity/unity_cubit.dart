import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/models/unity.dart';
import 'package:monkey_stories/services/unity_service.dart';
import 'package:monkey_stories/types/unity.dart';

part 'unity_state.dart';

final Logger logger = Logger("UnityCubit");

class UnityCubit extends Cubit<UnityState> {
  UnityCubit() : super(UnityState(isUnityVisible: false));

  final Map<String, dynamic Function(UnityMessage)> _messageHandlers = {};

  // Bật Unity, unity sẽ đè lên UI khác
  void showUnity() {
    logger.info("chạy vào showUnity");
    if (!state.isUnityVisible) {
      emit(state.copyWith(isUnityVisible: true));
    }
  }

  // Ẩn Unity, unity sẽ di chuyển ra khỏi vùng hiển thị
  void hideUnity() {
    if (state.isUnityVisible) {
      emit(state.copyWith(isUnityVisible: false));
    }
  }

  // Đăng ký hàm xử lý messsage unity chuyển sang
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

      if (unityMessage.id != null) {
        final isQueuedMessage = await UnityService.handleUnityMessage(message);
        if (isQueuedMessage) {
          return;
        }
      }

      final handler = _messageHandlers[unityMessage.type];
      dynamic result;

      try {
        result = await Future.value(
          handler?.call(unityMessage) ?? _handleDefaultLogic(unityMessage),
        );
        _sendResponse(unityMessage, true, result);
      } catch (handlerError) {
        _sendResponse(unityMessage, false, handlerError.toString());
      }
    } catch (parseError) {}
  }

  void _sendResponse(
    UnityMessage originalMessage,
    bool success,
    dynamic result,
  ) {
    if (originalMessage.id != null) {
      final responseMessage = UnityMessage(
        id: originalMessage.id,
        type: originalMessage.type,
        payload: {'success': success, 'result': result},
      );
      sendMessageToUnity(responseMessage);
    }
  }

  Future<dynamic> _handleDefaultLogic(UnityMessage message) async {
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
