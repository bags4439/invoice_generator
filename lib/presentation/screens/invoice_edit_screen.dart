import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_generator/core/constants.dart';
import 'package:invoice_generator/presentation/providers/providers.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/item.dart';
import '../../core/utils.dart';

class InvoiceEditScreen extends ConsumerStatefulWidget {
  final InvoiceEntityType type;
  final InvoiceEntity? invoice;

  const InvoiceEditScreen({super.key, required this.type, this.invoice});

  @override
  ConsumerState<InvoiceEditScreen> createState() => _InvoiceEditScreenState();
}

class _InvoiceEditScreenState extends ConsumerState<InvoiceEditScreen> {
  final _customerController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  List<ItemEntity> _items = [];
  List<TextEditingController> _descriptionControllers = [];
  List<TextEditingController> _quantityControllers = [];
  List<TextEditingController> _amountControllers = [];

  @override
  void initState() {
    super.initState();

    if (widget.invoice != null) {
      final invoice = widget.invoice!;
      _selectedDate = invoice.date;
      _customerController.text = invoice.customerName;

      _items = invoice.items
          .map((item) => ItemEntity(
                description: item.description,
                quantity: item.quantity,
                amount: item.amount,
              ))
          .toList();

      _descriptionControllers = _items
          .map((e) => TextEditingController(text: e.description))
          .toList();
      _quantityControllers = _items
          .map((e) => TextEditingController(text: e.quantity.toString()))
          .toList();
      _amountControllers = _items
          .map((e) => TextEditingController(text: e.amount.toString()))
          .toList();
    }
  }

  void _addItem() {
    setState(() {
      _items.add(ItemEntity(description: '', quantity: 1, amount: 0.0));
      _descriptionControllers.add(TextEditingController());
      _quantityControllers.add(TextEditingController(text: '1'));
      _amountControllers.add(TextEditingController(text: '0'));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _descriptionControllers.removeAt(index);
      _quantityControllers.removeAt(index);
      _amountControllers.removeAt(index);
    });
  }

  void _save() {
    final invoice = InvoiceEntity(
      id: widget.invoice?.id ?? generateLocalId(),
      type: widget.type,
      date: _selectedDate,
      customerName: _customerController.text,
      number: widget.invoice?.number ?? generateInvoiceNumber(),
      items: _items,
    );

    ref.read(invoiceNotifierProvider.notifier).add(invoice);

    // Safe navigation using GoRouter
    Future.microtask(() {
      if (!mounted) return;
      context.pushReplacement('/invoice-view', extra: invoice);
    });
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _customerController.dispose();
    for (var c in _descriptionControllers) c.dispose();
    for (var c in _quantityControllers) c.dispose();
    for (var c in _amountControllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          widget.type == InvoiceEntityType.invoice
              ? 'Add Invoice'
              : 'Add Receipt',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 16),
              [
                Text(
                  'Date: ',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(width: 16),
                Text(formatDate(_selectedDate)),
                Icon(Icons.arrow_drop_down_rounded)
              ].toRow().padding(horizontal: 16).gestures(onTap: _pickDate),
              SizedBox(height: 16),
              [
                Text('Customer Name: ',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                    )),
                SizedBox(width: 16),
                TextField(controller: _customerController).expanded()
              ].toRow().padding(horizontal: 16),
              SizedBox(height: 16),
              ..._items.asMap().entries.map((entry) {
                final index = entry.key;
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _descriptionControllers[index],
                        onChanged: (v) => _items[index] =
                            _items[index].copyWith(description: v),
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: _quantityControllers[index],
                        keyboardType: TextInputType.number,
                        onChanged: (v) => _items[index] = _items[index]
                            .copyWith(quantity: int.tryParse(v) ?? 1),
                        decoration: const InputDecoration(labelText: 'Qty'),
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: _amountControllers[index],
                        keyboardType: TextInputType.number,
                        onChanged: (v) => _items[index] = _items[index]
                            .copyWith(amount: double.tryParse(v) ?? 0),
                        decoration: const InputDecoration(labelText: 'Amount'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.delete).gestures(
                      onTap: () => _removeItem(index),
                    ),
                  ],
                )
                    .padding(horizontal: 16, bottom: 16, top: 8)
                    .decorated(
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 2),
                        borderRadius: BorderRadius.circular(4))
                    .padding(all: 8);
              }),
              ElevatedButton(
                  onPressed: _addItem,
                  child: const Text('Add New Item',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                      ))),
              const SizedBox(height: 20),
              [
                Text("Save & Preview",
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Times New Roman'))
                    .center()
                    .padding(all: 8)
                    .decorated(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16))
                    .padding(right: 16)
                    .ripple()
                    .gestures(onTap: _save)
                    .expanded(),
              ].toRow().padding(all: 16)
            ],
          ),
        ),
      ),
    );
  }
}
