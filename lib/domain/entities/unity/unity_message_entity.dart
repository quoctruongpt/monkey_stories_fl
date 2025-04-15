/// Entity mô tả một tin nhắn trao đổi giữa Flutter và Unity
///
/// [id] - ID duy nhất của tin nhắn, dùng để theo dõi phản hồi
/// [type] - Loại tin nhắn, xác định hành động cần thực hiện
/// [payload] - Dữ liệu kèm theo tin nhắn
/// [response] - Có yêu cầu phản hồi không
class UnityMessageEntity<T> {
  final String? id;
  final String type;
  final T payload;
  final bool? response;

  const UnityMessageEntity({
    this.id,
    required this.type,
    required this.payload,
    this.response,
  });
}
