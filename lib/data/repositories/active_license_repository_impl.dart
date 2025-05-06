import 'package:monkey_stories/data/datasources/active_license/active_license_remote_data_source.dart';
import 'package:monkey_stories/data/datasources/auth/auth_local_data_source.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/domain/entities/active_license/license_code_info.dart';
import 'package:monkey_stories/domain/repositories/active_license_repository.dart';
import 'package:monkey_stories/data/models/active_license/link_account_res_model.dart';

class ActiveLicenseRepositoryImpl implements ActiveLicenseRepository {
  final ActiveLicenseRemoteDataSource activeLicenseRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  ActiveLicenseRepositoryImpl({
    required this.activeLicenseRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<ApiResponse<LicenseCodeInfoEntity?>> verifyLicenseCode(
    String licenseCode,
  ) {
    return activeLicenseRemoteDataSource.verifyLicenseCode(licenseCode);
  }

  @override
  Future<ApiResponse<LinkAccountResModel?>> linkCodToThisAccount(
    String newAccessToken,
    bool checkWarning,
  ) async {
    final oldAccessToken = await authLocalDataSource.getToken();

    return activeLicenseRemoteDataSource.linkCodToAccount(
      oldAccessToken: oldAccessToken ?? '',
      newAccessToken: newAccessToken,
      checkWarning: checkWarning,
    );
  }

  @override
  Future<ApiResponse<LinkAccountResModel?>> linkCodToAccount({
    required String oldAccessToken,
    required String newAccessToken,
    bool checkWarning = false,
  }) async {
    return activeLicenseRemoteDataSource.linkCodToAccount(
      oldAccessToken: oldAccessToken,
      newAccessToken: newAccessToken,
      checkWarning: checkWarning,
    );
  }
}
