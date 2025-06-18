import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';

// Data class
/// Lớp dữ liệu cho mỗi cột trong biểu đồ
///
/// [label] Nhãn hiển thị dưới cột (tùy chọn)
///
/// [value] Giá trị của cột, quyết định chiều cao của cột
///
/// [color] Màu sắc riêng cho cột này. Nếu không có sẽ dùng defaultBarColor (tùy chọn)
///
/// [tooltipLabel] Nhãn hiển thị trong tooltip. Nếu không có sẽ hiển thị value (tùy chọn)
class BarChartData {
  final String? label;
  final double value;
  final Color? color;
  final String? tooltipLabel;

  const BarChartData({
    this.label,
    required this.value,
    this.color,
    this.tooltipLabel,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarChartData &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          value == other.value &&
          color == other.color &&
          tooltipLabel == other.tooltipLabel;

  @override
  int get hashCode =>
      label.hashCode ^ value.hashCode ^ color.hashCode ^ tooltipLabel.hashCode;
}

// Bar Widget
class _ChartBar extends StatelessWidget {
  const _ChartBar({
    required this.height,
    required this.width,
    required this.color,
    required this.borderRadius,
    required this.animation,
    required this.barKey,
    required this.containerHeight,
  });

  final double height;
  final double width;
  final double containerHeight;
  final Color color;
  final Radius borderRadius;
  final Animation<double> animation;
  final Key barKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: containerHeight,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              key: barKey,
              width: width,
              height: height * animation.value,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: borderRadius,
                  topRight: borderRadius,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Grid Lines Widget
class _ChartGridLines extends StatelessWidget {
  const _ChartGridLines({
    required this.maxValue,
    required this.chartHeight,
    required this.interval,
    required this.labelStyle,
    required this.gridLineColor,
    required this.gridLineWidth,
    required this.dashArray,
    required this.yAxisLabelsWidth,
  });

  final double maxValue;
  final double chartHeight;
  final double interval;
  final TextStyle? labelStyle;
  final Color gridLineColor;
  final double gridLineWidth;
  final List<double>? dashArray;
  final double yAxisLabelsWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChartGridPainter(
        maxValue: maxValue,
        chartHeight: chartHeight,
        interval: interval,
        labelStyle: labelStyle,
        gridLineColor: gridLineColor,
        gridLineWidth: gridLineWidth,
        dashArray: dashArray,
        yAxisLabelsWidth: yAxisLabelsWidth,
        context: context,
      ),
    );
  }
}

// Main Widget
class CustomBarChart extends StatefulWidget {
  /// Tạo một biểu đồ cột tùy chỉnh
  ///
  /// [data] Danh sách dữ liệu để hiển thị trên biểu đồ
  ///
  /// [barWidth] Độ rộng của mỗi cột (mặc định: 30.0)
  ///
  /// [barSpacing] Khoảng cách giữa các cột (mặc định: 15.0)
  ///
  /// [defaultBarColor] Màu mặc định cho các cột nếu không được chỉ định trong data (mặc định: Colors.blue)
  ///
  /// [yAxisLabelStyle] Style cho các nhãn trên trục Y
  ///
  /// [xAxisLabelStyle] Style cho các nhãn trên trục X (nếu có)
  ///
  /// [chartHeight] Chiều cao của biểu đồ, không bao gồm nhãn trục X (mặc định: 200.0)
  ///
  /// [yAxisInterval] Khoảng chia trên trục Y. Ví dụ: 100 sẽ chia thành 0, 100, 200,... (mặc định: 100)
  ///
  /// [showGridLines] Hiển thị các đường lưới ngang (mặc định: true)
  ///
  /// [gridLineColor] Màu của đường lưới (mặc định: Colors.grey)
  ///
  /// [gridLineWidth] Độ dày của đường lưới (mặc định: 0.5)
  ///
  /// [dashArray] Mảng xác định kiểu nét đứt cho đường lưới. Ví dụ: [4, 4] tạo nét đứt 4px và khoảng trắng 4px
  ///
  /// [showTooltips] Hiển thị tooltip khi tap vào cột (mặc định: true)
  ///
  /// [tooltipBackgroundColor] Màu nền của tooltip (mặc định: Colors.pink)
  ///
  /// [tooltipTextStyle] Style cho text trong tooltip
  ///
  /// [yAxisLabelsWidth] Độ rộng dành cho vùng hiển thị nhãn trục Y (mặc định: 30.0)
  ///
  /// [barBorderRadius] Bo góc cho phần đỉnh của cột (mặc định: Radius.circular(6))
  ///
  /// [initiallyActiveTooltipIndex] Index của cột mà tooltip sẽ hiển thị ngay khi khởi tạo
  const CustomBarChart({
    super.key,
    required this.data,
    required this.context,
    this.barWidth = 30.0,
    this.barSpacing = 15.0,
    this.defaultBarColor = Colors.blue,
    this.yAxisLabelStyle,
    this.xAxisLabelStyle,
    this.chartHeight = 200.0,
    this.yAxisInterval = 100,
    this.showGridLines = true,
    this.gridLineColor = Colors.grey,
    this.gridLineWidth = 0.5,
    this.dashArray = const <double>[4, 4],
    this.showTooltips = true,
    this.tooltipBackgroundColor = Colors.pink,
    this.tooltipTextStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ),
    this.yAxisLabelsWidth = 30.0,
    this.barBorderRadius = const Radius.circular(6),
    this.initiallyActiveTooltipIndex,
  });

  final List<BarChartData> data;
  final BuildContext context;
  final double barWidth;
  final double barSpacing;
  final Color defaultBarColor;
  final TextStyle? yAxisLabelStyle;
  final TextStyle? xAxisLabelStyle;
  final double chartHeight;
  final int yAxisInterval;
  final bool showGridLines;
  final Color gridLineColor;
  final double gridLineWidth;
  final List<double>? dashArray;
  final bool showTooltips;
  final Color tooltipBackgroundColor;
  final TextStyle tooltipTextStyle;
  final double yAxisLabelsWidth;
  final Radius barBorderRadius;
  final int? initiallyActiveTooltipIndex;

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  int? _activeIndex;
  final List<GlobalKey> _barKeys = [];
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _barKeys.clear();
    for (var i = 0; i < widget.data.length; i++) {
      _barKeys.add(GlobalKey());
    }

    // Khởi tạo animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Bắt đầu animation khi widget được tạo
    _animationController.forward();

    if (widget.initiallyActiveTooltipIndex != null &&
        widget.initiallyActiveTooltipIndex! >= 0 &&
        widget.initiallyActiveTooltipIndex! < widget.data.length) {
      _activeIndex = widget.initiallyActiveTooltipIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _activeIndex = widget.initiallyActiveTooltipIndex;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Khi kích thước màn hình thay đổi, cập nhật lại state để tính toán lại vị trí tooltip
    if (mounted && _activeIndex != null) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(CustomBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Nếu dữ liệu thay đổi, chạy lại animation
    if (!const ListEquality().equals(
      oldWidget.data.map((e) => e.value).toList(),
      widget.data.map((e) => e.value).toList(),
    )) {
      _animationController.reset();
      _animationController.forward();
    }

    if (oldWidget.data.length != widget.data.length) {
      _barKeys.clear();
      for (var i = 0; i < widget.data.length; i++) {
        _barKeys.add(GlobalKey());
      }
      if (_activeIndex != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _activeIndex = _activeIndex;
            });
          }
        });
      }
    }
  }

  Offset _getBarPosition(int index) {
    if (index < 0 || index >= _barKeys.length) return Offset.zero;

    final RenderBox? renderBox =
        _barKeys[index].currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return Offset.zero;

    return renderBox.localToGlobal(Offset.zero);
  }

  Size _getBarSize(int index) {
    if (index < 0 || index >= _barKeys.length) return Size.zero;

    final RenderBox? renderBox =
        _barKeys[index].currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return Size.zero;

    return renderBox.size;
  }

  double _getTooltipPosition(int index) {
    final barPosition = _getBarPosition(index);
    final barSize = _getBarSize(index);
    final tooltipWidth = _getTooltipWidth(widget.data[index]);

    // Lấy vị trí global của chart
    final RenderBox? chartBox = context.findRenderObject() as RenderBox?;
    if (chartBox == null) return 0;

    // Chuyển đổi vị trí global của bar sang vị trí local trong chart
    final localBarPosition = chartBox.globalToLocal(barPosition);

    // Căn giữa tooltip với bar
    return localBarPosition.dx + (barSize.width - tooltipWidth) / 2;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return SizedBox(
        height:
            widget.chartHeight + (widget.xAxisLabelStyle?.fontSize ?? 12) + 8,
      );
    }

    final maxValueFromData = widget.data.map((d) => d.value).reduce(math.max);
    final maxYValue =
        maxValueFromData == 0
            ? widget.yAxisInterval.toDouble()
            : ((maxValueFromData / widget.yAxisInterval).ceil() + 1) *
                widget.yAxisInterval.toDouble();

    // Tính toán khoảng trống cần thiết cho tooltip
    final tooltipHeight =
        widget.tooltipTextStyle.fontSize! +
        8.0; // Giảm xuống chỉ còn fontSize + 8.0

    return Stack(
      children: [
        GestureDetector(
          onTapDown: (details) {
            if (widget.showTooltips) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              _updateTooltipIndex(localPosition);
            }
          },
          child: SizedBox(
            height:
                widget.chartHeight +
                (widget.xAxisLabelStyle?.fontSize ?? 12) +
                20 +
                tooltipHeight, // Thêm khoảng trống cho tooltip
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: tooltipHeight,
                  ), // Thêm padding phía trên
                  child: Stack(
                    children: [
                      if (widget.showGridLines)
                        Positioned.fill(
                          child: _ChartGridLines(
                            maxValue: maxYValue,
                            chartHeight: widget.chartHeight,
                            interval: widget.yAxisInterval.toDouble(),
                            labelStyle:
                                widget.yAxisLabelStyle ??
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[700],
                                  fontSize: 10,
                                ),
                            gridLineColor: widget.gridLineColor.withValues(
                              alpha: 0.3,
                            ),
                            gridLineWidth: widget.gridLineWidth,
                            dashArray: widget.dashArray,
                            yAxisLabelsWidth: widget.yAxisLabelsWidth,
                          ),
                        ),

                      Padding(
                        padding: EdgeInsets.only(
                          left: widget.yAxisLabelsWidth,
                          right: widget.barSpacing / 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(widget.data.length, (index) {
                            final item = widget.data[index];
                            final barHeight =
                                maxYValue == 0
                                    ? 0.0
                                    : (item.value / maxYValue) *
                                        widget.chartHeight;
                            final barColor =
                                item.color ?? widget.defaultBarColor;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _ChartBar(
                                  height: barHeight,
                                  width: widget.barWidth,
                                  color: barColor,
                                  borderRadius: widget.barBorderRadius,
                                  animation: _animation,
                                  barKey: _barKeys[index],
                                  containerHeight: widget.chartHeight,
                                ),
                                if (item.label != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    item.label!,
                                    style:
                                        widget.xAxisLabelStyle ??
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ] else ...[
                                  SizedBox(
                                    height:
                                        (widget.xAxisLabelStyle?.fontSize ??
                                            12.0) +
                                        4,
                                  ),
                                ],
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Tooltip layer
        if (widget.showTooltips &&
            _activeIndex != null &&
            _activeIndex! < widget.data.length)
          Positioned(
            left: _getTooltipPosition(_activeIndex!),
            top: _getTooltipTopPosition(_activeIndex!),
            child: _buildTooltip(context, widget.data[_activeIndex!]),
          ),
      ],
    );
  }

  double _getTooltipWidth(BarChartData item) {
    final textSpan = TextSpan(
      text:
          item.tooltipLabel ??
          AppLocalizations.of(widget.context).translate(
            'app.short_minutes',
            params: {'value': item.value.round().toString()},
          ),
      style: widget.tooltipTextStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    return textPainter.width + 16.0;
  }

  double _getTooltipTopPosition(int index) {
    final item = widget.data[index];
    final maxValue = widget.data.map((d) => d.value).reduce(math.max);
    final maxYValue =
        maxValue == 0
            ? widget.yAxisInterval.toDouble()
            : ((maxValue / widget.yAxisInterval).ceil() + 1) *
                widget.yAxisInterval.toDouble();

    final barHeight =
        maxYValue == 0 ? 0.0 : (item.value / maxYValue) * widget.chartHeight;

    // Tính vị trí của đỉnh cột
    final barTop = widget.chartHeight - barHeight;

    // Đặt tooltip cách đỉnh cột 12px
    return barTop - 12.0;
  }

  void _updateTooltipIndex(Offset localPosition) {
    for (int i = 0; i < _barKeys.length; i++) {
      final barPosition = _getBarPosition(i);
      final barSize = _getBarSize(i);
      final RenderBox chartBox = context.findRenderObject() as RenderBox;
      final localBarPosition = chartBox.globalToLocal(barPosition);

      if (localPosition.dx >= localBarPosition.dx &&
          localPosition.dx <= localBarPosition.dx + barSize.width &&
          localPosition.dy >= localBarPosition.dy) {
        // Chỉ cập nhật nếu tap vào bar khác với bar hiện tại
        if (_activeIndex != i) {
          setState(() => _activeIndex = i);
        }
        return;
      }
    }
    // Không làm gì khi tap ra ngoài
  }

  Widget _buildTooltip(BuildContext context, BarChartData item) {
    String tooltipText =
        item.tooltipLabel ??
        AppLocalizations.of(widget.context).translate(
          'app.short_minutes',
          params: {'value': item.value.round().toString()},
        );
    final textSpan = TextSpan(
      text: tooltipText,
      style: widget.tooltipTextStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    final double horizontalPadding = 8.0;
    final double verticalPadding = 6.0; // Tăng padding dọc
    final double tailHeight = 4.0;
    final double tailBaseWidth = 8.0;

    final double textWidth = textPainter.width;
    final double textHeight = textPainter.height;

    final double bubbleBodyWidth = textWidth + 2 * horizontalPadding;
    final double bubbleBodyHeight = textHeight + 2 * verticalPadding;

    return SizedBox(
      width: bubbleBodyWidth,
      height: bubbleBodyHeight + tailHeight,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(bubbleBodyWidth, bubbleBodyHeight + tailHeight),
            painter: _TooltipBubblePainter(
              backgroundColor: widget.tooltipBackgroundColor,
              bubbleRadius: const Radius.circular(4),
              tailHeight: tailHeight,
              tailBaseWidth: tailBaseWidth,
              tailTipWidth: tailBaseWidth,
              contentHeight: bubbleBodyHeight,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: verticalPadding,
                bottom: verticalPadding + tailHeight,
              ),
              child: Text(
                tooltipText,
                style: widget.tooltipTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Tooltip Bubble
class _TooltipBubblePainter extends CustomPainter {
  final Color backgroundColor;
  final Radius bubbleRadius;
  final double tailHeight;
  final double tailBaseWidth;
  final double tailTipWidth;
  final double contentHeight;

  _TooltipBubblePainter({
    required this.backgroundColor,
    required this.bubbleRadius,
    required this.tailHeight,
    required this.tailBaseWidth,
    required this.tailTipWidth,
    required this.contentHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill;

    final Path path = Path();
    final double centerX = size.width / 2;
    final radius = 4.0;

    // Vẽ phần thân tooltip với góc bo tròn
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(
      Offset(size.width, radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(size.width, contentHeight - radius);
    path.arcToPoint(
      Offset(size.width - radius, contentHeight),
      radius: Radius.circular(radius),
      clockwise: true,
    );

    // Vẽ phần mũi tên
    path.lineTo(centerX + tailBaseWidth / 2, contentHeight);
    path.lineTo(centerX, size.height);
    path.lineTo(centerX - tailBaseWidth / 2, contentHeight);

    path.lineTo(radius, contentHeight);
    path.arcToPoint(
      Offset(0, contentHeight - radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(0, radius);
    path.arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
      clockwise: true,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TooltipBubblePainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.bubbleRadius != bubbleRadius ||
        oldDelegate.tailHeight != tailHeight ||
        oldDelegate.tailBaseWidth != tailBaseWidth ||
        oldDelegate.tailTipWidth != tailTipWidth ||
        oldDelegate.contentHeight != contentHeight;
  }
}

// Custom Painter for Grid Lines and Y-Axis Labels
class _ChartGridPainter extends CustomPainter {
  final double maxValue;
  final double chartHeight;
  final double interval;
  final TextStyle? labelStyle;
  final Color gridLineColor;
  final double gridLineWidth;
  final List<double>? dashArray;
  final double yAxisLabelsWidth;
  final BuildContext context;

  _ChartGridPainter({
    required this.maxValue,
    required this.chartHeight,
    required this.interval,
    this.labelStyle,
    required this.gridLineColor,
    required this.gridLineWidth,
    this.dashArray,
    required this.yAxisLabelsWidth,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = gridLineColor
          ..strokeWidth = gridLineWidth
          ..style = PaintingStyle.stroke;

    final textStyle =
        labelStyle ?? const TextStyle(color: Colors.black, fontSize: 10);

    if (maxValue <= 0 && interval <= 0) return;

    // Tính số lượng khoảng chia trên trục Y
    final numIntervals = (maxValue / interval).ceil();

    // Vẽ từ 0 đến maxValue (bao gồm cả maxValue)
    for (int i = 0; i <= numIntervals; i++) {
      final currentVal = i * interval;
      final y = chartHeight - (currentVal / maxValue * chartHeight);

      // Chỉ vẽ nếu y nằm trong phạm vi của chart
      if (y >= 0 && y <= chartHeight) {
        // Vẽ grid line
        final path = Path();
        path.moveTo(yAxisLabelsWidth, y);
        path.lineTo(size.width, y);

        // Nếu là dòng min (i == 0), vẽ nét liền
        if (i == 0) {
          canvas.drawPath(path, paint);
        } else if (dashArray != null && dashArray!.isNotEmpty) {
          // Các dòng khác vẽ nét đứt
          canvas.drawPath(
            dashPath(path, dashArray: CircularIntervalList<double>(dashArray!)),
            paint,
          );
        } else {
          canvas.drawPath(path, paint);
        }

        // Vẽ label
        var labelText =
            currentVal == 0
                ? '0'
                : AppLocalizations.of(context).translate(
                  'app.short_minutes',
                  params: {'value': currentVal.round().toString()},
                );
        final tp = TextPainter(
          text: TextSpan(text: labelText, style: textStyle),
          textAlign: TextAlign.right,
          textDirection: TextDirection.ltr,
        );
        tp.layout();

        // Đảm bảo label không bị cắt
        final labelY = y - tp.height / 2;
        if (labelY >= -tp.height / 2 && labelY <= chartHeight - tp.height / 2) {
          tp.paint(canvas, Offset(yAxisLabelsWidth - tp.width - 5, labelY));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ChartGridPainter oldDelegate) {
    return oldDelegate.maxValue != maxValue ||
        oldDelegate.chartHeight != chartHeight ||
        oldDelegate.interval != interval ||
        oldDelegate.labelStyle != labelStyle ||
        oldDelegate.gridLineColor != gridLineColor ||
        oldDelegate.gridLineWidth != gridLineWidth ||
        oldDelegate.dashArray != dashArray ||
        oldDelegate.yAxisLabelsWidth != yAxisLabelsWidth;
  }
}

Path dashPath(Path source, {required CircularIntervalList<double> dashArray}) {
  final Path dest = Path();
  for (final metric in source.computeMetrics()) {
    double distance = 0.0;
    bool draw = true;
    while (distance < metric.length) {
      final double len = dashArray.next;
      if (draw) {
        dest.addPath(metric.extractPath(distance, distance + len), Offset.zero);
      }
      distance += len;
      draw = !draw;
    }
  }
  return dest;
}

class CircularIntervalList<T> {
  CircularIntervalList(this._values);
  final List<T> _values;
  int _idx = 0;
  T get next {
    if (_idx >= _values.length) {
      _idx = 0;
    }
    return _values[_idx++];
  }
}
