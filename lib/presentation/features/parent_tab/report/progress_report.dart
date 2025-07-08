// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/report_card.dart';

/// Lớp chứa dữ liệu cho mỗi mục tiến độ.
class ProgressData {
  const ProgressData({
    required this.id,
    required this.title,
    this.value = 0,
    this.total = 0,
  });

  /// Định danh duy nhất cho mỗi cấp độ.
  final Object id;

  /// Tiêu đề của cấp độ.
  final String title;

  /// Giá trị tiến độ hiện tại.
  final int value;

  /// Tổng giá trị tiến độ.
  final int total;
}

/// Widget hiển thị báo cáo tiến độ học tập.
///
/// Widget này có thể hiển thị một cấp độ được chọn và một danh sách
/// các cấp độ khác có thể được mở rộng hoặc thu gọn.
class ProgressReport extends StatefulWidget {
  const ProgressReport({
    super.key,
    required this.progressData,
    required this.selectedLevelId,
    this.title = '',
    this.icon = const SizedBox.shrink(),
    this.onShowMore,
    this.onShowLess,
  });

  /// Danh sách dữ liệu tiến độ của các cấp độ.
  final List<ProgressData> progressData;

  /// ID của cấp độ đang được chọn để hiển thị mặc định.
  final Object selectedLevelId;

  /// Tiêu đề của thẻ báo cáo.
  final String title;

  /// Biểu tượng hiển thị bên cạnh tiêu đề.
  final Widget icon;

  /// Callback được gọi khi người dùng nhấn "Xem thêm".
  final VoidCallback? onShowMore;

  /// Callback được gọi khi người dùng nhấn "Ẩn bớt".
  final VoidCallback? onShowLess;

  @override
  State<ProgressReport> createState() => _ProgressReportState();
}

class _ProgressReportState extends State<ProgressReport> {
  bool _isExpanded = false;

  /// Xây dựng widget cho cấp độ được chọn (chế độ thu gọn).
  Widget _buildSelectedLevel() {
    final selectedLevel = widget.progressData.firstWhere(
      (level) => level.id == widget.selectedLevelId,
      orElse: () {
        if (widget.progressData.isNotEmpty) {
          return widget.progressData.first;
        }
        return const ProgressData(id: '', title: 'No data');
      },
    );

    return ProgressItem(
      title: selectedLevel.title,
      value: selectedLevel.value,
      total: selectedLevel.total,
    );
  }

  /// Xây dựng danh sách tất cả các cấp độ theo thứ tự (chế độ mở rộng).
  Widget _buildAllLevelsInOrder() {
    final widgets = <Widget>[];
    for (int i = 0; i < widget.progressData.length; i++) {
      widgets.add(
        ProgressItem(
          title: widget.progressData[i].title,
          value: widget.progressData[i].value,
          total: widget.progressData[i].total,
        ),
      );
      if (i < widget.progressData.length - 1) {
        widgets.add(
          const Divider(
            height: Spacing.md * 2,
            thickness: 1,
            color: Color(0xFFF5F5F6),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      title: widget.title,
      iconWidget: widget.icon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCrossFade(
            firstChild: _buildSelectedLevel(),
            secondChild: _buildAllLevelsInOrder(),
            crossFadeState:
                _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          const SizedBox(height: Spacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                if (_isExpanded) {
                  widget.onShowLess?.call();
                } else {
                  widget.onShowMore?.call();
                }
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded
                        ? AppLocalizations.of(context).translate('app.hide')
                        : AppLocalizations.of(context).translate('app.show'),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF61646C),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF61646C),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget hiển thị một mục tiến độ duy nhất với tiêu đề,
/// thanh tiến trình và giá trị phần trăm.
class ProgressItem extends StatelessWidget {
  const ProgressItem({
    super.key,
    required this.title,
    this.value = 0,
    this.total = 0,
  });

  /// Tiêu đề của mục tiến độ.
  final String title;

  /// Giá trị tiến độ hiện tại.
  final int value;

  /// Tổng giá trị tiến độ.
  final int total;

  double _calculateProgress() {
    if (total == 0) return 0.0;
    return value / total;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyLarge),
        Text(
          '${(progress * 100).toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: Spacing.md),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: const Color(0xFFE4F5FF),
          color: const Color(0xFF0077FF),
          minHeight: 16,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: Spacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$value', style: Theme.of(context).textTheme.labelLarge),
            Text('$total', style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ],
    );
  }
}
