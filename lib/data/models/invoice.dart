import 'package:invoice_generator/data/models/item.dart';
import 'package:invoice_generator/domain/entities/invoice.dart';

enum InvoiceType { invoice, receipt }

class Invoice {
  final String id;
  final InvoiceType type;
  final DateTime date;
  final String customerName;
  final String number;
  final List<Item> items;
  final double total;
  final double? discount;
  final String? headerImageUrl;
  final String? footerImageUrl;

  Invoice({
    required this.id,
    required this.type,
    required this.date,
    required this.customerName,
    required this.number,
    required this.items,
    required this.total,
    this.discount,
    this.headerImageUrl,
    this.footerImageUrl,
  });

  /// Convert InvoiceModel -> Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'date': date.toIso8601String(),
      'customerName': customerName,
      'number': number,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'discount': discount,
      'headerImageUrl': headerImageUrl,
      'footerImageUrl': footerImageUrl,
    };
  }

  /// Convert Map -> InvoiceModel
  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      type: InvoiceType.values.firstWhere((e) => e.name == map['type']),
      date: DateTime.parse(map['date']),
      customerName: map['customerName'],
      number: map['number'],
      items: (map['items'] as List)
          .map((item) => Item.fromMap(item as Map<String, dynamic>))
          .toList(),
      total: (map['total'] as num).toDouble(),
      discount: map['discount'] != null ? (map['discount'] as num).toDouble() : null,
      headerImageUrl: map['headerImageUrl'],
      footerImageUrl: map['footerImageUrl'],
    );
  }

  /// Convert Domain Entity -> Data Model
  factory Invoice.fromEntity(InvoiceEntity entity) {
    return Invoice(
      id: entity.id,
      type: InvoiceType.values[entity.type.index],
      date: entity.date,
      customerName: entity.customerName,
      number: entity.number,
      items: entity.items.map((e) => Item.fromEntity(e)).toList(),
      total: entity.total,
      discount: entity.discount,
      headerImageUrl: entity.headerImageUrl,
      footerImageUrl: entity.footerImageUrl,
    );
  }

  /// Convert Data Model -> Domain Entity
  InvoiceEntity toEntity() {
    return InvoiceEntity(
      id: id,
      type: InvoiceEntityType.values[type.index],
      date: date,
      customerName: customerName,
      number: number,
      items: items.map((e) => e.toEntity()).toList(),
      discount: discount,
      headerImageUrl: headerImageUrl,
      footerImageUrl: footerImageUrl,
    );
  }
}