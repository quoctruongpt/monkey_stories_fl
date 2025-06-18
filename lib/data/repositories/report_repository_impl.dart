import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/datasources/report/report_remote_data_source.dart';
import 'package:monkey_stories/domain/entities/report/report_entity.dart';
import 'package:monkey_stories/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource _remoteDataSource;

  ReportRepositoryImpl({required ReportRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<ServerFailure, LearningReportEntity>> getLearningReport({
    required int userId,
    required int profileId,
    int? date,
  }) async {
    final response = await _remoteDataSource.getLearningReport(
      userId: userId,
      profileId: profileId,
      date: date,
    );

    if (response.status == ApiStatus.success) {
      return Right(response.data!.toEntity());
    }

    return Left(ServerFailure(message: response.message));
  }
}
