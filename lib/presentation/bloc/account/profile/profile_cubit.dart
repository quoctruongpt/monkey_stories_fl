import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';
import 'package:monkey_stories/domain/usecases/course/active_course_usecase.dart';
import 'package:monkey_stories/domain/usecases/profile/create_profile_usecase.dart';
import 'package:monkey_stories/domain/usecases/profile/get_current_profile_usecase.dart';
import 'package:monkey_stories/domain/usecases/profile/get_list_profile_usecase.dart';
import 'package:monkey_stories/domain/usecases/kinesis/put_setting_kinesis_usecase.dart';
import 'package:monkey_stories/core/constants/kinesis.dart';

part 'profile_state.dart';

final Logger logger = Logger('ProfileCubit');

class ProfileCubit extends Cubit<ProfileState> {
  final GetListProfileUsecase _getListProfileUsecase;
  final CreateProfileUsecase _createProfileUsecase;
  final GetCurrentProfileUsecase _getCurrentProfileUsecase;
  final ActiveCourseUsecase _activeCourseUsecase;
  final PutSettingKinesisUsecase _putSettingKinesisUsecase;
  ProfileCubit({
    required GetListProfileUsecase getListProfileUsecase,
    required CreateProfileUsecase createProfileUsecase,
    required GetCurrentProfileUsecase getCurrentProfileUsecase,
    required ActiveCourseUsecase activeCourseUsecase,
    required PutSettingKinesisUsecase putSettingKinesisUsecase,
  }) : _getListProfileUsecase = getListProfileUsecase,
       _createProfileUsecase = createProfileUsecase,
       _getCurrentProfileUsecase = getCurrentProfileUsecase,
       _activeCourseUsecase = activeCourseUsecase,
       _putSettingKinesisUsecase = putSettingKinesisUsecase,
       super(const ProfileState());

  Future<void> getCurrentProfile() async {
    final result = await _getCurrentProfileUsecase.call(NoParams());
    result.fold((failure) => {}, (profileId) {
      logger.info('getCurrentProfile profileId: $profileId');
      if (profileId != null) {
        selectProfile(profileId);
      }
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

  Future<void> addProfile(String name, int yearOfBirth, int levelId) async {
    final result = await _createProfileUsecase.call(
      CreateProfileUsecaseParams(
        name: name,
        yearOfBirth: yearOfBirth,
        levelId: levelId,
      ),
    );

    if (result.isRight()) {
      final profile = result.getRight().toNullable();

      if (profile != null) {
        await _activeCourseUsecase.call(profile.id);
        await _putSettingKinesisUsecase.call(
          PutSettingKinesisUsecaseParams(
            partitionKey: profile.id.toString(),
            eventName: KinesisEventName.changeLevel,
            data: profile.toJson(),
          ),
        );
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
    ProfileEntity? profile;
    try {
      profile = state.profiles.firstWhere((profile) => profile.id == profileId);
      emit(state.copyWith(currentProfile: profile));
    } catch (e) {
      // Log the error if no profile is found
      logger.warning(
        'Profile with id $profileId not found in state.profiles. Error: $e',
      );
      // Optionally, handle the state differently, e.g., emit an error state or do nothing.
      // For now, we'll just log and not change the state if the profile isn't found.
      return; // Exit the function
    }
    // If found, emit the state with the selected profile
  }

  ProfileEntity? getProfile(int profileId) {
    return state.profiles.firstWhere((profile) => profile.id == profileId);
  }

  void changeListProfile(List<ProfileEntity> profiles) {
    emit(state.copyWith(profiles: profiles));
  }
}
