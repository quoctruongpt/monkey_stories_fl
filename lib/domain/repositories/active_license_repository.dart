import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/domain/entities/active_license/license_code_info.dart';

abstract class ActiveLicenseRepository {
  Future<ApiResponse<LicenseCodeInfoEntity?>> verifyLicenseCode(
    String licenseCode,
  );
}
