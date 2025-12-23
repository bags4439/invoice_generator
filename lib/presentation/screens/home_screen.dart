import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_generator/core/constants.dart';
import 'package:invoice_generator/presentation/providers/providers.dart';
import 'package:invoice_generator/presentation/widgets/document_type.dart';
import 'package:styled_widget/styled_widget.dart';
import 'invoice_list_screen.dart';
import 'package:go_router/go_router.dart';
import '../widgets/fab_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  DocumentType documentType = DocumentType.invoice;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: [
          [
            Text(
              'Invoices',
              style: TextStyle(
                color:
                    documentType == DocumentType.invoice
                        ? AppColors.primary
                        : Colors.blueGrey,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            SizedBox(height: 4, width: 50).decorated(
              color:
                  documentType == DocumentType.invoice
                      ? AppColors.primary
                      : Colors.transparent,
            ),
          ].toColumn().gestures(
            onTap: () {
              setState(() {
                documentType = DocumentType.invoice;
              });
            },
          ),
          SizedBox(width: 16),
          [
            Text(
              'Receipts',
              style: TextStyle(
                color:
                    documentType == DocumentType.receipt
                        ? AppColors.primary
                        : Colors.blueGrey,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold,
              ),
            ).gestures(
              onTap: () {
                setState(() {
                  documentType = DocumentType.receipt;
                });
              },
            ),
            SizedBox(height: 4),
            SizedBox(height: 4, width: 50).decorated(
              color:
                  documentType == DocumentType.receipt
                      ? AppColors.primary
                      : Colors.transparent,
            ),
          ].toColumn(),
        ].toRow(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        backgroundColor: AppColors.secondary,
      ),
      body: InvoiceListScreen(documentType: documentType),
      floatingActionButton: FABButton(
        onPressed: () {
          final notifier = ref.read(invoiceNotifierProvider.notifier);
          context.push(
            '/add-invoice',
            extra: {
              'lastInvoiceNo': notifier.getLastInvoiceNo(),
              'lastReceiptNo': notifier.getLastReceiptNo(),
            },
          );
        },
      ),
    );
  }
}
