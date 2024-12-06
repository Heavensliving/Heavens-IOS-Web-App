class CategoryNameListModel {
  String id;
  String name;
  List<String> items;
  DateTime createdAt;
  DateTime updatedAt;
  int version;

  CategoryNameListModel({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory CategoryNameListModel.fromJson(Map<String, dynamic> json) {
    return CategoryNameListModel(
      id: json['_id'],
      name: json['name'],
      items: List<String>.from(json['items']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'items': items,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }
}
