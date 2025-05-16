part of 'schedule_manager_cubit.dart';

class ScheduleManagerState extends Equatable {
  final List<Weekday> selectedWeekdays;
  final TimeOfDay selectedTime;
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const ScheduleManagerState({
    this.selectedWeekdays = const [],
    this.selectedTime = const TimeOfDay(hour: 19, minute: 0),
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  ScheduleManagerState copyWith({
    List<Weekday>? selectedWeekdays,
    TimeOfDay? selectedTime,
    bool? isLoading,
    bool? isSuccess,
    String? error,
    bool? reset,
  }) {
    return ScheduleManagerState(
      selectedWeekdays: selectedWeekdays ?? this.selectedWeekdays,
      selectedTime: selectedTime ?? this.selectedTime,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: reset == true ? false : isSuccess ?? this.isSuccess,
      error: reset == true ? null : error ?? this.error,
    );
  }

  bool get isFormValid => selectedWeekdays.isNotEmpty;

  @override
  List<Object?> get props => [
    selectedWeekdays,
    selectedTime,
    isLoading,
    isSuccess,
    error,
  ];
}
