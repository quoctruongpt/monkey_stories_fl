import 'package:dio/dio.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/data/models/active_license/license_code_info_res_model.dart';
import 'package:monkey_stories/data/models/api_response.dart';
import 'package:monkey_stories/domain/entities/active_license/license_code_info.dart';

abstract class ActiveLicenseRemoteDataSource {
  Future<ApiResponse<LicenseCodeInfoEntity?>> verifyLicenseCode(
    String licenseCode,
  );
}

class ActiveLicenseRemoteDataSourceImpl
    implements ActiveLicenseRemoteDataSource {
  final Dio dio;

  ActiveLicenseRemoteDataSourceImpl({required this.dio});

  @override
  Future<ApiResponse<LicenseCodeInfoEntity?>> verifyLicenseCode(
    String licenseCode,
  ) async {
    final response = await dio.post(
      ApiEndpoints.verifyLicenseCode,
      data: {'license_code': licenseCode},
    );

    return ApiResponse.fromJson(
      response.data,
      (json) =>
          json is Map<String, dynamic>
              ? LicenseCodeInfoResModel.fromJson(json).toEntity()
              : null,
    );
  }
}
