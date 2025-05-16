import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/constants/schedule_manager.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/presentation/bloc/schedule_manager/schedule_manager_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';

class ScheduleManager extends StatelessWidget {
  const ScheduleManager({super.key});

  Future<void> _selectTime(BuildContext context, TimeOfDay? initialTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    if (picked != null && context.mounted) {
      context.read<ScheduleManagerCubit>().selectTime(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ScheduleManagerCubit>(),
      child: BlocConsumer<ScheduleManagerCubit, ScheduleManagerState>(
        listenWhen:
            (previous, current) =>
                previous.isSuccess != current.isSuccess ||
                previous.error != current.error,
        listener: (context, state) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(
                    context,
                  ).translate('Lưu lịch học thành công!'),
                ),
                backgroundColor: AppTheme.successColor,
              ),
            );
          } else if (state.error != null && state.error!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBarWidget(
              title: AppLocalizations.of(context).translate('Đặt lịch học'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/schedule.png',
                          width: 188,
                          height: 143,
                        ),
                        const SizedBox(height: Spacing.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              weekdays
                                  .map(
                                    (weekday) => InkWell(
                                      onTap:
                                          () => context
                                              .read<ScheduleManagerCubit>()
                                              .toggleWeekday(weekday),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                          vertical: 8.0,
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              state.selectedWeekdays.any(
                                                    (e) => e.id == weekday.id,
                                                  )
                                                  ? Icons.check_circle
                                                  : Icons.circle_outlined,
                                              color:
                                                  state.selectedWeekdays.any(
                                                        (e) =>
                                                            e.id == weekday.id,
                                                      )
                                                      ? AppTheme.successColor
                                                      : AppTheme.textGrayColor,
                                            ),
                                            const SizedBox(height: Spacing.xs),
                                            Text(
                                              weekday.label,
                                              style: TextStyle(
                                                color:
                                                    state.selectedWeekdays.any(
                                                          (e) =>
                                                              e.id ==
                                                              weekday.id,
                                                        )
                                                        ? AppTheme.successColor
                                                        : AppTheme
                                                            .textGrayColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                        const SizedBox(height: Spacing.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(
                                context,
                              ).translate('Chọn giờ'),
                              style: const TextStyle(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            const SizedBox(width: 60),
                            OutlinedButton(
                              onPressed:
                                  () =>
                                      _selectTime(context, state.selectedTime),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.textColor,
                              ),
                              child: Row(
                                children: [
                                  Text(state.selectedTime.format(context)),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppButton.primary(
                    text: AppLocalizations.of(
                      context,
                    ).translate('Lưu lịch học'),
                    onPressed: () {
                      if (state.isFormValid && !state.isLoading) {
                        context.read<ScheduleManagerCubit>().saveSchedule();
                      }
                    },
                    isLoading: state.isLoading,
                    disabled: state.selectedWeekdays.isEmpty || state.isLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
