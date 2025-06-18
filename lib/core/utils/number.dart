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

String formatDuration(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
