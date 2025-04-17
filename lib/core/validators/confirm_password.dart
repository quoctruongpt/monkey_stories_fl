import 'package:formz/formz.dart';
import 'package:monkey_stories/core/validators/password.dart';

// Giả sử bạn có key lỗi này trong file localization
const String kValidationErrorPasswordNotMatch = 'validation.password.not_match';
const String kValidationErrorConfirmPasswordEmpty =
    'validation.confirm_password.empty';

class ConfirmedPassword extends FormzInput<String, String> {
  // Constructor cho trạng thái "pure" (chưa nhập liệu)
  // Mật khẩu gốc lúc này chưa quan trọng lắm
  const ConfirmedPassword.pure() : originalPassword = '', super.pure('');

  // Constructor cho trạng thái "dirty" (đã nhập liệu)
  // Cần mật khẩu gốc để so sánh
  const ConfirmedPassword.dirty({
    required this.originalPassword,
    String value = '',
  }) : super.dirty(value);

  // Lưu trữ mật khẩu gốc để so sánh
  final String originalPassword;

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'validation.password.empty';
    }
    if (value.length < PasswordRules.minLength ||
        value.length > PasswordRules.maxLength) {
      return 'validation.password.length';
    }
    if (!PasswordRules.passwordRegex.hasMatch(value)) {
      return 'validation.password.invalid_characters';
    }
    // So sánh giá trị nhập vào với mật khẩu gốc
    return originalPassword == value
        ? null
        : 'sign_up.re_password.invalid'; // Key lỗi không khớp
  }
}
