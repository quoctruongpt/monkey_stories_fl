import 'package:flutter/material.dart';
import 'package:monkey_stories/presentation/widgets/setting_item_widget.dart';

// Giả sử 'item' trong SettingItemWidget(item: item) là một đối tượng (class instance)
// có thuộc tính 'isVisibleGetter' là một Function có thể null.
// Ví dụ: class SettingItemData { Future<bool> Function(BuildContext)? isVisibleGetter; ... }
// Vì không có định nghĩa kiểu cụ thể, chúng ta sẽ dùng 'dynamic'.

class EnhancedSettingItem extends StatelessWidget {
  final dynamic
  currentItemModel; // Kiểu dữ liệu của các phần tử trong section['items']
  final dynamic nextItemModel; // Cùng kiểu trên, hoặc null nếu là phần tử cuối

  const EnhancedSettingItem({
    super.key,
    required this.currentItemModel,
    this.nextItemModel,
  });

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem currentItemModel có isVisibleGetter không
    // Nếu không, coi như nó luôn hiển thị (Future.value(true))
    final bool hasCurrentVisibilityGetter =
        currentItemModel.isVisibleGetter != null;
    Future<bool> currentItemVisibilityFuture =
        hasCurrentVisibilityGetter
            ? currentItemModel.isVisibleGetter!(context)
            : Future.value(true);

    return FutureBuilder<bool>(
      future: currentItemVisibilityFuture,
      builder: (context, currentSnapshot) {
        // Xử lý trạng thái loading cho current item
        if (currentSnapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink(); // Đang tải, không hiển thị gì
        }

        // Xử lý lỗi hoặc khi current item không hiển thị
        if (currentSnapshot.hasError || !(currentSnapshot.data ?? false)) {
          return const SizedBox.shrink(); // Lỗi hoặc không hiển thị
        }

        // Tại điểm này, currentItemModel được xác nhận là HIỂN THỊ.
        final Widget visibleCurrentItemWidget = SettingItemWidget(
          item: currentItemModel,
        );

        // Nếu không có nextItemModel, không cần Divider. Chỉ hiển thị current item.
        if (nextItemModel == null) {
          return visibleCurrentItemWidget;
        }

        // Có nextItemModel. Kiểm tra khả năng hiển thị của nó để quyết định Divider.
        final bool hasNextVisibilityGetter =
            nextItemModel!.isVisibleGetter != null;
        Future<bool> nextItemVisibilityFuture =
            hasNextVisibilityGetter
                ? nextItemModel!.isVisibleGetter!(context)
                : Future.value(true);

        return FutureBuilder<bool>(
          future: nextItemVisibilityFuture,
          builder: (context, nextSnapshot) {
            Widget potentialDivider;

            if (nextSnapshot.connectionState == ConnectionState.waiting) {
              // nextItemModel đang tải. currentItemModel hiển thị, nhưng chưa quyết định Divider.
              potentialDivider =
                  const SizedBox.shrink(); // Tạm thời không có Divider
            } else if (nextSnapshot.hasError || !(nextSnapshot.data ?? false)) {
              // nextItemModel lỗi hoặc không hiển thị.
              potentialDivider = const SizedBox.shrink(); // Không có Divider
            } else {
              // nextItemModel cũng hiển thị.
              potentialDivider = const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFE5E5E5),
              );
            }

            return Column(
              mainAxisSize:
                  MainAxisSize.min, // Quan trọng cho Column trong ListView
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                visibleCurrentItemWidget,
                potentialDivider, // Sẽ là SizedBox.shrink() nếu không có Divider
              ],
            );
          },
        );
      },
    );
  }
}
