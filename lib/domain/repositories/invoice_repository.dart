import 'package:invoice_generator/domain/entities/invoice.dart';

abstract class InvoiceRepository {
  Future addInvoice(InvoiceEntity invoice);
  Future deleteInvoice(String id);
  Future<List<InvoiceEntity>> getAll();
  Future uploadPendingInvoices();
  Future<bool> getRemoteEnabled();
}