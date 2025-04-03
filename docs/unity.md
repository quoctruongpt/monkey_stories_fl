# Tích hợp và Giao tiếp với Unity trong Dự án Flutter

Tài liệu này mô tả cách giao tiếp giữa ứng dụng Flutter và Unity trong dự án của chúng ta.

## 1. Cấu trúc Hệ thống

Dự án sử dụng thư viện `flutter_embed_unity` để nhúng Unity WebGL vào ứng dụng Flutter. Cách tiếp cận này cho phép:

- Hiển thị nội dung Unity trong giao diện Flutter
- Gửi tin nhắn từ Flutter sang Unity
- Nhận tin nhắn từ Unity gửi sang Flutter
- Xử lý các sự kiện và tương tác giữa hai hệ thống

## 2. Cách Gửi Tin Nhắn Sang Unity

### 2.1. Sử dụng UnityCubit

Cách đơn giản nhất để gửi tin nhắn là thông qua UnityCubit:

```dart
// Import
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';
import 'package:monkey_stories/models/unity_message.dart';

// Gửi tin nhắn không cần phản hồi
final message = UnityMessage(
  type: 'your_message_type',
  payload: {'key': 'value'},
);
context.read<UnityCubit>().sendMessageToUnity(message);

// Gửi tin nhắn và chờ phản hồi
final response = await context.read<UnityCubit>().sendMessageToUnityWithResponse(message);
```

### 2.2. Cấu trúc Tin Nhắn

Mỗi tin nhắn gửi sang Unity có cấu trúc như sau:

```dart
UnityMessage<T>({
  String? id,           // ID của tin nhắn (tự động tạo nếu không cung cấp)
  required String type, // Loại tin nhắn (VD: 'coin', 'user', 'open_unity')
  required T payload,   // Dữ liệu tin nhắn (có thể là bất kỳ kiểu dữ liệu nào)
  bool? response,       // Có yêu cầu phản hồi hay không
})
```

### 2.3. Các Loại Payload Có Sẵn

Dự án đã định nghĩa sẵn một số lớp payload trong `lib/models/unity_payload.dart`:

```dart
// Gửi thông tin hướng màn hình
OrientationPayload({required AppOrientation orientation})

// Gửi thông tin về coin
CoinPayload({String? action, int? amount})
```

### 2.4. Ví Dụ

```dart
// Ví dụ 1: Gửi tin nhắn về hướng màn hình
final message = UnityMessage<OrientationPayload>(
  type: MessageTypes.orientation,
  payload: OrientationPayload(orientation: AppOrientation.portrait),
);
context.read<UnityCubit>().sendMessageToUnity(message);

// Ví dụ 2: Yêu cầu thông tin người dùng và chờ phản hồi
final userMessage = UnityMessage(
  type: MessageTypes.user,
  payload: {},
);
final userData = await context.read<UnityCubit>().sendMessageToUnityWithResponse(userMessage);
```

## 3. Cách Xử Lý Tin Nhắn Từ Unity

### 3.1. Đăng Ký Handler

Để xử lý tin nhắn từ Unity, bạn cần đăng ký handler (hàm xử lý) cho từng loại tin nhắn:

```dart
@override
void initState() {
  super.initState();
  // Đăng ký handler cho tin nhắn loại 'user'
  context.read<UnityCubit>().registerHandler('user', (UnityMessage message) async {
    // Xử lý tin nhắn loại 'user' từ Unity
    return {'id': 1234, 'name': 'John Smith'};  // Dữ liệu phản hồi lại cho Unity
  });
}

@override
void dispose() {
  // Hủy đăng ký handler khi không cần nữa
  context.read<UnityCubit>().unregisterHandler('user');
  super.dispose();
}
```

### 3.2. Xử Lý Tin Nhắn Theo Loại

Mỗi loại tin nhắn từ Unity sẽ được xử lý bởi handler tương ứng. Nếu không có handler đăng ký, hệ thống sẽ sử dụng xử lý mặc định.

### 3.3. Các Loại Tin Nhắn Hệ Thống

Một số loại tin nhắn hệ thống đã được định nghĩa trong `lib/models/unity.dart`:

```dart
class MessageTypes {
  static const String orientation = 'orientation';  // Thay đổi hướng màn hình
  static const String openUnity = 'open_unity';     // Mở Unity view
  static const String closeUnity = 'CloseUnity';    // Đóng Unity view
  static const String coin = 'coin';                // Xử lý liên quan đến coin
  static const String user = 'user';                // Thông tin người dùng
}
```

## 4. Tích Hợp Unity Widget

Để hiển thị nội dung Unity trong Flutter, sử dụng widget `EmbedUnity`:

```dart
EmbedUnity(onMessageFromUnity: _handleUnityMessage)
```

Trong đó `_handleUnityMessage` là hàm xử lý tin nhắn từ Unity:

```dart
Future<void> _handleUnityMessage(String message) async {
  await context.read<UnityCubit>().handleUnityMessage(message);
}
```

## 5. Quản Lý Hiển Thị Unity

UnityCubit cung cấp các phương thức để hiển thị/ẩn Unity:

```dart
// Hiển thị Unity
context.read<UnityCubit>().showUnity();

// Ẩn Unity
context.read<UnityCubit>().hideUnity();
```

## 6. Mô Hình Đồng Bộ và Bất Đồng Bộ

Dự án hỗ trợ cả hai mô hình giao tiếp:

1. **Mô hình đồng bộ**: Gửi tin nhắn mà không cần chờ phản hồi
2. **Mô hình bất đồng bộ**: Gửi tin nhắn và chờ phản hồi từ Unity

## 7. Xử lý Lỗi và Timeout

Khi gửi tin nhắn và chờ phản hồi, hệ thống có cơ chế timeout để tránh treo ứng dụng:

- Thời gian timeout mặc định: 30 giây
- Nếu quá thời gian, Future sẽ throw exception với thông báo 'Unity response timeout'

## 8. Các Bước Tích Hợp Unity Vào Màn Hình Mới

1. Thêm UnityCubit vào BuildContext
2. Đăng ký các handler cần thiết trong initState
3. Sử dụng EmbedUnity widget để hiển thị nội dung Unity
4. Gửi tin nhắn tới Unity khi cần
5. Hủy đăng ký handler trong dispose
