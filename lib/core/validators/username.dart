import 'package:formz/formz.dart';
import 'package:monkey_stories/core/validators/email.dart';

class Username extends FormzInput<String, String> {
  // Constructor cho trạng thái "pure" (chưa chỉnh sửa)
  const Username.pure() : super.pure('');

  // Constructor cho trạng thái "dirty" (đã chỉnh sửa)
  const Username.dirty([super.value = '']) : super.dirty();

  static const int minLength = 6;
  static const int maxLength = 15;

  // Regex ví dụ (có thể điều chỉnh theo yêu cầu thực tế)
  static final _usernameRegex = RegExp(r'^\+?[a-zA-Z0-9_.]*$');

  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.username.empty';
    }

    // Kiểm tra xem là email hay username
    if (value.contains('@')) {
      // Nếu là email, sử dụng EmailValidator
      final emailInput = EmailValidator.dirty(value);
      return emailInput.error;
    } else {
      // Nếu là username
      if (value.length < minLength || value.length > maxLength) {
        return 'validation.username.length'; // Lỗi độ dài username
      }
      if (!_usernameRegex.hasMatch(value)) {
        return 'validation.username.invalid'; // Lỗi định dạng username
      }
    }

    return null; // Hợp lệ
  }
}
