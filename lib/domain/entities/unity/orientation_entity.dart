import 'package:monkey_stories/core1/constants/unity_constants.dart';

/// Lớp đóng gói thông tin định hướng màn hình
/// Lưu ý: Giá trị enum được định nghĩa trong [AppOrientation]
class OrientationEntity {
  final AppOrientation orientation;

  const OrientationEntity(this.orientation);

  /// Chuyển đổi từ giá trị int sang đối tượng OrientationEntity
  factory OrientationEntity.fromValue(int value) {
    return OrientationEntity(AppOrientation.fromValue(value));
  }
}
