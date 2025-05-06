import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/active_license_repository.dart';

class LinkCodToThisAccountUseCase
    extends UseCase<void, LinkCodToThisAccountParams> {
  final ActiveLicenseRepository _activeLicenseRepository;

  LinkCodToThisAccountUseCase(this._activeLicenseRepository);

  @override
  Future<Either<ServerFailureWithCode, void>> call(
    LinkCodToThisAccountParams params,
  ) async {
    final response = await _activeLicenseRepository.linkCodToThisAccount(
      params.newAccessToken,
      params.checkWarning,
    );

    if (response.status == ApiStatus.success) {
      return right(null);
    }

    return left(
      ServerFailureWithCode(code: response.code, message: response.message),
    );
  }
}

class LinkCodToThisAccountParams {
  final String newAccessToken;
  final bool checkWarning;

  LinkCodToThisAccountParams({
    required this.newAccessToken,
    this.checkWarning = false,
  });
}
