import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/report_card.dart';
import 'package:monkey_stories/presentation/widgets/custom_bar_chart.dart';
import 'dart:math' as math;

class WeeklyStudyDurationChart extends StatefulWidget {
  const WeeklyStudyDurationChart({
    super.key,
    required this.weeklyStudyDuration,
  });

  final List<int> weeklyStudyDuration;

  static const Color thisWeekBarColor = Color(0xFF0077FF);
  static const Color otherWeeksBarColor = Color(0xFFC9EAFF);
  static const Color tooltipBackgroundColor = Color(0xFFFF8AD1);

  @override
  State<WeeklyStudyDurationChart> createState() =>
      _WeeklyStudyDurationChartState();
}

class _WeeklyStudyDurationChartState extends State<WeeklyStudyDurationChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<BarChartData> chartDataCustom = List.generate(
      widget.weeklyStudyDuration.length,
      (index) => BarChartData(
        value: widget.weeklyStudyDuration[index].toDouble(),
        color:
            index == widget.weeklyStudyDuration.length - 1
                ? WeeklyStudyDurationChart.thisWeekBarColor
                : WeeklyStudyDurationChart.otherWeeksBarColor,
        tooltipLabel: '${widget.weeklyStudyDuration[index]}p',
      ),
    );

    return ReportCard(
      title: AppLocalizations.of(
        context,
      ).translate('Thời lượng học 4 tuần gần nhất'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: CustomBarChart(
              data: chartDataCustom,
              chartHeight: 220,
              barWidth: 40,
              barSpacing: 25,
              yAxisInterval:
                  widget.weeklyStudyDuration.reduce(math.max) < 100 ? 10 : 100,
              yAxisLabelsWidth: 35,
              defaultBarColor: WeeklyStudyDurationChart.otherWeeksBarColor,
              initiallyActiveTooltipIndex:
                  chartDataCustom.isNotEmpty
                      ? chartDataCustom.length - 1
                      : null,
              tooltipBackgroundColor:
                  WeeklyStudyDurationChart.tooltipBackgroundColor,
              tooltipTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              yAxisLabelStyle: const TextStyle(
                color: Color(0xFFCECFD2),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              barBorderRadius: const Radius.circular(6),
              showGridLines: true,
              gridLineColor: Colors.grey,
              dashArray: const <double>[4, 4],
            ),
          ),
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
          WeeklyStudyDurationChart.thisWeekBarColor,
          AppLocalizations.of(context).translate('Thời lượng học tuần này'),
        ),
        const SizedBox(height: Spacing.xs),
        _legendItem(
          context,
          WeeklyStudyDurationChart.otherWeeksBarColor,
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
}
