import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';
import 'package:monkey_stories/domain/usecases/course/active_course_usecase.dart';
import 'package:monkey_stories/domain/usecases/profile/create_profile_usecase.dart';
import 'package:monkey_stories/domain/usecases/profile/get_current_profile_usecase.dart';
import 'package:monkey_stories/domain/usecases/profile/get_list_profile_usecase.dart';

part 'profile_state.dart';

final Logger logger = Logger('ProfileCubit');

class ProfileCubit extends Cubit<ProfileState> {
  final GetListProfileUsecase _getListProfileUsecase;
  final CreateProfileUsecase _createProfileUsecase;
  final GetCurrentProfileUsecase _getCurrentProfileUsecase;
  final ActiveCourseUsecase _activeCourseUsecase;

  ProfileCubit({
    required GetListProfileUsecase getListProfileUsecase,
    required CreateProfileUsecase createProfileUsecase,
    required GetCurrentProfileUsecase getCurrentProfileUsecase,
    required ActiveCourseUsecase activeCourseUsecase,
  }) : _getListProfileUsecase = getListProfileUsecase,
       _createProfileUsecase = createProfileUsecase,
       _getCurrentProfileUsecase = getCurrentProfileUsecase,
       _activeCourseUsecase = activeCourseUsecase,
       super(const ProfileState());

  Future<void> getCurrentProfile() async {
    final result = await _getCurrentProfileUsecase.call(NoParams());
    result.fold((failure) => {}, (profileId) {
      selectProfile(profileId);
    });
  }

  Future<void> getListProfile() async {
    final result = await _getListProfileUsecase.call(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(status: ProfileStatus.error)),
      (profiles) {
        emit(state.copyWith(status: ProfileStatus.loaded, profiles: profiles));
      },
    );
  }

  Future<void> addProfile(String name, int yearOfBirth) async {
    final result = await _createProfileUsecase.call(
      CreateProfileUsecaseParams(name: name, yearOfBirth: yearOfBirth),
    );

    if (result.isRight()) {
      final profile = result.getRight().toNullable();

      if (profile != null) {
        await _activeCourseUsecase.call(profile.id);
        emit(
          state.copyWith(
            status: ProfileStatus.loaded,
            profiles: [...state.profiles, profile],
          ),
        );
        selectProfile(profile.id);
      }
    }
  }

  Future<void> clearProfile() async {
    emit(state.clear());
  }

  void selectProfile(int profileId) {
    final profile = state.profiles.firstWhere(
      (profile) => profile.id == profileId,
    );
    emit(state.copyWith(currentProfile: profile));
  }
}
