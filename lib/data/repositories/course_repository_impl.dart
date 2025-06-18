import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/datasources/course/course_remote_data.dart';
import 'package:monkey_stories/domain/repositories/course_repository.dart';

class CourseRepositoryImpl extends CourseRepository {
  final CourseRemoteData courseRemoteData;

  CourseRepositoryImpl({required this.courseRemoteData});

  @override
  Future<Either<ServerFailureWithCode, bool>> activeCourse(
    int profileId,
  ) async {
    return courseRemoteData.activeCourse(profileId);
  }
}
