import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/active_license/license_code_info.dart';
import 'package:monkey_stories/domain/repositories/active_license_repository.dart';

class VerifyCodUserCrmUseCase
    extends UseCase<LicenseCodeInfoEntity, VerifyCodUserCrmParams> {
  final ActiveLicenseRepository _activeLicenseRepository;

  VerifyCodUserCrmUseCase(this._activeLicenseRepository);

  @override
  Future<Either<ServerFailureWithCode, LicenseCodeInfoEntity>> call(
    VerifyCodUserCrmParams params,
  ) async {
    final response = await _activeLicenseRepository.verifyCodUserCrm(
      params.username,
      params.password,
    );

    if (response.status == ApiStatus.success) {
      return right(response.data!);
    }

    return left(
      ServerFailureWithCode(code: response.code, message: response.message),
    );
  }
}

class VerifyCodUserCrmParams {
  final String username;
  final String password;

  VerifyCodUserCrmParams({required this.username, required this.password});
}
