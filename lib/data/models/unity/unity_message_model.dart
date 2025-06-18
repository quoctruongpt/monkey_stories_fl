import 'dart:convert';
import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';
import 'package:monkey_stories/data/models/unity/unity_payload_model.dart';

/// Model biểu diễn tin nhắn trao đổi với Unity
class UnityMessageModel extends UnityMessageEntity {
  UnityMessageModel({
    super.id,
    required super.type,
    required super.payload,
    super.response,
  });

  /// Copy model với các giá trị mới
  UnityMessageModel copyWith({
    String? id,
    String? type,
    dynamic payload,
    bool? response,
  }) {
    return UnityMessageModel(
      id: id ?? this.id,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      response: response ?? this.response,
    );
  }

  /// Chuyển từ entity sang model
  factory UnityMessageModel.fromEntity(UnityMessageEntity entity) {
    return UnityMessageModel(
      id: entity.id,
      type: entity.type,
      payload: entity.payload,
      response: entity.response,
    );
  }

  /// Chuyển model thành JSON string để gửi đến Unity
  String toJsonString() {
    return jsonEncode({
      'id': id,
      'type': type,
      'payload':
          payload is UnityPayloadModel
              ? (payload as UnityPayloadModel).toJson()
              : payload is Map
              ? payload
              : payload.toString(),
      'response': response,
    });
  }

  /// Parse JSON thành model
  factory UnityMessageModel.fromJson(Map<String, dynamic> json) {
    return UnityMessageModel(
      id: json['id'] as String?,
      type: json['type'] as String,
      payload: json['payload'],
      response: json['response'] as bool?,
    );
  }

  /// Chuyển sang JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'payload':
          payload is UnityPayloadModel
              ? (payload as UnityPayloadModel).toJson()
              : payload,
      'response': response,
    };
  }
}
