import 'dart:convert';

List<MenuItemModel> menuItemModelFromJson(String str) =>
    List<MenuItemModel>.from(
        json.decode(str).map((x) => MenuItemModel.fromJson(x)));

String menuItemModelToJson(List<MenuItemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MenuItemModel {
  String? id;
  String? dayOfWeek;
  List<String>? breakfast;
  List<String>? lunch;
  List<String>? dinner;
  int? v;

  MenuItemModel({
    this.id,
    this.dayOfWeek,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.v,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) => MenuItemModel(
        id: json["_id"],
        dayOfWeek: json["dayOfWeek"],
        breakfast: json["breakfast"] == null
            ? []
            : List<String>.from(json["breakfast"]!.map((x) => x)),
        lunch: json["lunch"] == null
            ? []
            : List<String>.from(json["lunch"]!.map((x) => x)),
        dinner: json["dinner"] == null
            ? []
            : List<String>.from(json["dinner"]!.map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "dayOfWeek": dayOfWeek,
        "breakfast": breakfast == null
            ? []
            : List<dynamic>.from(breakfast!.map((x) => x)),
        "lunch": lunch == null ? [] : List<dynamic>.from(lunch!.map((x) => x)),
        "dinner":
            dinner == null ? [] : List<dynamic>.from(dinner!.map((x) => x)),
        "__v": v,
      };
}
