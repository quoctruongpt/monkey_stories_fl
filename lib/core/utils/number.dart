import 'package:intl/intl.dart';

String formatCurrency(
  double price,
  String currencyCode, {
  String locale = 'vi_VN',
}) {
  final format = NumberFormat.currency(
    locale: locale,
    symbol: '', // bỏ ký hiệu nếu bạn muốn tự thêm
    name: currencyCode,
  );
  return '${format.format(price)} $currencyCode';
}
