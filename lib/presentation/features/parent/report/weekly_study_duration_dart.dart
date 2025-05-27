import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:monkey_stories/presentation/widgets/report_card.dart';

class WeeklyStudyDurationChart extends StatelessWidget {
  const WeeklyStudyDurationChart({
    super.key,
    required this.weeklyStudyDuration,
  });

  final List<int> weeklyStudyDuration;

  static const Color thisWeekBarColor = Color(0xFF0077FF);
  static const Color otherWeeksBarColor = Color(0xFFC9EAFF);
  static const Color tooltipBackgroundColor = Color(0xFFFF8AD1);

  @override
  Widget build(BuildContext context) {
    final double maxValFromList =
        weeklyStudyDuration.isEmpty ? 0.0 : weeklyStudyDuration.max.toDouble();

    final double chartMaxY;
    if (maxValFromList <= 0) {
      chartMaxY = 100.0;
    } else {
      chartMaxY = (maxValFromList / 100.0).ceil() * 100.0;
    }

    return ReportCard(
      title: AppLocalizations.of(
        context,
      ).translate('Thời lượng học 4 tuần gần nhất'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                maxY: chartMaxY,
                titlesData: FlTitlesData(
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 40,
                      interval: 100,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barGroups: List.generate(
                  weeklyStudyDuration.length,
                  (index) => makeGroupData(
                    index,
                    weeklyStudyDuration[index].toDouble(),
                    isThisWeek: index == weeklyStudyDuration.length - 1,
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    );
                  },
                  checkToShowHorizontalLine: (value) => value % 100 == 0,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(
                      color: AppTheme.buttonSecondaryDisabledBackground,
                      width: 2,
                    ),
                    left: BorderSide.none,
                    right: BorderSide.none,
                    top: BorderSide.none,
                  ),
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: chartMaxY,
                      color: AppTheme.buttonSecondaryDisabledBackground,
                      strokeWidth: 2,
                      dashArray: [4, 4],
                    ),
                  ],
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => tooltipBackgroundColor,
                    tooltipBorderRadius: BorderRadius.circular(8),
                    tooltipBorder: const BorderSide(color: Colors.transparent),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.round()}p',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          const Divider(
            color: AppTheme.buttonSecondaryDisabledBackground,
            thickness: 1,
          ),
          const SizedBox(height: Spacing.md),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _legendItem(
          context,
          thisWeekBarColor,
          AppLocalizations.of(context).translate('Thời lượng học tuần này'),
        ),
        const SizedBox(height: Spacing.xs),
        _legendItem(
          context,
          otherWeeksBarColor,
          AppLocalizations.of(
            context,
          ).translate('Thời lượng học các tuần trước'),
        ),
      ],
    );
  }

  Widget _legendItem(BuildContext context, Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: Spacing.sm),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            color: const Color(0xFF85888E),
          ),
        ),
      ],
    );
  }

  // Tiêu đề trục Y
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.grey[700],
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value % 100 == 0) {
      text = '${value.toInt()}p';
    } else {
      return Container();
    }
    return SideTitleWidget(
      meta: meta,
      space: 6,
      child: Text(text, style: style),
    );
  }

  // Tạo một cột dữ liệu
  BarChartGroupData makeGroupData(int x, double y, {bool isThisWeek = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 26,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
          color: isThisWeek ? thisWeekBarColor : otherWeeksBarColor,
        ),
      ],
      showingTooltipIndicators: isThisWeek ? [0] : [],
    );
  }
}
