import 'package:monkey_stories/data/models/auth/account_info_res_model.dart';
import 'package:monkey_stories/data/models/active_license/package_info_res_model.dart';
import 'package:monkey_stories/domain/entities/active_license/license_code_info.dart';

class LicenseCodeInfoResModel {
  final PackageInfoResModel packageInfo;
  final AccountInfoResModel? oldInfo;
  final String newAccessToken;

  LicenseCodeInfoResModel({
    required this.packageInfo,
    this.oldInfo,
    required this.newAccessToken,
  });

  factory LicenseCodeInfoResModel.fromJson(Map<String, dynamic> json) {
    return LicenseCodeInfoResModel(
      packageInfo: PackageInfoResModel.fromJson(json['package']),
      oldInfo:
          json['old_info'] != null
              ? AccountInfoResModel.fromJson(json['old_info'])
              : null,
      newAccessToken: json['new_access_token'],
    );
  }

  LicenseCodeInfoEntity toEntity() {
    return LicenseCodeInfoEntity(
      packageInfo: packageInfo.toEntity(),
      accountInfo: oldInfo?.toEntity(),
      newAccessToken: newAccessToken,
    );
  }
}
