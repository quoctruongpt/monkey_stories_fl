part of 'forgot_password_cubit.dart';

class FormValues {
  final String? phone;
  final String? email;
  final String? password;

  const FormValues({this.phone, this.email, this.password});
}

class ForgotPasswordState extends Equatable {
  ForgotPasswordState({
    this.method = ForgotPasswordType.phone,
    PhoneValidator? phone,
    this.email = const EmailValidator.pure(),
    this.otp = const OtpValidator.pure(),
    this.isLoading = false,
    this.otpError,
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmedPassword.pure(),
    this.isShowPassword = false,
    this.isShowNotRegisteredDialog = false,
    this.phoneErrorOther,
    this.otpResendTime = 0,
    this.otpWrongCount = 0,
    this.otpBlockTime,
    this.isShowOtpBlockDialog = false,
    this.formValues = const FormValues(),
  }) : phone = phone ?? PhoneValidator.pure(countryCode: '');

  // Phương thức gửi OTP
  final ForgotPasswordType method;
  // Số điện thoại
  final PhoneValidator phone;
  // Email
  final EmailValidator email;
  // OTP
  final OtpValidator otp;
  // Loading
  final bool isLoading;
  // Lỗi OTP
  final String? otpError;
  // Mật khẩu
  final Password password;
  // Xác nhận mật khẩu
  final ConfirmedPassword confirmPassword;
  // Hiển thị mật khẩu
  final bool isShowPassword;
  // Hiển thị dialog không tìm thấy tài khoản
  final bool isShowNotRegisteredDialog;
  // Lỗi khi gửi OTP số điện thoại
  final String? phoneErrorOther;
  // Thời gian gửi lại OTP
  final int otpResendTime;
  // Số lần nhập sai OTP
  final int otpWrongCount;
  // Thời gian chặn xác thực OTP
  final int? otpBlockTime;
  // Hiển thị dialog lỗi gửi OTP quá nhiều lần
  final bool isShowOtpBlockDialog;
  final FormValues formValues;

  ForgotPasswordState copyWith({
    ForgotPasswordType? method,
    PhoneValidator? phone,
    EmailValidator? email,
    OtpValidator? otp,
    bool? isLoading,
    String? otpError,
    Password? password,
    ConfirmedPassword? confirmPassword,
    bool? isShowPassword,
    bool? isShowNotRegisteredDialog,
    String? phoneErrorOther,
    bool? clearPhoneErrorOther,
    bool? clearOtpBlockTime,
    int? otpResendTime,
    int? otpWrongCount,
    int? otpBlockTime,
    bool? isShowOtpBlockDialog,
    FormValues? formValues,
  }) {
    return ForgotPasswordState(
      method: method ?? this.method,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      isLoading: isLoading ?? this.isLoading,
      otpError: otpError ?? this.otpError,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isShowPassword: isShowPassword ?? this.isShowPassword,
      isShowNotRegisteredDialog:
          isShowNotRegisteredDialog ?? this.isShowNotRegisteredDialog,
      phoneErrorOther:
          clearPhoneErrorOther == true
              ? null
              : phoneErrorOther ?? this.phoneErrorOther,
      otpResendTime: otpResendTime ?? this.otpResendTime,
      otpWrongCount: otpWrongCount ?? this.otpWrongCount,
      otpBlockTime:
          clearOtpBlockTime == true ? null : otpBlockTime ?? this.otpBlockTime,
      isShowOtpBlockDialog: isShowOtpBlockDialog ?? this.isShowOtpBlockDialog,
      formValues: formValues ?? this.formValues,
    );
  }

  @override
  List<Object?> get props => [
    method,
    phone,
    email,
    otp,
    isLoading,
    otpError,
    password,
    confirmPassword,
    isShowPassword,
    isShowNotRegisteredDialog,
    phoneErrorOther,
    otpResendTime,
    otpWrongCount,
    otpBlockTime,
    isShowOtpBlockDialog,
    formValues,
  ];
}
