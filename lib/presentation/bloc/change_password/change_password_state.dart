part of 'change_password_cubit.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.currentPassword = const Password.pure(),
    this.newPassword = const Password.pure(),
    this.confirmPassword = const ConfirmedPassword.pure(),
    this.status = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.isCurrentPasswordObscured = true,
    this.isNewPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
  });

  final Password currentPassword;
  final Password newPassword;
  final ConfirmedPassword confirmPassword;
  final bool status;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final bool isCurrentPasswordObscured;
  final bool isNewPasswordObscured;
  final bool isConfirmPasswordObscured;

  ChangePasswordState copyWith({
    Password? currentPassword,
    Password? newPassword,
    ConfirmedPassword? confirmPassword,
    bool? status,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isCurrentPasswordObscured,
    bool? isNewPasswordObscured,
    bool? isConfirmPasswordObscured,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      isCurrentPasswordObscured:
          isCurrentPasswordObscured ?? this.isCurrentPasswordObscured,
      isNewPasswordObscured:
          isNewPasswordObscured ?? this.isNewPasswordObscured,
      isConfirmPasswordObscured:
          isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
    );
  }

  @override
  List<Object?> get props => [
    currentPassword,
    newPassword,
    confirmPassword,
    status,
    isLoading,
    isSuccess,
    errorMessage,
    isCurrentPasswordObscured,
    isNewPasswordObscured,
    isConfirmPasswordObscured,
  ];
}
