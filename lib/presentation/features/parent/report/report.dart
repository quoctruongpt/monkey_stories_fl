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
import 'package:monkey_stories/presentation/widgets/custom_pie_chart.dart';
import 'package:shimmer/shimmer.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReportCubit>(),
      child: Scaffold(
        appBar: AppBarWidget(
          showBackButton: false,
          title: AppLocalizations.of(
            context,
          ).translate('app.report.study_report'),
        ),
        body: BlocConsumer<ReportCubit, ReportState>(
          listenWhen:
              (previous, current) => previous.hasError != current.hasError,
          listener: (context, state) {
            if (state.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context).translate('error'),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).clearSnackBars();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
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
                  ),

                  state.isLoading || state.data == null
                      ? const ReportSkeleton()
                      : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(Spacing.md),
                        color: const Color(0xFFF2F4F7),
                        child: Column(
                          children: [
                            WeeklyStudyDurationChart(
                              weeklyStudyDuration: [
                                state.data!.recentWeeklyReport.week1,
                                state.data!.recentWeeklyReport.week2,
                                state.data!.recentWeeklyReport.week3,
                                state.data!.recentWeeklyReport.week4,
                              ],
                            ),
                            const SizedBox(height: Spacing.md),
                            OverviewReport(
                              numberStoriesWeek:
                                  state
                                      .data!
                                      .weeklyReport
                                      .generalReport
                                      .totalStory,
                              numberLessonsWeek:
                                  state
                                      .data!
                                      .weeklyReport
                                      .generalReport
                                      .totalLesson,
                              numberVideosWeek:
                                  state
                                      .data!
                                      .weeklyReport
                                      .generalReport
                                      .totalVideo,
                              numberAudioBooksWeek:
                                  state
                                      .data!
                                      .weeklyReport
                                      .generalReport
                                      .totalAudioBook,
                              numberMinutesWeek:
                                  state
                                      .data!
                                      .weeklyReport
                                      .generalReport
                                      .totalDuration,
                              numberStoriesTotal:
                                  state
                                      .data!
                                      .totalLearned
                                      .generalReport
                                      .totalStory,
                              numberLessonsTotal:
                                  state
                                      .data!
                                      .totalLearned
                                      .generalReport
                                      .totalLesson,
                              numberVideosTotal:
                                  state
                                      .data!
                                      .totalLearned
                                      .generalReport
                                      .totalVideo,
                              numberAudioBooksTotal:
                                  state
                                      .data!
                                      .totalLearned
                                      .generalReport
                                      .totalAudioBook,
                              numberMinutesTotal:
                                  state
                                      .data!
                                      .totalLearned
                                      .generalReport
                                      .totalDuration,
                            ),
                            const SizedBox(height: Spacing.md),
                            ReportStories(
                              weeklyData:
                                  state.data!.weeklyReport.storyByLevel.keys
                                      .map(
                                        (key) => PieChartData(
                                          value:
                                              state
                                                  .data!
                                                  .weeklyReport
                                                  .storyByLevel[key]!
                                                  .toDouble(),
                                          label: key,
                                        ),
                                      )
                                      .toList(),
                              totalData:
                                  state.data!.totalLearned.storyByLevel.keys
                                      .map(
                                        (key) => PieChartData(
                                          value:
                                              state
                                                  .data!
                                                  .totalLearned
                                                  .storyByLevel[key]!
                                                  .toDouble(),
                                          label: key,
                                        ),
                                      )
                                      .toList(),
                            ),
                            const SizedBox(height: Spacing.md),
                            ProgressReport(
                              nurseryTotalLessons:
                                  state.data!.levelProgress.nursery.total,
                              kindergartenTotalLessons:
                                  state.data!.levelProgress.kindergarten.total,
                              grade1TotalLessons:
                                  state.data!.levelProgress.grade1.total,
                              nurseryValue:
                                  state.data!.levelProgress.nursery.current,
                              kindergartenValue:
                                  state
                                      .data!
                                      .levelProgress
                                      .kindergarten
                                      .current,
                              grade1Value:
                                  state.data!.levelProgress.grade1.current,
                              phonicsLevelSelected:
                                  PhonicsLevelSelected.nursery,
                              title: AppLocalizations.of(
                                context,
                              ).translate('app.report.progress.phonics'),
                              icon: SvgPicture.asset(
                                'assets/icons/svg/phonics.svg',
                              ),
                            ),
                            const SizedBox(height: Spacing.md),
                            ProgressReport(
                              nurseryTotalLessons:
                                  state.data!.levelProgress.nursery.total,
                              kindergartenTotalLessons:
                                  state.data!.levelProgress.kindergarten.total,
                              grade1TotalLessons:
                                  state.data!.levelProgress.grade1.total,
                              nurseryValue:
                                  state.data!.levelProgress.nursery.current,
                              kindergartenValue:
                                  state
                                      .data!
                                      .levelProgress
                                      .kindergarten
                                      .current,
                              grade1Value:
                                  state.data!.levelProgress.grade1.current,
                              phonicsLevelSelected:
                                  PhonicsLevelSelected.nursery,
                              title: AppLocalizations.of(
                                context,
                              ).translate('app.report.progress.reading'),
                              icon: SvgPicture.asset(
                                'assets/icons/svg/read.svg',
                              ),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                ],
              ),
            );
          },
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
