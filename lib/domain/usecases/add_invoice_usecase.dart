import 'package:invoice_generator/domain/entities/invoice.dart';
import 'package:invoice_generator/domain/repositories/invoice_repository.dart';

class AddInvoiceUseCase {
  final InvoiceRepository repository;

  AddInvoiceUseCase(this.repository);

  Future<void> call(InvoiceEntity invoice) async {
    await repository.addInvoice(invoice);
  }
}
