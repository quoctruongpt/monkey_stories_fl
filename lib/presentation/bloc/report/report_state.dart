part of 'report_cubit.dart';

class ReportState extends Equatable {
  final bool isLoading;

  const ReportState({this.isLoading = false});

  ReportState copyWith({bool? isLoading}) {
    return ReportState(isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object> get props => [isLoading];
}
