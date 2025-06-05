import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/domain/entities/report/report_entity.dart';

abstract class ReportRepository {
  Future<Either<ServerFailure, LearningReportEntity>> getLearningReport({
    required int userId,
    required int profileId,
    int? date,
  });
}
