import 'dart:math';
import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';

class PieChartData {
  final double value;
  final String label;

  PieChartData({required this.value, required this.label});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PieChartData &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          label == other.label;

  @override
  int get hashCode => value.hashCode ^ label.hashCode;
}

class CustomPieChart extends StatefulWidget {
  final List<PieChartData> data;
  final double radius;
  final String? emptyDataLabel;
  final String? otherLevelsLabel;
  final String Function(int) getLabel;

  const CustomPieChart({
    super.key,
    required this.data,
    this.radius = 120,
    this.emptyDataLabel,
    this.otherLevelsLabel,
    required this.getLabel,
  });

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<PieChartData>? _oldData;
  bool _showAllLegends = false;
  List<PieChartData>? _cachedChartData;
  List<PieChartData>? _cachedSortedData;

  static const double kMinValidValue = 0.0;
  static const int kMaxVisibleItems = 2;

  // Định nghĩa các màu cố định cho chart
  static const Color kFirstItemColor = Color(0xFF0077FF); // Xanh đậm
  static const Color kSecondItemColor = Color(0xFF66ADFF); // Xanh nhạt
  static const Color kThirdItemColor = Color(0xFFB3D7FF); // Xanh rất nhạt
  static const Color kEmptyDataColor = Color(
    0xFFEBF3FF,
  ); // Màu khi không có dữ liệu

  List<PieChartData> _getChartData() {
    // Kiểm tra cache
    if (_cachedChartData != null && _listEquals(_oldData!, widget.data)) {
      return _cachedChartData!;
    }

    // Lọc ra các item có giá trị > 0 và cache lại kết quả
    final validData =
        widget.data.where((item) => item.value > kMinValidValue).toList();

    // Nếu không có dữ liệu hoặc không có item nào có giá trị > 0
    if (widget.data.isEmpty || validData.isEmpty) {
      _cachedChartData = [
        PieChartData(value: kMinValidValue, label: widget.emptyDataLabel ?? ''),
      ];
      return _cachedChartData!;
    }

    final total = validData.fold(
      kMinValidValue,
      (sum, item) => sum + item.value,
    );

    // Nếu tổng = 0, trả về chart trống
    if (total <= kMinValidValue) {
      _cachedChartData = [
        PieChartData(value: kMinValidValue, label: widget.emptyDataLabel ?? ''),
      ];
      return _cachedChartData!;
    }

    // Sắp xếp data theo giá trị giảm dần
    validData.sort((a, b) => b.value.compareTo(a.value));

    // Tạo danh sách mới với 3 phần cho chart
    final result = <PieChartData>[];

    // Tính phần trăm chính xác cho từng phần
    if (validData.length > kMaxVisibleItems) {
      final firstValue = validData[0].value;
      final secondValue = validData[1].value;
      final remainingValue = validData
          .sublist(kMaxVisibleItems)
          .fold(kMinValidValue, (sum, item) => sum + item.value);

      final parts = [
        (value: firstValue, label: validData[0].label),
        (value: secondValue, label: validData[1].label),
        (value: remainingValue, label: widget.otherLevelsLabel ?? ''),
      ];

      parts.sort((a, b) => b.value.compareTo(a.value));

      final firstPercentage = (parts[0].value / total * 100).floorToDouble();
      final secondPercentage = (parts[1].value / total * 100).floorToDouble();
      final remainingPercentage = 100 - firstPercentage - secondPercentage;

      result.addAll([
        PieChartData(value: firstPercentage, label: parts[0].label),
        PieChartData(value: secondPercentage, label: parts[1].label),
        PieChartData(value: remainingPercentage, label: parts[2].label),
      ]);
    } else if (validData.length == kMaxVisibleItems) {
      final firstPercentage =
          (validData[0].value / total * 100).floorToDouble();
      final secondPercentage = 100 - firstPercentage;

      result.addAll([
        PieChartData(value: firstPercentage, label: validData[0].label),
        PieChartData(value: secondPercentage, label: validData[1].label),
      ]);
    } else {
      result.add(PieChartData(value: 100, label: validData[0].label));
    }

    _cachedChartData = result;
    return result;
  }

  List<PieChartData> _getSortedData() {
    // Kiểm tra cache
    if (_cachedSortedData != null && _listEquals(_oldData!, widget.data)) {
      return _cachedSortedData!;
    }

    // Lọc ra các item có giá trị > 0
    final validData =
        widget.data.where((item) => item.value > kMinValidValue).toList();

    // Nếu không có dữ liệu hoặc không có item nào có giá trị > 0
    if (widget.data.isEmpty || validData.isEmpty) {
      _cachedSortedData = [
        PieChartData(value: kMinValidValue, label: widget.emptyDataLabel ?? ''),
      ];
      return _cachedSortedData!;
    }

    // Sắp xếp theo giá trị giảm dần
    final sortedData = List<PieChartData>.from(validData)
      ..sort((a, b) => b.value.compareTo(a.value));
    _cachedSortedData = sortedData;
    return sortedData;
  }

  Color _getColorForIndex(int index) {
    // Cache kết quả kiểm tra dữ liệu trống
    final isEmptyData =
        widget.data.isEmpty ||
        !widget.data.any((item) => item.value > kMinValidValue) ||
        widget.data.fold(kMinValidValue, (sum, item) => sum + item.value) <=
            kMinValidValue;

    if (isEmptyData) {
      return kEmptyDataColor;
    }

    switch (index) {
      case 0:
        return kFirstItemColor;
      case 1:
        return kSecondItemColor;
      default:
        return kThirdItemColor;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _oldData = List.from(widget.data);
    _controller.forward();
  }

  @override
  void didUpdateWidget(CustomPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_oldData != null && !_listEquals(_oldData!, widget.data)) {
      _oldData = List.from(widget.data);
      _cachedChartData = null;
      _cachedSortedData = null;
      _controller.forward(from: 0);
    }
  }

  bool _listEquals(List<PieChartData> a, List<PieChartData> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _controller.dispose();
    _cachedChartData = null;
    _cachedSortedData = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sortedData = _getSortedData();
    final chartData = _getChartData();
    final total =
        widget.data.isEmpty
            ? 0.0
            : widget.data
                .where((item) => item.value > 0)
                .fold(0.0, (sum, item) => sum + item.value);

    return Column(
      children: [
        SizedBox(
          width: widget.radius * 2,
          height: widget.radius * 2,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: PieChartPainter(
                  data: chartData,
                  progress: _animation.value,
                  getColorForIndex: _getColorForIndex,
                  emptyColor: kEmptyDataColor,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        ChartLegend(
          data: sortedData,
          showAll: _showAllLegends,
          onToggle: () => setState(() => _showAllLegends = !_showAllLegends),
          getColorForIndex: _getColorForIndex,
          emptyColor: kEmptyDataColor,
          total: total,
          getLabel: widget.getLabel,
          otherLevelsLabel: widget.otherLevelsLabel ?? '',
        ),
      ],
    );
  }
}

class ChartLegend extends StatelessWidget {
  final List<PieChartData> data;
  final bool showAll;
  final VoidCallback onToggle;
  final Color Function(int) getColorForIndex;
  final Color emptyColor;
  final double total;
  final String Function(int) getLabel;
  final String otherLevelsLabel;

  const ChartLegend({
    super.key,
    required this.data,
    required this.showAll,
    required this.onToggle,
    required this.getColorForIndex,
    required this.emptyColor,
    required this.total,
    required this.getLabel,
    required this.otherLevelsLabel,
  });

  List<Widget> _buildLegendItems() {
    // Nếu không có dữ liệu hoặc tổng = 0
    if (data.isEmpty || total <= 0) {
      return [
        const Text(
          'Chưa có dữ liệu thống kê',
          style: TextStyle(fontSize: 14, color: Color(0xFF94969C)),
        ),
      ];
    }

    String _formatValue(double value) {
      return getLabel(value.toInt());
    }

    // Tạo map để lưu trữ thứ tự của các label dựa trên giá trị
    final valueOrder = <String, int>{};
    final validData = data.where((item) => item.value > 0).toList();

    if (validData.length > 2) {
      // Tính giá trị của các phần
      final parts = [
        (value: validData[0].value, label: validData[0].label),
        (value: validData[1].value, label: validData[1].label),
        (
          value: validData
              .sublist(2)
              .fold(0.0, (sum, item) => sum + item.value),
          label: otherLevelsLabel,
        ),
      ];

      // Sắp xếp theo giá trị và lưu thứ tự
      parts.sort((a, b) => b.value.compareTo(a.value));
      for (var i = 0; i < parts.length; i++) {
        valueOrder[parts[i].label] = i;
      }
    }

    // if (data.length <= 3 || showAll) {
    //   final items = data.where((item) => item.value > 0).toList();
    //   return items.map((item) {
    //     // Nếu là một trong 2 item đầu tiên hoặc là "Các level khác", sử dụng thứ tự từ valueOrder
    //     final order = valueOrder[item.label] ?? items.indexOf(item);
    //     return _LegendItem(
    //       color: getColorForIndex(order),
    //       label: item.label,
    //       value: _formatValue(item.value),
    //     );
    //   }).toList();
    // }

    // Hiển thị 2 item đầu và gộp các item còn lại
    final List<Widget> items = [];
    double remainingValue = 0;

    // Lọc ra danh sách các item có giá trị > 0
    final validItems = data.where((item) => item.value > 0).toList();

    // Thêm tối đa 2 item đầu tiên
    for (int i = 0; i < min(2, validItems.length); i++) {
      final order = valueOrder[validItems[i].label] ?? i;
      items.add(
        _LegendItem(
          color: getColorForIndex(order),
          label: validItems[i].label,
          value: _formatValue(validItems[i].value),
        ),
      );
    }

    // Tính tổng các item còn lại nếu có
    if (validItems.length > 2) {
      remainingValue = validItems
          .sublist(2)
          .fold(0.0, (sum, item) => sum + item.value);

      if (remainingValue > 0) {
        final order = valueOrder[otherLevelsLabel] ?? 2;
        if (showAll || validItems.length == 3) {
          for (var item in validItems.sublist(2)) {
            items.add(
              _LegendItem(
                color: getColorForIndex(order),
                label: item.label,
                value: _formatValue(item.value),
              ),
            );
          }
        } else {
          items.add(
            _LegendItem(
              color: getColorForIndex(order),
              label: otherLevelsLabel,
              value: _formatValue(remainingValue),
            ),
          );
        }
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ..._buildLegendItems(),
        const SizedBox(height: 8),
        if (data.where((item) => item.value > 0).length > 3) ...[
          Divider(color: Colors.grey.withOpacity(0.2), height: 1),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onToggle,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      showAll
                          ? AppLocalizations.of(context).translate('app.hide')
                          : AppLocalizations.of(context).translate('app.show'),
                      style: const TextStyle(
                        color: Color(0xFF61646C),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      showAll
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                      color: const Color(0xFF61646C),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: 230,
        child: Row(
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF475467),
                  ),
                ),
              ],
            ),
            const Spacer(),

            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475467),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<PieChartData> data;
  final double progress;
  final Color Function(int) getColorForIndex;
  final Color emptyColor;

  static const double kMinPercentageForLabel = 5.0;
  static const double kLabelAnimationThreshold = 0.8;
  static const double kInnerRadiusRatio = 0.5;

  PieChartPainter({
    required this.data,
    required this.progress,
    required this.getColorForIndex,
    required this.emptyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final innerRadius = radius * kInnerRadiusRatio;

    // Cache tổng giá trị
    final total = data.fold(0.0, (sum, item) => sum + item.value);
    double startAngle = -pi / 2;

    // Tạo và cache các Paint objects
    final backgroundPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.grey.withOpacity(0.1);

    final holePaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white;

    // Vẽ background
    canvas.drawCircle(center, radius, backgroundPaint);

    // Cache rect cho việc vẽ arc
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Cache các giá trị cho label
    final labelRadius = (radius + innerRadius) / 2;
    final labelOpacity =
        progress > kLabelAnimationThreshold
            ? (progress - kLabelAnimationThreshold) * 5
            : 0.0;

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = 2 * pi * (item.value / total) * progress;

      // Vẽ phần pie
      final paint =
          Paint()
            ..style = PaintingStyle.fill
            ..color = getColorForIndex(i);

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);

      // Vẽ label nếu đủ điều kiện
      if (item.value >= kMinPercentageForLabel &&
          progress > kLabelAnimationThreshold) {
        _drawLabel(
          canvas,
          center,
          startAngle,
          sweepAngle,
          labelRadius,
          item.value,
          labelOpacity,
        );
      }

      startAngle += sweepAngle;
    }

    // Vẽ lỗ trống ở giữa
    canvas.drawCircle(center, innerRadius * progress, holePaint);
  }

  void _drawLabel(
    Canvas canvas,
    Offset center,
    double startAngle,
    double sweepAngle,
    double labelRadius,
    double value,
    double opacity,
  ) {
    final labelAngle = startAngle + sweepAngle / 2;
    final labelX = center.dx + labelRadius * cos(labelAngle);
    final labelY = center.dy + labelRadius * sin(labelAngle);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${value.toInt()}%',
        style: TextStyle(
          color: Colors.white.withOpacity(opacity),
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito',
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant PieChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.data.length != data.length ||
        !_listEquals(oldDelegate.data, data);
  }

  bool _listEquals(List<PieChartData> a, List<PieChartData> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
