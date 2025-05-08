part of 'active_license_cubit.dart';

class ActiveLicenseState extends Equatable {
  final bool isShowScanner;
  final bool isLoading;
  // isSuccess là trạng thái khi kích hoạt thành công
  final bool isSuccess;
  final String? linkAccountError;
  // isDone là trạng thái khi hoàn tất các bước kích hoạt, bao gồm cả cập nhật thông tin user và profile
  final bool isDone;

  final LicenseCodeValidator licenseCode;
  final String? verifyLicenseError;
  final LicenseCodeInfoEntity? licenseInfo;

  final PhoneValidator phone;
  final AccountInfoEntity? phoneInfo;
  final bool? isNewPhoneValid;
  final String? checkPhoneError;
  final Password password;
  final ConfirmedPassword rePassword;
  final String? loginError;
  final OtpValidator otp;
  final int otpResendTime;
  final String? sendOtpError;
  final PositionShowWarning showMergeLifetimeWarning;
  final bool isShowMergeToLifetimeAccountWarning;

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
    this.password = const Password.pure(),
    this.rePassword = const ConfirmedPassword.pure(),
    this.isSuccess = false,
    this.linkAccountError,
    this.loginError,
    this.otp = const OtpValidator.pure(),
    this.otpResendTime = 0,
    this.sendOtpError,
    this.showMergeLifetimeWarning = PositionShowWarning.none,
    this.isShowMergeToLifetimeAccountWarning = false,
    this.isDone = false,
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
    Password? password,
    ConfirmedPassword? rePassword,
    bool? isSuccess,
    String? linkAccountError,
    String? loginError,
    bool? clearLoginError,
    OtpValidator? otp,
    int? otpResendTime,
    String? sendOtpError,
    bool? clearSendOtpError,
    bool? clearLinkAccountError,
    PositionShowWarning? showMergeLifetimeWarning,
    bool? isShowMergeToLifetimeAccountWarning,
    bool? isDone,
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
      password: password ?? this.password,
      rePassword: rePassword ?? this.rePassword,
      isSuccess: isSuccess ?? this.isSuccess,
      linkAccountError:
          clearLinkAccountError == true
              ? null
              : linkAccountError ?? this.linkAccountError,
      loginError:
          clearLoginError == true ? null : loginError ?? this.loginError,
      otp: otp ?? this.otp,
      otpResendTime: otpResendTime ?? this.otpResendTime,
      sendOtpError:
          clearSendOtpError == true ? null : sendOtpError ?? this.sendOtpError,
      showMergeLifetimeWarning:
          showMergeLifetimeWarning ?? this.showMergeLifetimeWarning,
      isShowMergeToLifetimeAccountWarning:
          isShowMergeToLifetimeAccountWarning ??
          this.isShowMergeToLifetimeAccountWarning,
      isDone: isDone ?? this.isDone,
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
    password,
    rePassword,
    isSuccess,
    linkAccountError,
    loginError,
    otp,
    otpResendTime,
    sendOtpError,
    showMergeLifetimeWarning,
    isShowMergeToLifetimeAccountWarning,
    isDone,
  ];
}
