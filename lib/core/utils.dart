import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

String generateLocalId() => const Uuid().v4();

int number = 1700;

String generateInvoiceNumber() {
  // final ts = DateTime.now().millisecondsSinceEpoch;
  // return ts.toString().substring(ts.toString().length - 6);

  number++;
  return '$number';
}

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatAsPrice(num amount, {bool showCurrency = true}) {
  final formatter = NumberFormat.currency(
    locale: 'en_GH', // Ghana locale
    symbol: showCurrency ? '₵' : '', // Cedi symbol
  );
  return formatter.format(amount);
}
