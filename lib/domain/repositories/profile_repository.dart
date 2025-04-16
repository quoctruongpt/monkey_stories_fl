import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';

class ProfileRepository {
  Future<Either<ServerFailureWithCode, void>> createProfile(
    String name,
    int yearOfBirth,
  ) async {
    return right(null);
  }
}
