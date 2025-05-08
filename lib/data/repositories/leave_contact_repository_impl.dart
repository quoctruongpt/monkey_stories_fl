import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/data/datasources/leave_contact/leave_contact_local_data_source.dart';
import 'package:monkey_stories/data/datasources/leave_contact/leave_contact_remote_data_source.dart';
import 'package:monkey_stories/data/models/leave_contact/contact_local_model.dart';
import 'package:monkey_stories/domain/repositories/leave_contact_repository.dart';
import 'package:monkey_stories/domain/usecases/leave_contact/save_contact_usecase.dart';

class LeaveContactRepositoryImpl extends LeaveContactRepository {
  final LeaveContactRemoteDataSource remoteDataSource;
  final LeaveContactLocalDataSource localDataSource;

  LeaveContactRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<ServerFailureWithCode, void>> saveContact(
    ContactParams params,
  ) async {
    final result = await remoteDataSource.saveContact(params);
    if (result.status == ApiStatus.success) {
      await localDataSource.saveContact(
        ContactLocalModel(
          name: params.name,
          phone: params.phone,
          countryCode: params.countryCode,
        ),
      );
      return right(null);
    }
    return left(
      ServerFailureWithCode(code: result.code, message: result.message),
    );
  }
}
