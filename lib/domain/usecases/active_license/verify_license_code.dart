import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/entities/active_license/license_code_info.dart';
import 'package:monkey_stories/domain/repositories/active_license_repository.dart';

class VerifyLicenseCodeUseCase
    extends UseCase<LicenseCodeInfoEntity, VerifyLicenseCodeParams> {
  final ActiveLicenseRepository _activeLicenseRepository;

  VerifyLicenseCodeUseCase(this._activeLicenseRepository);

  @override
  Future<Either<ServerFailureWithCode, LicenseCodeInfoEntity>> call(
    VerifyLicenseCodeParams params,
  ) async {
    final response = await _activeLicenseRepository.verifyLicenseCode(
      params.licenseCode,
    );
    print('ActiveLicenseCubit ${response}');

    if (response.status == ApiStatus.success) {
      return right(response.data!);
    }

    return left(
      ServerFailureWithCode(code: response.code, message: response.message),
    );
  }
}

class VerifyLicenseCodeParams {
  final String licenseCode;

  VerifyLicenseCodeParams({required this.licenseCode});
}
