import 'package:go_router/go_router.dart';
import 'package:invoice_generator/presentation/screens/invoice_view_screen.dart';
import 'package:invoice_generator/presentation/widgets/document_type.dart';
import '../screens/home_screen.dart';
import '../screens/invoice_edit_screen.dart';
import '../../domain/entities/invoice.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(
        path: '/add-invoice',
        builder: (context, state) {
          final data = state.extra as Map;
          final invoice = data['invoice'] as InvoiceEntity?;
          final lastInvoiceNo = data['lastInvoiceNo'] as String?;
          final lastReceiptNo = data['lastReceiptNo'] as String?;
          final documentType = data['documentType'] as DocumentType?;
          return InvoiceEditScreen(
            type: documentType ?? DocumentType.invoice,
            invoice: invoice,
            lastInvoiceNo: lastInvoiceNo,
            lastReceiptNo: lastReceiptNo,
          );
        },
      ),
      GoRoute(
        path: '/invoice-view',
        builder: (context, state) {
          final invoice = state.extra as InvoiceEntity;
          return InvoiceViewScreen(invoice: invoice);
        },
      ),
    ],
  );
}
