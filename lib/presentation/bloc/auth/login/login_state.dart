import 'package:equatable/equatable.dart';
import 'package:monkey_stories/domain/entities/active_license/license_code_info.dart';
import 'package:monkey_stories/domain/entities/auth/last_login_entity.dart';
import 'package:monkey_stories/core/validators/password.dart';
import 'package:monkey_stories/core/validators/username.dart';

// Enum để biểu thị các trạng thái của việc gửi form
enum FormSubmissionStatus {
  initial, // Trạng thái ban đầu, chưa gửi
  loading, // Đang gửi (ví dụ: gọi API)
  success, // Gửi thành công
  failure, // Gửi thất bại (lỗi validation hoặc lỗi từ backend)
  maxAttemptsReached, // Thêm trạng thái mới khi đạt tối đa số lần thử
}

class LastLoginInfo extends LastLoginEntity {
  @override
  final String? name;

  LastLoginInfo({
    this.name,
    required super.loginType,
    super.phone,
    super.email,
    super.appleUserCredential,
    super.token,
  });
}

class LoginState extends Equatable {
  final Username username;
  final Password password;
  final FormSubmissionStatus status;
  final String? errorMessage; // Lỗi chung từ server (ví dụ: sai tài khoản)
  final bool isPasswordVisible;
  final bool isValidForm;
  final int failedAttempts; // Thêm bộ đếm số lần thất bại
  final String? errorMessageDialog;
  final LastLoginInfo? lastLogin;
  final LicenseCodeInfoEntity? licenseCodeInfo;

  const LoginState({
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.status = FormSubmissionStatus.initial,
    this.errorMessage,
    this.isPasswordVisible = false,
    this.isValidForm = false,
    this.failedAttempts = 0, // Khởi tạo bộ đếm
    this.errorMessageDialog,
    this.lastLogin,
    this.licenseCodeInfo,
  });

  // Hàm tiện ích để tạo bản sao của state với các giá trị được cập nhật
  LoginState copyWith({
    Username? username,
    Password? password,
    FormSubmissionStatus? status,
    String? errorMessage,
    bool? isPasswordVisible,
    bool? isValidForm,
    int? failedAttempts, // Thêm failedAttempts vào copyWith
    bool clearErrorMessage = false, // Thêm cờ để xóa lỗi
    String? errorMessageDialog,
    LastLoginInfo? lastLogin,
    LicenseCodeInfoEntity? licenseCodeInfo,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isValidForm: isValidForm ?? this.isValidForm,
      failedAttempts:
          failedAttempts ?? this.failedAttempts, // Cập nhật failedAttempts
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      errorMessageDialog:
          clearErrorMessage
              ? null
              : errorMessageDialog ?? this.errorMessageDialog,
      lastLogin: lastLogin ?? this.lastLogin,
      licenseCodeInfo: licenseCodeInfo ?? this.licenseCodeInfo,
    );
  }

  @override
  List<Object?> get props => [
    username,
    password,
    status,
    errorMessage,
    isPasswordVisible,
    isValidForm,
    failedAttempts, // Thêm failedAttempts vào props
    errorMessageDialog,
    licenseCodeInfo,
  ];
}
