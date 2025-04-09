import 'package:formz/formz.dart';

class Password extends FormzInput<String, String> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  // Độ dài tối thiểu
  static const int minLength = 4;
  static const int maxLength = 30;

  // Regex chỉ cho phép các ký tự ASCII thường dùng trong mật khẩu (không dấu, không cách)
  // Có thể điều chỉnh để cho phép thêm ký tự đặc biệt nếu muốn (ví dụ: !@#$%^&*())
  static final _passwordRegex = RegExp(r'^[a-zA-Z0-9!@#$%^&*()_+-=]*$');

  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.password.empty';
    }
    if (value.length < minLength) {
      return 'validation.password.too_short';
    }
    if (value.length > maxLength) {
      return 'validation.password.too_long';
    }
    if (!_passwordRegex.hasMatch(value)) {
      return 'validation.password.invalid_characters';
    }
    return null; // Hợp lệ
  }
}
