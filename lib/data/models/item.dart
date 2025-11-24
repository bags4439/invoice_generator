import 'package:invoice_generator/domain/entities/item.dart';

class Item {
  final String description;
  final int quantity;
  final double amount;

  Item({required this.description, this.quantity = 1, required this.amount});

  double get lineTotal => quantity * amount;

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'quantity': quantity,
      'amount': amount,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      description: map['description'],
      quantity: map['quantity'] ?? 1,
      amount: (map['amount'] as num).toDouble(),
    );
  }

  factory Item.fromEntity(ItemEntity entity) {
    return Item(
      description: entity.description,
      quantity: entity.quantity,
      amount: entity.amount,
    );
  }

  ItemEntity toEntity() {
    return ItemEntity(
      description: description,
      quantity: quantity,
      amount: amount,
    );
  }
}