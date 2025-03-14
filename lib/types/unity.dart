// Class message với generic payload
import 'dart:convert';

class UnityMessage<T> {
  final String? id;
  final String type;
  final T payload;

  UnityMessage({this.id, required this.type, required this.payload});

  UnityMessage<T> copyWith({String? id}) {
    return UnityMessage(id: id ?? this.id, type: type, payload: payload);
  }

  // Chuyển thành JSON string để gửi
  String toJsonString() {
    return jsonEncode({
      'id': id,
      'type': type,
      'payload': payload is Map ? payload : payload.toString(),
    });
  }

  // Factory constructor để parse JSON thành UnityMessage
  factory UnityMessage.fromJson(Map<String, dynamic> json) {
    return UnityMessage(
      id: json['id'] as String?,
      type: json['type'] as String,
      payload: json['payload'],
    );
  }
}
