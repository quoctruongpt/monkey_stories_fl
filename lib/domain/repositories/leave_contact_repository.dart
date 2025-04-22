import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/domain/usecases/leave_contact/save_contact_usecase.dart';

class LeaveContactRepository {
  Future<Either<ServerFailureWithCode, void>> saveContact(
    ContactParams params,
  ) async {
    return right(null);
  }
}
