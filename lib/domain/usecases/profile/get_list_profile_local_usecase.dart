import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/profile/profile_entity.dart';
import 'package:monkey_stories/domain/repositories/profile_repository.dart';

class GetListProfileLocalUsecase
    extends UseCase<List<ProfileEntity>, NoParams> {
  final ProfileRepository repository;

  GetListProfileLocalUsecase({required this.repository});

  @override
  Future<Either<Failure, List<ProfileEntity>>> call(NoParams params) async {
    return repository.getListProfileLocal();
  }
}
