import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_generator/core/constants.dart';
import 'package:invoice_generator/core/utils.dart';
import 'package:invoice_generator/domain/entities/invoice.dart';
import 'package:invoice_generator/presentation/providers/providers.dart';
import 'package:styled_widget/styled_widget.dart';

class InvoiceListScreen extends ConsumerWidget {
  final String typeFilter;

  const InvoiceListScreen({super.key, required this.typeFilter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoices = ref.watch(invoiceNotifierProvider);
    final filtered =
        invoices.where((i) => i.type.toString().contains(typeFilter)).toList();

    filtered.sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        InvoiceEntity invoice = filtered[index];
        return Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: ListTile(
            title: Text(invoice.customerName,
                style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.bold)),
            subtitle: [
              Text(invoice.number,
                  style: TextStyle(fontFamily: 'Times New Roman')),
              SizedBox(
                width: 1,
                height: 16,
              ).decorated(color: Colors.grey).padding(horizontal: 8),
              Text(formatDate(invoice.date),
                  style: TextStyle(fontFamily: 'Times New Roman'))
            ].toRow(mainAxisSize: MainAxisSize.min),
            trailing: Text(invoice.total.toStringAsFixed(2),
                style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary)),
            onTap: () {
              context.push('/add-invoice', extra: invoice);
            },
          ).decorated(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
        );
      },
    );
  }
}
