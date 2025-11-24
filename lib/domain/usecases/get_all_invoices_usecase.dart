import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

class GetAllInvoicesUseCase {
  final InvoiceRepository repository;

  GetAllInvoicesUseCase(this.repository);

  Future<List<InvoiceEntity>> call() async {
    return repository.getAll();
  }
}
