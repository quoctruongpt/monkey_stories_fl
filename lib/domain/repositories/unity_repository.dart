import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';

/// Repository interface định nghĩa các phương thức để tương tác với Unity
///
/// Interface này đảm bảo tính trừu tượng và cho phép dễ dàng thay đổi
/// cách triển khai tương tác với Unity mà không ảnh hưởng đến business logic
abstract class UnityRepository {
  /// Gửi tin nhắn đến Unity mà không cần phản hồi
  ///
  /// [message] tin nhắn cần gửi
  Future<void> sendMessageToUnity(UnityMessageEntity message);

  /// Gửi tin nhắn đến Unity và đợi phản hồi
  ///
  /// [message] tin nhắn cần gửi
  /// Trả về Future với dữ liệu phản hồi từ Unity
  Future<dynamic> sendMessageToUnityWithResponse(UnityMessageEntity message);

  /// Xử lý tin nhắn nhận được từ Unity
  ///
  /// [message] chuỗi JSON nhận được từ Unity
  /// Trả về true nếu tin nhắn được xử lý (có ID khớp với tin nhắn đã gửi)
  Future<bool> handleUnityMessage(String message);

  /// Hiển thị Unity UI
  void showUnity();

  /// Ẩn Unity UI
  void hideUnity();

  /// Đăng ký handler cho một loại tin nhắn cụ thể
  ///
  /// [type] loại tin nhắn cần xử lý
  /// [handler] hàm xử lý tin nhắn
  void registerHandler(String type, Function(UnityMessageEntity) handler);

  /// Hủy đăng ký handler cho một loại tin nhắn
  ///
  /// [type] loại tin nhắn cần hủy handler
  void unregisterHandler(String type);

  /// Kiểm tra trạng thái hiển thị hiện tại của Unity
  ///
  /// Trả về true nếu Unity đang hiển thị
  bool get isUnityVisible;
}
