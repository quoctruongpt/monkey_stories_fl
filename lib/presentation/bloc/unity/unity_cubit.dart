// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

// Project imports:
import 'package:monkey_stories/core/constants/unity_constants.dart';
import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';
import 'package:monkey_stories/domain/usecases/kinesis/put_record_kinesis_usecase.dart';
import 'package:monkey_stories/domain/usecases/tracking/put_event_to_aibridge.dart';
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
  final PutRecordKinesisUsecase _putRecordKinesisUseCase;
  final PutEventToAirbridgeUsecase _putEventToAirbridgeUseCase;

  /// Constructor với dependency injection
  UnityCubit({
    required SendMessageToUnityUseCase sendMessageToUnityUseCase,
    required SendMessageToUnityWithResponseUseCase
    sendMessageToUnityWithResponseUseCase,
    required HandleUnityMessageUseCase handleUnityMessageUseCase,
    required RegisterHandlerUseCase registerHandlerUseCase,
    required UnregisterHandlerUseCase unregisterHandlerUseCase,
    required PutRecordKinesisUsecase putRecordKinesisUseCase,
    required PutEventToAirbridgeUsecase putEventToAirbridgeUseCase,
  }) : _sendMessageToUnityUseCase = sendMessageToUnityUseCase,
       _sendMessageToUnityWithResponseUseCase =
           sendMessageToUnityWithResponseUseCase,
       _handleUnityMessageUseCase = handleUnityMessageUseCase,
       _registerHandlerUseCase = registerHandlerUseCase,
       _unregisterHandlerUseCase = unregisterHandlerUseCase,
       _putRecordKinesisUseCase = putRecordKinesisUseCase,
       _putEventToAirbridgeUseCase = putEventToAirbridgeUseCase,
       super(const UnityState(isUnityVisible: false)) {
    _registerHandlerDefault();
  }

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
        _logger.warning('Message was not handled: $message');
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

  void _registerHandlerDefault() {
    registerHandler(MessageTypes.pushEventToKinesis, (message) async {
      final result = await _putRecordKinesisUseCase(
        PutRecordKinesisUsecaseParams(
          streamName: message.payload['stream_name'],
          partitionKey: message.payload['partition_key'],
          data: message.payload['data'],
        ),
      );

      dynamic resultData;

      result.fold((failure) {}, (success) => resultData = success?.toJson());

      return resultData;
    });

    registerHandler(MessageTypes.putEventToAirbridge, (message) {
      _putEventToAirbridgeUseCase(
        PutEventToAirbridgeParams(
          eventName: message.payload['event_name'],
          semanticProperties: message.payload['semantic_properties'],
          customProperties: message.payload['custom_properties'],
        ),
      );

      return null;
    });
  }

  /// Lấy trạng thái hiển thị của Unity
  bool get isUnityVisible => state.isUnityVisible;
}
