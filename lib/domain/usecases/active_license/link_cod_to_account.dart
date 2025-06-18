import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/active_license_repository.dart';
import 'package:monkey_stories/domain/repositories/auth_repository.dart';

class LinkCodToAccountUseCase extends UseCase<void, LinkCodToAccountParams> {
  final ActiveLicenseRepository _activeLicenseRepository;
  final AuthRepository _authRepository;

  LinkCodToAccountUseCase(this._activeLicenseRepository, this._authRepository);

  @override
  Future<Either<ServerFailureWithCode, void>> call(
    LinkCodToAccountParams params,
  ) async {
    final response = await _activeLicenseRepository.linkCodToAccount(
      oldAccessToken: params.oldAccessToken,
      newAccessToken: params.newAccessToken,
      checkWarning: params.checkWarning,
    );

    if (response.status == ApiStatus.success) {
      await _authRepository.cacheDataLogin(
        accessToken: params.oldAccessToken,
        refreshToken: '',
        loginType: params.phone != null ? LoginType.phone : LoginType.email,
        phone: params.phone,
        email: params.email,
        isSocial: params.isSocial,
      );

      return right(null);
    }

    return left(
      ServerFailureWithCode(code: response.code, message: response.message),
    );
  }
}

class LinkCodToAccountParams {
  final String oldAccessToken;
  final String newAccessToken;
  final String? phone;
  final String? email;
  final bool isSocial;
  final bool checkWarning;

  LinkCodToAccountParams({
    required this.oldAccessToken,
    required this.newAccessToken,
    this.phone,
    this.email,
    required this.isSocial,
    this.checkWarning = false,
  });
}
