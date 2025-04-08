import 'package:formz/formz.dart';

// Định nghĩa các lỗi validation có thể xảy ra cho password
enum PasswordValidationError { empty, tooShort, tooLong, invalidCharacters }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  // Độ dài tối thiểu
  static const int minLength = 6;
  static const int maxLength = 30;

  // Regex chỉ cho phép các ký tự ASCII thường dùng trong mật khẩu (không dấu, không cách)
  // Có thể điều chỉnh để cho phép thêm ký tự đặc biệt nếu muốn (ví dụ: !@#$%^&*())
  static final _passwordRegex = RegExp(r'^[a-zA-Z0-9!@#$%^&*()_+-=]*$');

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (value.length < minLength) {
      return PasswordValidationError.tooShort;
    }
    if (value.length > maxLength) {
      return PasswordValidationError.tooLong;
    }
    if (!_passwordRegex.hasMatch(value)) {
      return PasswordValidationError.invalidCharacters;
    }
    return null; // Hợp lệ
  }
}
