import 'package:monkey_stories/domain/entities/active_license/account_info.dart';
import 'package:monkey_stories/domain/entities/active_license/package_info.dart';

class LicenseCodeInfoEntity {
  final PackageInfoEntity packageInfo;
  final AccountInfoEntity? accountInfo;
  final String newAccessToken;

  LicenseCodeInfoEntity({
    required this.packageInfo,
    this.accountInfo,
    required this.newAccessToken,
  });
}
