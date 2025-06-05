import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/report/report_entity.dart';
import 'package:monkey_stories/domain/repositories/report_repository.dart';

class GetReportUsecase
    implements UseCase<LearningReportEntity, GetReportParams> {
  final ReportRepository _reportRepository;

  GetReportUsecase({required ReportRepository reportRepository})
    : _reportRepository = reportRepository;

  @override
  Future<Either<ServerFailure, LearningReportEntity>> call(
    GetReportParams params,
  ) async {
    return _reportRepository.getLearningReport(
      userId: params.userId,
      profileId: params.profileId,
      date: params.date,
    );
  }
}

class GetReportParams {
  final int userId;
  final int profileId;
  final int? date;

  GetReportParams({required this.userId, required this.profileId, this.date});
}
