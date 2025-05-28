import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ProfileCubit _profileCubit;
  ReportCubit({required ProfileCubit profileCubit})
    : _profileCubit = profileCubit,
      super(const ReportState()) {
    init();
  }

  Future<void> init() async {
    ProfileEntity? profile = _profileCubit.state.currentProfile;
    profile ??= _profileCubit.state.profiles.first;
    onProfileChanged(profile);
    getReport();
  }

  Future<void> onProfileChanged(ProfileEntity profile) async {
    emit(state.copyWith(currentProfile: profile));
    getReport();
  }

  Future<void> getReport() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(isLoading: false));
  }
}
