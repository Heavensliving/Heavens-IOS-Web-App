class SearchModel {
  String id;
  String itemName;
  String categoryName;
  String itemId;
  String itemCode;
  int prize;
  double value;
  String description;
  String image;
  int quantity;
  int lowStock;
  String status;
  String category;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String expiryDate;

  SearchModel({
    required this.id,
    required this.itemName,
    required this.categoryName,
    required this.itemId,
    required this.itemCode,
    required this.prize,
    required this.value,
    required this.description,
    required this.image,
    required this.quantity,
    required this.lowStock,
    required this.status,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.expiryDate,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      id: json['_id'],
      itemName: json['itemname'],
      categoryName: json['categoryName'],
      itemId: json['itemId'],
      itemCode: json['itemCode'],
      prize: json['prize'],
      value: (json['value'] as num).toDouble(),
      description: json['description'],
      image: json['image'],
      quantity: json['quantity'],
      lowStock: json['lowStock'],
      status: json['status'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
      expiryDate: json['expiryDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'itemname': itemName,
      'categoryName': categoryName,
      'itemId': itemId,
      'itemCode': itemCode,
      'prize': prize,
      'value': value,
      'description': description,
      'image': image,
      'quantity': quantity,
      'lowStock': lowStock,
      'status': status,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'expiryDate': expiryDate,
    };
  }
}
