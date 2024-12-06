import 'dart:convert';

MessOrderModel messOrderModelFromJson(String str) =>
    MessOrderModel.fromJson(json.decode(str));

String messOrderModelToJson(MessOrderModel data) => json.encode(data.toJson());

class MessOrderModel {
  List<StudentOrder>? studentOrders;

  MessOrderModel({
    this.studentOrders,
  });

  factory MessOrderModel.fromJson(Map<String, dynamic> json) => MessOrderModel(
        studentOrders: json["studentOrders"] == null
            ? []
            : List<StudentOrder>.from(
                json["studentOrders"]!.map((x) => StudentOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "studentOrders": studentOrders == null
            ? []
            : List<dynamic>.from(studentOrders!.map((x) => x.toJson())),
      };
}

class StudentOrder {
  String? id;
  String? name;
  String? orderId;
  String? roomNo;
  String? contact;
  String? mealType;
  String? status;
  String? bookingStatus;
  DateTime? deliverDate;
  List<AdOn>? adOns;
  String? student;
  String? property;
  DateTime? bookingDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  StudentOrder({
    this.id,
    this.name,
    this.orderId,
    this.roomNo,
    this.contact,
    this.mealType,
    this.status,
    this.bookingStatus,
    this.deliverDate,
    this.adOns,
    this.student,
    this.property,
    this.bookingDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory StudentOrder.fromJson(Map<String, dynamic> json) => StudentOrder(
        id: json["_id"],
        name: json["name"],
        orderId: json["orderId"],
        roomNo: json["roomNo"],
        contact: json["contact"],
        mealType: json["mealType"],
        status: json["status"],
        bookingStatus: json["bookingStatus"],
        deliverDate: json["deliverDate"] == null
            ? null
            : DateTime.parse(json["deliverDate"]),
        adOns: json["adOns"] == null
            ? []
            : List<AdOn>.from(json["adOns"]!.map((x) => AdOn.fromJson(x))),
        student: json["student"],
        property: json["property"],
        bookingDate: json["bookingDate"] == null
            ? null
            : DateTime.parse(json["bookingDate"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "orderId": orderId,
        "roomNo": roomNo,
        "contact": contact,
        "mealType": mealType,
        "status": status,
        "bookingStatus": bookingStatus,
        "deliverDate": deliverDate?.toIso8601String(),
        "adOns": adOns == null
            ? []
            : List<dynamic>.from(adOns!.map((x) => x.toJson())),
        "student": student,
        "property": property,
        "bookingDate": bookingDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class AdOn {
  String? name;
  int? quantity;
  int? prize;

  AdOn({this.name, this.quantity, this.prize});

  factory AdOn.fromJson(Map<String, dynamic> json) => AdOn(
        name: json["name"],
        quantity: json["quantity"],
        prize: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "pricee": prize,
      };
}
