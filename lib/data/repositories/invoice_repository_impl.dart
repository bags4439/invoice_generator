import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:invoice_generator/data/datasource/firebase_invoice_datasource.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../models/invoice.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final FirebaseInvoiceDatasource datasource;
  final Box pendingBox = Hive.box('pending_invoices');

  InvoiceRepositoryImpl(this.datasource);

  @override
  Future<void> addInvoice(InvoiceEntity invoice) async {
    final model = Invoice.fromEntity(invoice);
    final map = model.toMap();
    try {
      await datasource.saveInvoice(map);
    } catch (e) {
      // store locally for later sync
      pendingBox.put(invoice.id, jsonEncode(map));
      rethrow;
    }
  }

  @override
  Future<List<InvoiceEntity>> getAll() async {
    final maps = await datasource.fetchAll();
    return maps.map((m) => Invoice.fromMap(m).toEntity()).toList();
  }

  @override
  Future<void> uploadPendingInvoices() async {
    final keys = pendingBox.keys.toList();
    for (final key in keys) {
      final jsonStr = pendingBox.get(key) as String;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      await datasource.saveInvoice(map);
      pendingBox.delete(key);
    }
  }

  @override
  Future<bool> getRemoteEnabled() async {
    return datasource.fetchEnabled();
  }
}
