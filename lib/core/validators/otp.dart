import 'package:formz/formz.dart';

const otpLength = 4;

class OtpValidator extends FormzInput<String, String> {
  const OtpValidator.pure() : super.pure('');
  const OtpValidator.dirty([String value = '']) : super.dirty(value);

  static final _otpRegex = RegExp(r'^[0-9]{4}$');

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'app.otp.empty';
    }
    if (value.length != otpLength) {
      return 'app.otp.length';
    }
    if (!_otpRegex.hasMatch(value)) {
      return 'app.otp.invalid';
    }
    return null;
  }
}
