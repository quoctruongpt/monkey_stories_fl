import 'package:formz/formz.dart';

class EmailValidator extends FormzInput<String, String> {
  // Constructor cho trạng thái "pure" (chưa chỉnh sửa)
  const EmailValidator.pure() : super.pure('');

  // Constructor cho trạng thái "dirty" (đã chỉnh sửa)
  const EmailValidator.dirty([super.value = '']) : super.dirty();

  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.email.empty';
    }
    if (value.length < 6 || value.length > 100) {
      return 'validation.email.length';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'validation.email.invalid';
    }
    return null;
  }
}
