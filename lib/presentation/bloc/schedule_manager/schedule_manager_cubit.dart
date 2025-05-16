import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:monkey_stories/core/constants/schedule_manager.dart';
import 'package:monkey_stories/domain/entities/setting/schedule_entity.dart';
import 'package:monkey_stories/domain/usecases/settings/save_schedule_usecase.dart';
import 'package:monkey_stories/data/datasources/settings/settings_local_data_source.dart';

part 'schedule_manager_state.dart';

class ScheduleManagerCubit extends Cubit<ScheduleManagerState> {
  final SaveScheduleUsecase _saveScheduleUsecase;
  final SettingsLocalDataSource _settingsLocalDataSource;

  ScheduleManagerCubit({
    required SaveScheduleUsecase saveScheduleUsecase,
    required SettingsLocalDataSource settingsLocalDataSource,
  }) : _saveScheduleUsecase = saveScheduleUsecase,
       _settingsLocalDataSource = settingsLocalDataSource,
       super(const ScheduleManagerState()) {
    loadInitialSchedule();
  }

  Future<void> loadInitialSchedule() async {
    try {
      final scheduleEntity = await _settingsLocalDataSource.getSchedule();
      if (scheduleEntity != null) {
        final List<Weekday> loadedSelectedWeekdays = [];
        for (final String dayId in scheduleEntity.weekdays) {
          try {
            final weekday = weekdays.firstWhere((wd) => wd.id == dayId);
            loadedSelectedWeekdays.add(weekday);
          } catch (e) {
            print(
              'Không tìm thấy ngày với ID "$dayId" trong danh sách ngày toàn cục.',
            );
          }
        }

        final TimeOfDay loadedSelectedTime = TimeOfDay(
          hour: scheduleEntity.time.hour,
          minute: scheduleEntity.time.minute,
        );

        emit(
          state.copyWith(
            selectedWeekdays: loadedSelectedWeekdays,
            selectedTime: loadedSelectedTime,
            reset: true,
          ),
        );
      }
    } catch (e) {
      print('kkk Lỗi khi tải lịch trình ban đầu: $e');
    }
  }

  void toggleWeekday(Weekday weekday) {
    final newSelectedWeekdays = List<Weekday>.from(state.selectedWeekdays);
    if (newSelectedWeekdays.any((element) => element.id == weekday.id)) {
      newSelectedWeekdays.removeWhere((element) => element.id == weekday.id);
    } else {
      newSelectedWeekdays.add(weekday);
    }
    emit(state.copyWith(selectedWeekdays: newSelectedWeekdays));
  }

  void selectTime(TimeOfDay time) {
    emit(state.copyWith(selectedTime: time));
  }

  Future<void> saveSchedule() async {
    if (!state.isFormValid) return;

    emit(state.copyWith(isLoading: true, reset: true));

    try {
      final result = await _saveScheduleUsecase(
        ScheduleEntity(
          weekdays: state.selectedWeekdays.map((e) => e.id).toList(),
          time: ScheduleTimeEntity(
            hour: state.selectedTime.hour,
            minute: state.selectedTime.minute,
          ),
        ),
      );

      result.fold(
        (failure) {
          emit(state.copyWith(error: failure.toString()));
        },
        (success) {
          emit(state.copyWith(isSuccess: true));
        },
      );
    } catch (e) {
      print('kkk Lỗi khi lưu lịch trình: $e');
      emit(state.copyWith(error: 'error'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
