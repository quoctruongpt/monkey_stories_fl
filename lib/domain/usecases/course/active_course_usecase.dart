import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/course_repository.dart';

class ActiveCourseUsecase extends UseCase<bool, int> {
  final CourseRepository _courseRepository;

  ActiveCourseUsecase(this._courseRepository);

  @override
  Future<Either<ServerFailureWithCode, bool>> call(int profileId) async {
    return _courseRepository.activeCourse(profileId);
  }
}
