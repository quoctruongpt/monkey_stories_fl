import 'package:monkey_stories/data/datasources/active_license/active_license_remote_data_source.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/domain/entities/active_license/license_code_info.dart';
import 'package:monkey_stories/domain/repositories/active_license_repository.dart';

class ActiveLicenseRepositoryImpl implements ActiveLicenseRepository {
  final ActiveLicenseRemoteDataSource activeLicenseRemoteDataSource;

  ActiveLicenseRepositoryImpl({required this.activeLicenseRemoteDataSource});

  @override
  Future<ApiResponse<LicenseCodeInfoEntity?>> verifyLicenseCode(
    String licenseCode,
  ) {
    return activeLicenseRemoteDataSource.verifyLicenseCode(licenseCode);
  }
}
