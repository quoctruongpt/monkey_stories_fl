import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/report_card.dart';

enum PhonicsLevelSelected { nursery, kindergarten, grade1 }

class ProgressReport extends StatefulWidget {
  const ProgressReport({
    super.key,
    this.nurseryTotalLessons = 0,
    this.kindergartenTotalLessons = 0,
    this.grade1TotalLessons = 0,
    this.nurseryValue = 0,
    this.kindergartenValue = 0,
    this.grade1Value = 0,
    this.phonicsLevelSelected = PhonicsLevelSelected.nursery,
    this.title = '',
    this.icon = const SizedBox.shrink(),
  });

  final int nurseryTotalLessons;
  final int kindergartenTotalLessons;
  final int grade1TotalLessons;
  final int nurseryValue;
  final int kindergartenValue;
  final int grade1Value;
  final PhonicsLevelSelected phonicsLevelSelected;

  final String title;
  final Widget icon;

  @override
  State<ProgressReport> createState() => _ProgressReportState();
}

class _ProgressReportState extends State<ProgressReport> {
  bool _isExpanded = false;

  Map<String, dynamic> _getLevelData(PhonicsLevelSelected level) {
    switch (level) {
      case PhonicsLevelSelected.nursery:
        return {
          'title': AppLocalizations.of(
            context,
          ).translate('app.report.progress.nursery'),
          'value': widget.nurseryValue,
          'total': widget.nurseryTotalLessons,
        };
      case PhonicsLevelSelected.kindergarten:
        return {
          'title': AppLocalizations.of(
            context,
          ).translate('app.report.progress.kindergarten'),
          'value': widget.kindergartenValue,
          'total': widget.kindergartenTotalLessons,
        };
      case PhonicsLevelSelected.grade1:
        return {
          'title': AppLocalizations.of(
            context,
          ).translate('app.report.progress.grade1'),
          'value': widget.grade1Value,
          'total': widget.grade1TotalLessons,
        };
    }
  }

  Widget _buildSelectedLevel() {
    final data = _getLevelData(widget.phonicsLevelSelected);
    return ProgressItem(
      title: data['title'],
      value: data['value'],
      total: data['total'],
    );
  }

  List<Widget> _buildRemainingLevels() {
    final levels =
        PhonicsLevelSelected.values
            .where((level) => level != widget.phonicsLevelSelected)
            .map(_getLevelData)
            .toList();

    levels.sort((a, b) => b['value'].compareTo(a['value']));

    final widgets = <Widget>[];
    for (int i = 0; i < levels.length; i++) {
      widgets.add(const SizedBox(height: Spacing.md));
      widgets.add(
        ProgressItem(
          title: levels[i]['title'],
          value: levels[i]['value'],
          total: levels[i]['total'],
        ),
      );
      if (i < levels.length - 1) {
        widgets.add(
          const Divider(
            height: Spacing.md * 2,
            thickness: 1,
            color: Color(0xFFF5F5F6),
          ),
        );
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      title: widget.title,
      iconWidget: widget.icon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSelectedLevel(),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const Divider(
                  height: Spacing.md * 2,
                  thickness: 1,
                  color: const Color(0xFFF5F5F6),
                ),
                ..._buildRemainingLevels(),
              ],
            ),
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

class ProgressItem extends StatelessWidget {
  const ProgressItem({
    super.key,
    required this.title,
    this.value = 0,
    this.total = 0,
  });

  final String title;
  final int value;
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
