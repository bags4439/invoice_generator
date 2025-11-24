class ItemEntity {
  final String description;
  final int quantity;
  final double amount;

  ItemEntity({required this.description, this.quantity = 1, required this.amount});

  double get lineTotal => quantity * amount;

  @override
  String toString() {
    return 'ItemEntity('
        'description: $description, '
        'quantity: $quantity, '
        'amount: $amount, '
        'lineTotal: $lineTotal'
        ')';
  }

  ItemEntity copyWith({
    String? description,
    int? quantity,
    double? amount,
  }) {
    return ItemEntity(
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
    );
  }
}