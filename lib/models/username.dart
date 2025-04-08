import 'package:formz/formz.dart';

// Định nghĩa các lỗi validation có thể xảy ra cho username
enum UsernameValidationError { empty, invalid, tooShort, tooLong }

class Username extends FormzInput<String, UsernameValidationError> {
  // Constructor cho trạng thái "pure" (chưa chỉnh sửa)
  const Username.pure() : super.pure('');

  // Constructor cho trạng thái "dirty" (đã chỉnh sửa)
  const Username.dirty([super.value = '']) : super.dirty();

  static const int minLength = 6;
  static const int maxLength = 15;

  // Regex ví dụ (có thể điều chỉnh theo yêu cầu thực tế)
  // static final _usernameRegex = RegExp(r'^[a-zA-Z0-9_.]*$');

  @override
  UsernameValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return UsernameValidationError.empty;
    }
    if (value.length < minLength) {
      return UsernameValidationError.tooShort;
    }
    if (value.length > maxLength) {
      return UsernameValidationError.tooLong;
    }
    // Ví dụ thêm validation regex:
    // if (!_usernameRegex.hasMatch(value)) {
    //   return UsernameValidationError.invalid;
    // }
    return null; // Hợp lệ
  }
}
