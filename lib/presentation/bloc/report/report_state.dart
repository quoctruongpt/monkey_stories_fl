part of 'report_cubit.dart';

class ReportState extends Equatable {
  final bool isLoading;
  final ProfileEntity? currentProfile;
  final LearningReportEntity? data;
  final bool hasError;

  const ReportState({
    this.isLoading = false,
    this.currentProfile,
    this.data,
    this.hasError = false,
  });

  ReportState copyWith({
    bool? isLoading,
    ProfileEntity? currentProfile,
    LearningReportEntity? data,
    bool? hasError,
    bool clearData = false,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      currentProfile: currentProfile ?? this.currentProfile,
      data: clearData ? null : data ?? this.data,
      hasError: clearData ? false : hasError ?? this.hasError,
    );
  }

  @override
  List<Object?> get props => [isLoading, currentProfile, data, hasError];
}
