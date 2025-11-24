import 'package:go_router/go_router.dart';
import 'package:invoice_generator/presentation/screens/invoice_view_screen.dart';
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
            final invoice = state.extra as InvoiceEntity?;
            print('add invoice: $invoice');
            return InvoiceEditScreen(
              type: InvoiceEntityType.invoice,
              invoice: invoice,
            );
          }),
      GoRoute(
          path: '/add-receipt',
          builder: (_, __) =>
              const InvoiceEditScreen(type: InvoiceEntityType.receipt)),
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
