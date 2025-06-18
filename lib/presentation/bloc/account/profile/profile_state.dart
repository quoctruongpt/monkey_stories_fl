part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  const ProfileState({
    this.profiles = const [],
    this.currentProfile,
    this.status = ProfileStatus.initial,
  });

  final List<ProfileEntity> profiles;
  final ProfileEntity? currentProfile;
  final ProfileStatus status;

  ProfileState copyWith({
    List<ProfileEntity>? profiles,
    ProfileEntity? currentProfile,
    ProfileStatus? status,
  }) {
    return ProfileState(
      profiles: profiles ?? this.profiles,
      currentProfile: currentProfile ?? this.currentProfile,
      status: status ?? this.status,
    );
  }

  ProfileState clear() {
    return const ProfileState(
      profiles: [],
      currentProfile: null,
      status: ProfileStatus.initial,
    );
  }

  @override
  List<Object?> get props => [profiles, currentProfile, status];
}
