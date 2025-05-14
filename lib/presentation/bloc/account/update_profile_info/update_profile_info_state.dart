part of 'update_profile_info_cubit.dart';

class UpdateProfileInfoState extends Equatable {
  final NameValidator name;
  final String? avatarPath;
  final int? birthYear;
  final ProfileEntity? profile;
  final List<int>? years;
  final bool isButtonEnabled;

  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const UpdateProfileInfoState({
    this.name = const NameValidator.pure(),
    this.avatarPath,
    this.birthYear,
    this.profile,
    this.years,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.isButtonEnabled = false,
  });

  UpdateProfileInfoState copyWith({
    NameValidator? name,
    String? avatarPath,
    int? birthYear,
    ProfileEntity? profile,
    List<int>? years,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    bool? isButtonEnabled,
    bool? clearError,
  }) {
    return UpdateProfileInfoState(
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      birthYear: birthYear ?? this.birthYear,
      profile: profile ?? this.profile,
      years: years ?? this.years,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearError == true ? null : errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }

  @override
  List<Object?> get props => [
    name,
    avatarPath,
    birthYear,
    profile,
    years,
    isLoading,
    errorMessage,
    isSuccess,
    isButtonEnabled,
  ];
}
