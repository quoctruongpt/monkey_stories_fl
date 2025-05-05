part of 'active_license_cubit.dart';

class ActiveLicenseState extends Equatable {
  final bool isShowScanner;
  final bool isLoading;

  final LicenseCodeValidator licenseCode;
  final String? verifyLicenseError;
  final LicenseCodeInfoEntity? licenseInfo;

  final PhoneValidator phone;
  final AccountInfoEntity? phoneInfo;
  final bool? isNewPhoneValid;
  final String? checkPhoneError;

  const ActiveLicenseState({
    this.isShowScanner = false,
    this.licenseCode = const LicenseCodeValidator.pure(),
    this.isLoading = false,
    this.verifyLicenseError,
    this.licenseInfo,
    this.phone = const PhoneValidator.pure(),
    this.phoneInfo,
    this.isNewPhoneValid,
    this.checkPhoneError,
  });

  ActiveLicenseState copyWith({
    bool? isShowScanner,
    LicenseCodeValidator? licenseCode,
    bool? isLoading,
    String? verifyLicenseError,
    LicenseCodeInfoEntity? licenseInfo,
    bool? clearVerifyError,
    PhoneValidator? phone,
    AccountInfoEntity? phoneInfo,
    bool? isNewPhoneValid,
    bool? clearPhoneInfo,
    String? checkPhoneError,
    bool? clearPhoneError,
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
      phoneInfo: clearPhoneInfo == true ? null : phoneInfo ?? this.phoneInfo,
      isNewPhoneValid:
          clearPhoneInfo == true
              ? null
              : isNewPhoneValid ?? this.isNewPhoneValid,
      checkPhoneError:
          clearPhoneError == true
              ? null
              : checkPhoneError ?? this.checkPhoneError,
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
    phoneInfo,
    isNewPhoneValid,
    checkPhoneError,
  ];
}
