import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';
import 'package:monkey_stories/domain/usecases/unity/handle_unity_message_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/register_handler_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/send_message_to_unity_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/send_message_to_unity_with_response_usecase.dart';
import 'package:monkey_stories/domain/usecases/unity/unregister_handler_usecase.dart';

part 'unity_state.dart';

/// Cubit quản lý tương tác với Unity
class UnityCubit extends Cubit<UnityState> {
  final Logger _logger = Logger('UnityCubit');

  // Use cases
  final SendMessageToUnityUseCase _sendMessageToUnityUseCase;
  final SendMessageToUnityWithResponseUseCase
  _sendMessageToUnityWithResponseUseCase;
  final HandleUnityMessageUseCase _handleUnityMessageUseCase;
  final RegisterHandlerUseCase _registerHandlerUseCase;
  final UnregisterHandlerUseCase _unregisterHandlerUseCase;

  /// Constructor với dependency injection
  UnityCubit({
    required SendMessageToUnityUseCase sendMessageToUnityUseCase,
    required SendMessageToUnityWithResponseUseCase
    sendMessageToUnityWithResponseUseCase,
    required HandleUnityMessageUseCase handleUnityMessageUseCase,
    required RegisterHandlerUseCase registerHandlerUseCase,
    required UnregisterHandlerUseCase unregisterHandlerUseCase,
  }) : _sendMessageToUnityUseCase = sendMessageToUnityUseCase,
       _sendMessageToUnityWithResponseUseCase =
           sendMessageToUnityWithResponseUseCase,
       _handleUnityMessageUseCase = handleUnityMessageUseCase,
       _registerHandlerUseCase = registerHandlerUseCase,
       _unregisterHandlerUseCase = unregisterHandlerUseCase,
       super(const UnityState(isUnityVisible: false));

  void setUnityLoading(bool isUnityLoading) {
    emit(state.copyWith(isUnityLoading: isUnityLoading));
  }

  /// Hiển thị Unity
  void showUnity() {
    _logger.info('showUnity: ${state.isUnityVisible}');
    emit(state.copyWith(isUnityVisible: true));
  }

  /// Ẩn Unity
  void hideUnity() {
    _logger.info('hideUnity: ${state.isUnityVisible}');
    emit(state.copyWith(isUnityVisible: false));
  }

  /// Gửi tin nhắn đến Unity (không cần phản hồi)
  Future<void> sendMessageToUnity(UnityMessageEntity message) async {
    try {
      await _sendMessageToUnityUseCase(message);
    } catch (e) {
      _logger.severe('Error sending message to Unity: $e');
    }
  }

  /// Gửi tin nhắn đến Unity và đợi phản hồi
  Future<dynamic> sendMessageToUnityWithResponse(
    UnityMessageEntity message,
  ) async {
    try {
      final response = await _sendMessageToUnityWithResponseUseCase(message);

      return response;
    } catch (e) {
      _logger.severe('Error sending message to Unity with response: $e');
      rethrow;
    }
  }

  /// Xử lý tin nhắn từ Unity
  Future<void> handleUnityMessage(String message) async {
    try {
      final wasHandled = await _handleUnityMessageUseCase(message);

      if (!wasHandled) {
        _logger.info('Message was not handled: $message');
      }
    } catch (e) {
      _logger.severe('Error handling Unity message: $e');
    }
  }

  /// Đăng ký handler cho một loại tin nhắn
  void registerHandler(String type, Function(UnityMessageEntity) handler) {
    _registerHandlerUseCase(type, handler);
  }

  /// Hủy đăng ký handler
  void unregisterHandler(String type) {
    _unregisterHandlerUseCase(type);
  }

  /// Lấy trạng thái hiển thị của Unity
  bool get isUnityVisible => state.isUnityVisible;
}
