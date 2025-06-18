import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/domain/entities/active_license/license_code_info.dart';
import 'package:monkey_stories/data/models/active_license/link_account_res_model.dart';

abstract class ActiveLicenseRepository {
  Future<ApiResponse<LicenseCodeInfoEntity?>> verifyLicenseCode(
    String licenseCode,
  );

  Future<ApiResponse<LicenseCodeInfoEntity?>> verifyCodUserCrm(
    String username,
    String password,
  );

  Future<ApiResponse<LinkAccountResModel?>> linkCodToThisAccount(
    String newAccessToken,
    bool checkWarning,
  );

  Future<ApiResponse<LinkAccountResModel?>> linkCodToAccount({
    required String oldAccessToken,
    required String newAccessToken,
    bool checkWarning = false,
  });
}
