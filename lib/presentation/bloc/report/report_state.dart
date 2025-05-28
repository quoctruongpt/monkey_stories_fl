part of 'report_cubit.dart';

class ReportState extends Equatable {
  final bool isLoading;
  final ProfileEntity? currentProfile;

  const ReportState({this.isLoading = false, this.currentProfile});

  ReportState copyWith({bool? isLoading, ProfileEntity? currentProfile}) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      currentProfile: currentProfile ?? this.currentProfile,
    );
  }

  @override
  List<Object?> get props => [isLoading, currentProfile];
}
