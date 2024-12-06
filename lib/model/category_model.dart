class CategoryModel {
  List<FoodItem>? foodItems;

  CategoryModel({
    this.foodItems,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        foodItems: json["foodItems"] == null
            ? []
            : List<FoodItem>.from(
                json["foodItems"]!.map((x) => FoodItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foodItems": foodItems == null
            ? []
            : List<dynamic>.from(foodItems!.map((x) => x.toJson())),
      };
}

class FoodItem {
  String? id;
  String? itemName;
  String? categoryName;
  String? itemId;
  String? itemCode;
  int? prize;
  int? value;
  String? description;
  String? image;
  int? quantity;
  int? lowStock;
  String? status;
  String? category;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? expiryDate;

  FoodItem({
    this.id,
    this.itemName,
    this.categoryName,
    this.itemId,
    this.itemCode,
    this.prize,
    this.value,
    this.description,
    this.image,
    this.quantity,
    this.lowStock,
    this.status,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.expiryDate,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json["_id"],
        itemName: json["itemname"],
        categoryName: json["categoryName"],
        itemId: json["itemId"],
        itemCode: json["itemCode"],
        prize: json["prize"],
        value: json["value"],
        description: json["description"],
        image: json["image"],
        quantity: json["quantity"],
        lowStock: json["lowStock"],
        status: json["status"],
        category: json["category"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        expiryDate: json["expiryDate"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "itemname": itemName,
        "categoryName": categoryName,
        "itemId": itemId,
        "itemCode": itemCode,
        "prize": prize,
        "value": value,
        "description": description,
        "image": image,
        "quantity": quantity,
        "lowStock": lowStock,
        "status": status,
        "category": category,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "expiryDate": expiryDate,
      };
}
