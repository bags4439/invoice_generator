import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_generator/data/datasource/firebase_invoice_datasource.dart';
import 'package:invoice_generator/domain/usecases/add_invoice_usecase.dart';
import 'package:invoice_generator/domain/usecases/delete_invoice_usecase.dart';
import 'package:invoice_generator/domain/usecases/get_all_invoices_usecase.dart';
import 'package:invoice_generator/domain/usecases/get_remote_enabled_state_usecase.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import 'invoice_notifier.dart';

final firebaseDatasourceProvider = Provider(
  (ref) => FirebaseInvoiceDatasource(),
);
final invoiceRepositoryProvider = Provider(
  (ref) => InvoiceRepositoryImpl(ref.read(firebaseDatasourceProvider)),
);
final addInvoiceUseCaseProvider = Provider(
  (ref) => AddInvoiceUseCase(ref.read(invoiceRepositoryProvider)),
);
final getAllInvoicesUseCaseProvider = Provider(
  (ref) => GetAllInvoicesUseCase(ref.read(invoiceRepositoryProvider)),
);
final getRemoteEnabledProvider = Provider(
  (ref) => GetRemoteEnabledUseCase(ref.read(invoiceRepositoryProvider)),
);
final deleteInvoiceUseCaseProvider = Provider(
  (ref) => DeleteInvoiceUseCase(ref.read(invoiceRepositoryProvider)),
);

final invoiceNotifierProvider = StateNotifierProvider<InvoiceNotifier, List>(
  (ref) => InvoiceNotifier(
    ref.read(addInvoiceUseCaseProvider),
    ref.read(getAllInvoicesUseCaseProvider),
    ref.read(getRemoteEnabledProvider),
    ref.read(deleteInvoiceUseCaseProvider),
  ),
);
