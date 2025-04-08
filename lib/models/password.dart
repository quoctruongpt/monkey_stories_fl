import 'package:formz/formz.dart';

// Định nghĩa các lỗi validation có thể xảy ra cho password
enum PasswordValidationError { empty, tooShort }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  // Độ dài tối thiểu
  static const int minLength = 6;

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (value.length < minLength) {
      return PasswordValidationError.tooShort;
    }
    return null; // Hợp lệ
  }
}
