import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/report_card.dart';

class OverviewReport extends StatelessWidget {
  const OverviewReport({
    super.key,
    this.numberStoriesWeek = 0,
    this.numberLessonsWeek = 0,
    this.numberVideosWeek = 0,
    this.numberAudioBooksWeek = 0,
    this.numberMinutesWeek = 0,
    this.numberStoriesTotal = 0,
    this.numberLessonsTotal = 0,
    this.numberVideosTotal = 0,
    this.numberAudioBooksTotal = 0,
    this.numberMinutesTotal = 0,
  });

  final int numberStoriesWeek;
  final int numberLessonsWeek;
  final int numberVideosWeek;
  final int numberAudioBooksWeek;
  final int numberMinutesWeek;

  final int numberStoriesTotal;
  final int numberLessonsTotal;
  final int numberVideosTotal;
  final int numberAudioBooksTotal;
  final int numberMinutesTotal;

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      title: AppLocalizations.of(
        context,
      ).translate('app.report.overview.this_week'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReportGridView(
            numberStories: numberStoriesWeek,
            numberLessons: numberLessonsWeek,
            numberVideos: numberVideosWeek,
            numberAudioBooks: numberAudioBooksWeek,
            numberMinutes: numberMinutesWeek,
          ),
          const SizedBox(height: Spacing.xxl),
          Text(
            AppLocalizations.of(
              context,
            ).translate('app.report.overview.total_learned'),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: Spacing.md),
          const Divider(
            color: AppTheme.buttonSecondaryDisabledBackground,
            thickness: 1,
          ),
          const SizedBox(height: Spacing.md),
          ReportGridView(
            numberStories: numberStoriesTotal,
            numberLessons: numberLessonsTotal,
            numberVideos: numberVideosTotal,
            numberAudioBooks: numberAudioBooksTotal,
            numberMinutes: numberMinutesTotal,
          ),
        ],
      ),
    );
  }
}

class ReportGridView extends StatelessWidget {
  const ReportGridView({
    super.key,
    this.numberStories = 0,
    this.numberLessons = 0,
    this.numberVideos = 0,
    this.numberAudioBooks = 0,
    this.numberMinutes = 0,
  });

  final int? numberStories;
  final int? numberLessons;
  final int? numberVideos;
  final int? numberAudioBooks;
  final int? numberMinutes;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth = constraints.maxWidth;
        final double spacing = 16.0; // Defined spacing in Wrap
        double itemWidth;

        // Calculate ideal width for two items per row
        if (availableWidth > spacing) {
          // Enough space for at least one spacing and some item width for two items
          itemWidth = (availableWidth - spacing) / 2.0;
        } else {
          // Not enough space for two items with spacing,
          // so make items take full available width (effectively one item per row)
          itemWidth = availableWidth;
        }

        // Ensure itemWidth is not negative
        itemWidth = itemWidth > 0 ? itemWidth : 0.0;

        return Wrap(
          spacing: spacing, // Horizontal spacing between items in a run
          runSpacing: 16.0, // Vertical spacing between runs
          alignment: WrapAlignment.start,
          children: [
            SizedBox(
              width: itemWidth,
              child: _buildStatCard(
                context,
                icon: 'assets/icons/svg/stories.svg',
                title: AppLocalizations.of(
                  context,
                ).translate('app.report.overview.stories'),
                value: numberStories,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildStatCard(
                context,
                icon: 'assets/icons/svg/lesson.svg',
                title: AppLocalizations.of(
                  context,
                ).translate('app.report.overview.lessons'),
                value: numberLessons,
                color: Colors.green,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildStatCard(
                context,
                icon: 'assets/icons/svg/video.svg',
                title: AppLocalizations.of(
                  context,
                ).translate('app.report.overview.videos'),
                value: numberVideos,
                color: Colors.pink,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildStatCard(
                context,
                icon: 'assets/icons/svg/audio_book.svg',
                title: AppLocalizations.of(
                  context,
                ).translate('app.report.overview.audio_books'),
                value: numberAudioBooks,
                color: Colors.purple,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildStatCard(
                context,
                icon: 'assets/icons/svg/minute.svg',
                title: AppLocalizations.of(
                  context,
                ).translate('app.report.overview.minutes'),
                value: numberMinutes,
                color: Colors.orange,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String icon,
    required String title,
    int? value = 0,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SvgPicture.asset(icon, width: 40, height: 40),
          const SizedBox(width: Spacing.md),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF85888E),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }
}
