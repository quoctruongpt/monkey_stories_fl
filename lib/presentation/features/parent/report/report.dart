import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/blocs.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/report/report_cubit.dart';
import 'package:monkey_stories/presentation/features/parent/report/overview_report.dart';
import 'package:monkey_stories/presentation/features/parent/report/progress_report.dart';
import 'package:monkey_stories/presentation/features/parent/report/report_stories.dart';
import 'package:monkey_stories/presentation/features/parent/report/report_header.dart';
import 'package:monkey_stories/presentation/features/parent/report/weekly_study_duration_dart.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:shimmer/shimmer.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReportCubit>(),
      child: Scaffold(
        appBar: AppBarWidget(
          title: AppLocalizations.of(
            context,
          ).translate('app.report.study_report'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<ReportCubit, ReportState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    color: AppTheme.backgroundColor,
                    child: ReportHeader(
                      profile: state.currentProfile!,
                      profiles: context.read<ProfileCubit>().state.profiles,
                      onSelectProfile: (profile) {
                        context.read<ReportCubit>().onProfileChanged(profile);
                      },
                    ),
                  );
                },
              ),
              BlocBuilder<ReportCubit, ReportState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const ReportSkeleton();
                  }
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Spacing.md),
                    color: const Color(0xFFF2F4F7),
                    child: Column(
                      children: [
                        const WeeklyStudyDurationChart(
                          weeklyStudyDuration: [30, 111, 121, 150],
                        ),
                        const SizedBox(height: Spacing.md),
                        const OverviewReport(
                          numberStoriesWeek: 9,
                          numberLessonsWeek: 12,
                          numberVideosWeek: 10,
                          numberAudioBooksWeek: 25,
                          numberMinutesWeek: 912,
                          numberStoriesTotal: 9,
                          numberLessonsTotal: 48,
                          numberVideosTotal: 40,
                          numberAudioBooksTotal: 100,
                          numberMinutesTotal: 1000,
                        ),
                        const SizedBox(height: Spacing.md),
                        const ReportStories(),
                        const SizedBox(height: Spacing.md),
                        ProgressReport(
                          nurseryTotalLessons: 210,
                          kindergartenTotalLessons: 210,
                          grade1TotalLessons: 210,
                          nurseryValue: 20,
                          kindergartenValue: 40,
                          grade1Value: 80,
                          phonicsLevelSelected: PhonicsLevelSelected.nursery,
                          title: AppLocalizations.of(
                            context,
                          ).translate('app.report.progress.phonics'),
                          icon: SvgPicture.asset(
                            'assets/icons/svg/phonics.svg',
                          ),
                        ),
                        const SizedBox(height: Spacing.md),
                        ProgressReport(
                          nurseryTotalLessons: 210,
                          kindergartenTotalLessons: 210,
                          grade1TotalLessons: 210,
                          nurseryValue: 20,
                          kindergartenValue: 40,
                          grade1Value: 80,
                          phonicsLevelSelected: PhonicsLevelSelected.nursery,
                          title: AppLocalizations.of(
                            context,
                          ).translate('app.report.progress.reading'),
                          icon: SvgPicture.asset('assets/icons/svg/read.svg'),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportSkeleton extends StatelessWidget {
  const ReportSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      color: const Color(0xFFF2F4F7),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.1),
            highlightColor: Colors.white,
            period: const Duration(seconds: 1),
            direction: ShimmerDirection.ltr,
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.1),
            highlightColor: Colors.white,
            direction: ShimmerDirection.rtl,
            period: const Duration(seconds: 1),
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
