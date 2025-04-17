import 'package:formz/formz.dart';

class OtpValidator extends FormzInput<String, String> {
  const OtpValidator.pure() : super.pure('');
  const OtpValidator.dirty([String value = '']) : super.dirty(value);

  static final _otpRegex = RegExp(r'^[0-9]{4}$');

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'Vui lòng nhập OTP';
    }
    if (value.length != 4) {
      return 'OTP phải có 4 chữ số';
    }
    if (!_otpRegex.hasMatch(value)) {
      return 'OTP không hợp lệ';
    }
    return null;
  }
}
