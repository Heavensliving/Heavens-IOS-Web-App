import 'dart:convert';

List<AddOnModel> addOnModelFromJson(String str) =>
    List<AddOnModel>.from(json.decode(str).map((x) => AddOnModel.fromJson(x)));

String addOnModelToJson(List<AddOnModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddOnModel {
  String? id;
  String? itemname;
  int? prize;
  String? description;
  String? image;
  String? status;
  int? v;
  AddOnModel({
    this.id,
    this.itemname,
    this.prize,
    this.description,
    this.image,
    this.status,
    this.v,
  });

  factory AddOnModel.fromJson(Map<String, dynamic> json) => AddOnModel(
        id: json["_id"],
        itemname: json["Itemname"],
        prize: json["prize"],
        description: json["Description"],
        image: json["image"],
        status: json["status"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "Itemname": itemname,
        "prize": prize,
        "Description": description,
        "image": image,
        "status": status,
        "__v": v,
      };
}
