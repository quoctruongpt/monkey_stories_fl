import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/utils/profile.dart';
import 'package:monkey_stories/core/validators/name.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';
import 'package:monkey_stories/domain/usecases/profile/update_profile_usecase.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

part 'update_profile_info_state.dart';

class UpdateProfileInfoCubit extends Cubit<UpdateProfileInfoState> {
  final ProfileCubit _profileCubit;
  final UpdateProfileUsecase _updateProfileUsecase;
  final UserCubit _userCubit;

  UpdateProfileInfoCubit({
    required ProfileCubit profileCubit,
    required UpdateProfileUsecase updateProfileUsecase,
    required UserCubit userCubit,
  }) : _profileCubit = profileCubit,
       _updateProfileUsecase = updateProfileUsecase,
       _userCubit = userCubit,
       super(const UpdateProfileInfoState()) {
    emit(state.copyWith(years: ProfileUtil.getNearYears()));
  }

  void checkNameTaken(String name) {
    final isNameTaken = _profileCubit.state.profiles.any((profile) {
      return profile.name.toLowerCase() == name.toLowerCase().trim() &&
          profile.id != state.profile?.id;
    });
    emit(state.copyWith(isNameTaken: isNameTaken));
  }

  void _initNumberChangeAge(int profileId) {
    final profileSetting = _userCubit.getSettingProfile(profileId);
    emit(state.copyWith(numberChangeAge: profileSetting?.numberChangeAge));
  }

  void updateName(String name) {
    emit(state.copyWith(name: NameValidator.dirty(name)));
    checkNameTaken(name);
    checkButtonEnabled();
  }

  void updateBirthYear(int year) {
    emit(
      state.copyWith(
        birthYear: year,
        hasChangedAge: year != state.profile?.yearOfBirth,
      ),
    );
    checkButtonEnabled();
  }

  void checkButtonEnabled() {
    emit(
      state.copyWith(
        isButtonEnabled:
            (state.name.value != state.profile?.name ||
                state.birthYear != state.profile?.yearOfBirth) &&
            state.name.isValid &&
            state.birthYear != null,
      ),
    );
  }

  ProfileEntity? loadProfile(int profileId) {
    _initNumberChangeAge(profileId);
    final profile = _profileCubit.getProfile(profileId);
    emit(
      state.copyWith(
        profile: profile,
        birthYear: profile?.yearOfBirth,
        name: NameValidator.dirty(profile?.name ?? ''),
      ),
    );
    return profile;
  }

  Future<void> updateProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final name = state.name.value.trim();
      final result = await _updateProfileUsecase.call(
        UpdateProfileUsecaseParams(
          id: state.profile?.id ?? 0,
          name: name,
          yearOfBirth: state.birthYear ?? 0,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(errorMessage: failure.message)),
        (_) {
          final profile = ProfileEntity(
            id: state.profile?.id ?? 0,
            name: name,
            yearOfBirth: state.birthYear ?? 0,
            avatarPath: state.profile?.avatarPath ?? '',
          );
          emit(
            state.copyWith(
              profile: profile,
              isSuccess: true,
              numberChangeAge:
                  state.hasChangedAge
                      ? state.numberChangeAge + 1
                      : state.numberChangeAge,
            ),
          );
          _profileCubit.changeListProfile(
            _profileCubit.state.profiles
                .map((e) => e.id == profile.id ? profile : e)
                .toList(),
          );
          if (state.hasChangedAge) {
            _userCubit.updateNumberChangeAge(
              state.profile?.id ?? 0,
              state.numberChangeAge + 1,
            );
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'error'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> updateAvatar(String path) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final result = await _updateProfileUsecase.call(
        UpdateProfileUsecaseParams(
          id: state.profile?.id ?? 0,
          localAvatarPath: path,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(errorMessage: failure.message)),
        (newProfile) {
          final profile = ProfileEntity(
            id: state.profile?.id ?? 0,
            name: state.profile?.name ?? '',
            yearOfBirth: state.profile?.yearOfBirth ?? 0,
            avatarPath: newProfile.avatarPath,
          );
          emit(state.copyWith(profile: profile));
          _profileCubit.changeListProfile(
            _profileCubit.state.profiles
                .map((e) => e.id == profile.id ? profile : e)
                .toList(),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'error'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
