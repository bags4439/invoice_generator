import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_generator/domain/usecases/delete_invoice_usecase.dart';
import 'package:invoice_generator/presentation/widgets/document_type.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/usecases/add_invoice_usecase.dart';
import '../../domain/usecases/get_all_invoices_usecase.dart';
import '../../domain/usecases/get_remote_enabled_state_usecase.dart';

class InvoiceNotifier extends StateNotifier<List<InvoiceEntity>> {
  final AddInvoiceUseCase addInvoice;
  final GetAllInvoicesUseCase getAllInvoices;
  final GetRemoteEnabledUseCase getRemoteEnabled;
  final DeleteInvoiceUseCase deleteInvoiceUseCase;
  bool enabled = true;

  InvoiceNotifier(
    this.addInvoice,
    this.getAllInvoices,
    this.getRemoteEnabled,
    this.deleteInvoiceUseCase,
  ) : super([]) {
    _init();
  }

  Future<void> _init() async {
    enabled = await getRemoteEnabled();
    state = await getAllInvoices();
  }

  Future<void> add(InvoiceEntity invoice) async {
    await addInvoice(invoice);
    if (state.where((inv) => inv.id == invoice.id).isNotEmpty) {
      state[state.indexWhere((inv) => inv.id == invoice.id)] = invoice;
      state = state;
    } else {
      state = [...state, invoice];
    }
  }

  Future<void> delete(String id) async {
    await deleteInvoiceUseCase(id);
    state = [...state.where((inv) => inv.id != id)];
  }

  String? getLastInvoiceNo() {
    return state
        .where((inv) => inv.type.name.contains(DocumentType.invoice.name))
        .toList()
        .reversed
        .firstOrNull
        ?.number;
  }

  String? getLastReceiptNo() {
    return state
        .where((inv) => inv.type.name.contains(DocumentType.receipt.name))
        .toList()
        .reversed
        .firstOrNull
        ?.number;
  }
}
