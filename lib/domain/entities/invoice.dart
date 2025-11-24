import 'package:invoice_generator/domain/entities/item.dart';

enum InvoiceEntityType { invoice, receipt }

class InvoiceEntity {
  final String id;
  final InvoiceEntityType type;
  final DateTime date;
  final String customerName;
  final String number;
  final List<ItemEntity> items;
  final double? discount;
  final String? headerImageUrl;
  final String? footerImageUrl;

  InvoiceEntity({
    required this.id,
    required this.type,
    required this.date,
    required this.customerName,
    required this.number,
    required this.items,
    this.discount,
    this.headerImageUrl,
    this.footerImageUrl,
  });

  double get total =>
      items.fold(0.0, (sum, item) => sum + (item.amount * item.quantity));

  @override
  String toString() {
    return 'InvoiceEntity('
        'id: $id, '
        'type: $type, '
        'date: $date, '
        'customerName: $customerName, '
        'number: $number, '
        'items: $items, '
        'discount: $discount, '
        'headerImageUrl: $headerImageUrl, '
        'footerImageUrl: $footerImageUrl, '
        'total: $total'
        ')';
  }

  InvoiceEntity copyWith({
    String? id,
    InvoiceEntityType? type,
    DateTime? date,
    String? customerName,
    String? number,
    List<ItemEntity>? items,
    double? discount,
    String? headerImageUrl,
    String? footerImageUrl,
  }) {
    return InvoiceEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      customerName: customerName ?? this.customerName,
      number: number ?? this.number,
      items: items ?? this.items,
      discount: discount ?? this.discount,
      headerImageUrl: headerImageUrl ?? this.headerImageUrl,
      footerImageUrl: footerImageUrl ?? this.footerImageUrl,
    );
  }
}
