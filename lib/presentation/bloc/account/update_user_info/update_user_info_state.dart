part of 'update_user_info_cubit.dart';

class UpdateUserInfoState extends Equatable {
  final NameValidator name;
  final PhoneValidator phone;
  final EmailValidator email;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final bool isButtonEnabled;
  final bool isPasswordAuthenticated;
  final Password password;
  final ConfirmedPassword rePassword;
  final String? passwordErrorMessage;
  final bool isPasswordConfirming;

  UpdateUserInfoState({
    this.name = const NameValidator.pure(),
    PhoneValidator? phone,
    this.email = const EmailValidator.pure(),
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.isButtonEnabled = false,
    this.isPasswordAuthenticated = false,
    this.password = const Password.pure(),
    this.passwordErrorMessage,
    this.isPasswordConfirming = false,
    this.rePassword = const ConfirmedPassword.pure(),
  }) : phone = phone ?? PhoneValidator.pure(countryCode: '');

  UpdateUserInfoState copyWith({
    NameValidator? name,
    PhoneValidator? phone,
    EmailValidator? email,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool? isButtonEnabled,
    bool? clearErrorMessage,
    bool? isPasswordAuthenticated,
    Password? password,
    String? passwordErrorMessage,
    bool? clearPasswordErrorMessage,
    bool? isPasswordConfirming,
    ConfirmedPassword? rePassword,
  }) {
    return UpdateUserInfoState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearErrorMessage ?? false ? null : errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      isPasswordAuthenticated:
          isPasswordAuthenticated ?? this.isPasswordAuthenticated,
      password: password ?? this.password,
      passwordErrorMessage:
          clearPasswordErrorMessage ?? false
              ? null
              : passwordErrorMessage ?? this.passwordErrorMessage,
      isPasswordConfirming: isPasswordConfirming ?? this.isPasswordConfirming,
      rePassword: rePassword ?? this.rePassword,
    );
  }

  @override
  List<Object?> get props => [
    name,
    phone,
    email,
    isLoading,
    isSuccess,
    errorMessage,
    isButtonEnabled,
    isPasswordAuthenticated,
    password,
    passwordErrorMessage,
    isPasswordConfirming,
    rePassword,
  ];
}
