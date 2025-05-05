part of 'active_license_cubit.dart';

class ActiveLicenseState extends Equatable {
  final bool isShowScanner;
  final LicenseCodeValidator licenseCode;
  final bool isLoading;
  final String? verifyLicenseError;
  final LicenseCodeInfoEntity? licenseInfo;
  final PhoneValidator phone;

  const ActiveLicenseState({
    this.isShowScanner = false,
    this.licenseCode = const LicenseCodeValidator.pure(),
    this.isLoading = false,
    this.verifyLicenseError,
    this.licenseInfo,
    this.phone = const PhoneValidator.pure(),
  });

  ActiveLicenseState copyWith({
    bool? isShowScanner,
    LicenseCodeValidator? licenseCode,
    bool? isLoading,
    String? verifyLicenseError,
    LicenseCodeInfoEntity? licenseInfo,
    bool? clearVerifyError,
    PhoneValidator? phone,
  }) {
    return ActiveLicenseState(
      isShowScanner: isShowScanner ?? this.isShowScanner,
      licenseCode: licenseCode ?? this.licenseCode,
      isLoading: isLoading ?? this.isLoading,
      verifyLicenseError:
          clearVerifyError == true
              ? null
              : verifyLicenseError ?? this.verifyLicenseError,
      licenseInfo: licenseInfo ?? this.licenseInfo,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [
    isShowScanner,
    licenseCode,
    isLoading,
    verifyLicenseError,
    licenseInfo,
    phone,
  ];
}
