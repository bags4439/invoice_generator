import '../repositories/invoice_repository.dart';

class GetRemoteEnabledUseCase {
  final InvoiceRepository repository;

  GetRemoteEnabledUseCase(this.repository);

  Future<bool> call() async {
    return repository.getRemoteEnabled();
  }
}
