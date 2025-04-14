// part of 'sign_up_cubit.dart';

// class SignUpState extends Equatable {
//   final StepSignUp step;
//   final PhoneValidator phone;
//   final Password password;
//   final Password confirmPassword;
//   final bool? isCheckingPhone;
//   final String? phoneErrorMessage;
//   final int? phoneErrorCode;
//   final bool isPhoneValid;
//   final bool isShowPassword;
//   final bool isConfirmPasswordCorrect;
//   final bool isSignUpSuccess;
//   final bool isSignUpLoading;
//   final String? signUpErrorMessage;
//   final String? popupErrorMessage;

//   const SignUpState({
//     required this.step,
//     required this.isShowPassword,
//     this.phone = const PhoneValidator.pure(),
//     this.password = const Password.pure(),
//     this.confirmPassword = const Password.pure(),
//     this.isCheckingPhone = false,
//     this.phoneErrorMessage,
//     this.phoneErrorCode,
//     this.isPhoneValid = false,
//     this.isConfirmPasswordCorrect = false,
//     this.isSignUpSuccess = false,
//     this.isSignUpLoading = false,
//     this.signUpErrorMessage,
//     this.popupErrorMessage,
//   });

//   SignUpState copyWith({
//     StepSignUp? step,
//     PhoneValidator? phone,
//     Password? password,
//     Password? confirmPassword,
//     bool? isCheckingPhone,
//     String? phoneErrorMessage,
//     int? phoneErrorCode,
//     bool? isPhoneValid,
//     bool? clearPhoneErrorMessage,
//     bool? isShowPassword,
//     bool? isConfirmPasswordCorrect,
//     bool? isSignUpSuccess,
//     bool? isSignUpLoading,
//     String? signUpErrorMessage,
//     String? popupErrorMessage,
//   }) {
//     return SignUpState(
//       step: step ?? this.step,
//       phone: phone ?? this.phone,
//       password: password ?? this.password,
//       confirmPassword: confirmPassword ?? this.confirmPassword,
//       isCheckingPhone: isCheckingPhone ?? this.isCheckingPhone,
//       phoneErrorMessage:
//           clearPhoneErrorMessage == true
//               ? null
//               : phoneErrorMessage ?? this.phoneErrorMessage,
//       phoneErrorCode:
//           clearPhoneErrorMessage == true
//               ? null
//               : phoneErrorCode ?? this.phoneErrorCode,
//       isPhoneValid: isPhoneValid ?? this.isPhoneValid,
//       isShowPassword: isShowPassword ?? this.isShowPassword,
//       isConfirmPasswordCorrect:
//           isConfirmPasswordCorrect ?? this.isConfirmPasswordCorrect,
//       isSignUpSuccess: isSignUpSuccess ?? this.isSignUpSuccess,
//       isSignUpLoading: isSignUpLoading ?? this.isSignUpLoading,
//       signUpErrorMessage:
//           clearPhoneErrorMessage == true
//               ? null
//               : signUpErrorMessage ?? this.signUpErrorMessage,
//       popupErrorMessage:
//           clearPhoneErrorMessage == true
//               ? null
//               : popupErrorMessage ?? this.popupErrorMessage,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     step,
//     phone,
//     password,
//     confirmPassword,
//     isCheckingPhone,
//     phoneErrorMessage,
//     phoneErrorCode,
//     isPhoneValid,
//     isShowPassword,
//     isConfirmPasswordCorrect,
//     isSignUpSuccess,
//     isSignUpLoading,
//     signUpErrorMessage,
//     popupErrorMessage,
//   ];
// }
