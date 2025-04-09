import 'package:equatable/equatable.dart';
import 'package:monkey_stories/models/validate/password.dart';
import 'package:monkey_stories/models/validate/username.dart';

// Enum để biểu thị các trạng thái của việc gửi form
enum FormSubmissionStatus {
  initial, // Trạng thái ban đầu, chưa gửi
  loading, // Đang gửi (ví dụ: gọi API)
  success, // Gửi thành công
  failure, // Gửi thất bại (lỗi validation hoặc lỗi từ backend)
}

class LoginState extends Equatable {
  final Username username;
  final Password password;
  final FormSubmissionStatus status;
  final String? errorMessage; // Lỗi chung từ server (ví dụ: sai tài khoản)
  final bool isPasswordVisible;
  final bool isValidForm;

  const LoginState({
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.status = FormSubmissionStatus.initial,
    this.errorMessage,
    this.isPasswordVisible = false,
    this.isValidForm = false,
  });

  // Hàm tiện ích để tạo bản sao của state với các giá trị được cập nhật
  LoginState copyWith({
    Username? username,
    Password? password,
    FormSubmissionStatus? status,
    String? errorMessage,
    bool? isPasswordVisible,
    bool? isValidForm,
    bool clearErrorMessage = false, // Thêm cờ để xóa lỗi
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isValidForm: isValidForm ?? this.isValidForm,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
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
  ];
}
