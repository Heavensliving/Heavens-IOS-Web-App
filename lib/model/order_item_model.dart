class Item {
  final String itemName;
  final int quantity;
  final double rate;
  final double total;

  Item({
    required this.itemName,
    required this.quantity,
    required this.rate,
    required this.total,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['itemName'],
      quantity: json['quantity'],
      rate: json['rate'],
      total: json['total'],
    );
  }
}
