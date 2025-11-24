import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

String generateLocalId() => const Uuid().v4();

String generateInvoiceNumber() {
  final ts = DateTime.now().millisecondsSinceEpoch;
  return ts.toString().substring(ts.toString().length - 6);
}

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}
