import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';

abstract class CourseRepository {
  Future<Either<ServerFailureWithCode, bool>> activeCourse(int profileId);
}
