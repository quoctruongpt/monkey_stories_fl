import 'package:formz/formz.dart';

class PasswordRules {
  static const int minLength = 4;
  static const int maxLength = 30;
  static final passwordRegex = RegExp(r'^[a-zA-Z0-9!@#$%^&*()_+-=]*$');
}

class Password extends FormzInput<String, String> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

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
    return null; // Hợp lệ
  }
}
