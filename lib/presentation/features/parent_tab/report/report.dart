// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

// Project imports:
import 'package:monkey_stories/core/constants/lesson.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/blocs.dart';
import 'package:monkey_stories/domain/usecases/tracking/learning_report/ms_learning_report_phonics.dart';
import 'package:monkey_stories/domain/usecases/tracking/learning_report/ms_learning_report_rc.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/report/report_cubit.dart';
import 'package:monkey_stories/presentation/features/parent_tab/report/overview_report.dart';
import 'package:monkey_stories/presentation/features/parent_tab/report/progress_report.dart';
import 'package:monkey_stories/presentation/features/parent_tab/report/report_header.dart';
import 'package:monkey_stories/presentation/features/parent_tab/report/report_stories.dart';
import 'package:monkey_stories/presentation/features/parent_tab/report/weekly_study_duration_dart.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/custom_pie_chart.dart';
import 'package:monkey_stories/presentation/widgets/screen_tracker.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReportCubit>(),
      child: Builder(
        builder: (context) {
          return ScreenTracker(
            routeName: AppRouteNames.report,
            onTrackPush: context.read<ReportCubit>().startTracking,
            onTrackExit: context.read<ReportCubit>().trackExit,
            child: Scaffold(
              appBar: AppBarWidget(
                showBackButton: false,
                title: AppLocalizations.of(
                  context,
                ).translate('app.report.study_report'),
              ),
              body: BlocConsumer<ReportCubit, ReportState>(
                listenWhen:
                    (previous, current) =>
                        previous.hasError != current.hasError,
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
                            profiles:
                                context.read<ProfileCubit>().state.profiles,
                            onSelectProfile: (profile) {
                              context.read<ReportCubit>().onProfileChanged(
                                profile,
                              );
                            },
                            onPressSwitchProfile: () {
                              context.read<ReportCubit>().trackSwitchProfile();
                            },
                          ),
                        ),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child:
                              state.isLoading || state.data == null
                                  ? const ReportSkeleton(
                                    key: ValueKey('ReportSkeleton'),
                                  )
                                  : Container(
                                    key: const ValueKey('ReportContent'),
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(Spacing.md),
                                    color: const Color(0xFFF2F4F7),
                                    child: Column(
                                      children: [
                                        WeeklyStudyDurationChart(
                                          weeklyStudyDuration: [
                                            state
                                                .data!
                                                .recentWeeklyReport
                                                .week1,
                                            state
                                                .data!
                                                .recentWeeklyReport
                                                .week2,
                                            state
                                                .data!
                                                .recentWeeklyReport
                                                .week3,
                                            state
                                                .data!
                                                .recentWeeklyReport
                                                .week4,
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
                                          onTabChanged: (index) {
                                            context
                                                .read<ReportCubit>()
                                                .trackStoriesLevel(index);
                                          },
                                          weeklyData:
                                              state
                                                  .data!
                                                  .weeklyReport
                                                  .storyByLevel
                                                  .keys
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
                                              state
                                                  .data!
                                                  .totalLearned
                                                  .storyByLevel
                                                  .keys
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
                                          selectedLevelId:
                                              state
                                                  .data!
                                                  .stageFocusLearnToRead ??
                                              StageId.one.value,
                                          onShowMore: () {
                                            context
                                                .read<ReportCubit>()
                                                .trackPhonics(
                                                  PhonicsClickType.showMore,
                                                );
                                          },
                                          onShowLess: () {
                                            context
                                                .read<ReportCubit>()
                                                .trackPhonics(
                                                  PhonicsClickType.showLess,
                                                );
                                          },
                                          progressData: [
                                            ProgressData(
                                              id: StageId.one.value,
                                              title: AppLocalizations.of(
                                                context,
                                              ).translate(
                                                'app.report.stage',
                                                params: {'stage': '1'},
                                              ),
                                              value:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .one
                                                      .current,
                                              total:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .one
                                                      .total,
                                            ),
                                            ProgressData(
                                              id: StageId.two.value,
                                              title: AppLocalizations.of(
                                                context,
                                              ).translate(
                                                'app.report.stage',
                                                params: {'stage': '2'},
                                              ),
                                              value:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .two
                                                      .current,
                                              total:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .two
                                                      .total,
                                            ),
                                            ProgressData(
                                              id: StageId.three.value,
                                              title: AppLocalizations.of(
                                                context,
                                              ).translate(
                                                'app.report.stage',
                                                params: {'stage': '3'},
                                              ),
                                              value:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .three
                                                      .current,
                                              total:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .three
                                                      .total,
                                            ),
                                          ],
                                          title: AppLocalizations.of(
                                            context,
                                          ).translate(
                                            'app.report.progress.phonics',
                                          ),
                                          icon: SvgPicture.asset(
                                            'assets/icons/svg/phonics.svg',
                                          ),
                                        ),
                                        const SizedBox(height: Spacing.md),

                                        ProgressReport(
                                          selectedLevelId:
                                              state
                                                  .data!
                                                  .stageFocusEarlyReader ??
                                              StageId.four.value,
                                          onShowMore: () {
                                            context.read<ReportCubit>().trackRC(
                                              RCClickType.showMore,
                                            );
                                          },
                                          onShowLess: () {
                                            context.read<ReportCubit>().trackRC(
                                              RCClickType.showLess,
                                            );
                                          },
                                          progressData: [
                                            ProgressData(
                                              id: StageId.four.value,
                                              title: AppLocalizations.of(
                                                context,
                                              ).translate(
                                                'app.report.stage',
                                                params: {'stage': '4'},
                                              ),
                                              value:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .four
                                                      .current,
                                              total:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .four
                                                      .total,
                                            ),
                                            ProgressData(
                                              id: StageId.five.value,
                                              title: AppLocalizations.of(
                                                context,
                                              ).translate(
                                                'app.report.stage',
                                                params: {'stage': '5'},
                                              ),
                                              value:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .five
                                                      .current,
                                              total:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .five
                                                      .total,
                                            ),
                                            ProgressData(
                                              id: StageId.six.value,
                                              title: AppLocalizations.of(
                                                context,
                                              ).translate(
                                                'app.report.stage',
                                                params: {'stage': '6'},
                                              ),
                                              value:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .six
                                                      .current,
                                              total:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .six
                                                      .total,
                                            ),
                                            ProgressData(
                                              id: StageId.seven.value,
                                              title: AppLocalizations.of(
                                                context,
                                              ).translate(
                                                'app.report.stage',
                                                params: {'stage': '7'},
                                              ),
                                              value:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .seven
                                                      .current,
                                              total:
                                                  state
                                                      .data!
                                                      .levelProgress
                                                      .seven
                                                      .total,
                                            ),
                                          ],
                                          title: AppLocalizations.of(
                                            context,
                                          ).translate(
                                            'app.report.progress.reading',
                                          ),
                                          icon: SvgPicture.asset(
                                            'assets/icons/svg/read.svg',
                                          ),
                                        ),
                                        const SizedBox(height: 100),
                                      ],
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.transparent,
          highlightColor: Colors.white.withAlpha(128),
          child: Image.asset('assets/images/report_skeleton.png'),
        ),
      ),
    );
  }
}
