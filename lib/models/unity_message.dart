// Class message với generic payload
import 'dart:convert';

class UnityMessage {
  final String? id;
  final String type;
  final bool? response;
  final dynamic payload;

  UnityMessage({
    this.id,
    required this.type,
    required this.payload,
    this.response,
  });

  UnityMessage copyWith({String? id, bool? response}) {
    return UnityMessage(
      id: id ?? this.id,
      type: type,
      payload: payload,
      response: response ?? this.response,
    );
  }

  // Chuyển thành JSON string để gửi
  String toJsonString() {
    return jsonEncode({
      'id': id,
      'type': type,
      'payload': payload is Map ? payload : payload.toString(),
      'response': response,
    });
  }

  // Factory constructor để parse JSON thành UnityMessage
  factory UnityMessage.fromJson(Map<String, dynamic> json) {
    return UnityMessage(
      id: json['id'] as String?,
      type: json['type'] as String,
      payload: json['payload'],
      response: json['response'],
    );
  }

  @override
  String toString() {
    return 'UnityMessage(type: $type, payload: $payload)';
  }
}
