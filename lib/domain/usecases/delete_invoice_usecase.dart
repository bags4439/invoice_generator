import 'package:invoice_generator/domain/repositories/invoice_repository.dart';

class DeleteInvoiceUseCase {
  final InvoiceRepository repository;

  DeleteInvoiceUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteInvoice(id);
  }
}
