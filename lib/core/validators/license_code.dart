import 'package:formz/formz.dart';

class LicenseCodeValidator extends FormzInput<String, String> {
  // Constructor cho trạng thái "pure" (chưa chỉnh sửa)
  const LicenseCodeValidator.pure() : super.pure('');

  // Constructor cho trạng thái "dirty" (đã chỉnh sửa)
  const LicenseCodeValidator.dirty([super.value = '']) : super.dirty();

  static final _licenseCodeRegex = RegExp(r'^[A-Za-z0-9]{10}$');

  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mã kích hoạt';
    }
    if (value.length != 10) {
      return 'Mã kích hoạt phải bao gồm 10 ký tự';
    }
    if (!_licenseCodeRegex.hasMatch(value)) {
      return 'Mã kích hoạt chỉ chấp nhận chữ và số';
    }
    return null;
  }
}
