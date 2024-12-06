// To parse this JSON data, do
//
//     final orderHistoryModel = orderHistoryModelFromJson(jsonString);

import 'dart:convert';

OrderHistoryModel orderHistoryModelFromJson(String str) =>
    OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) =>
    json.encode(data.toJson());

class OrderHistoryModel {
  List<CafeOrder>? cafeOrders;

  OrderHistoryModel({
    this.cafeOrders,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderHistoryModel(
        cafeOrders: json["cafeOrders"] == null
            ? []
            : List<CafeOrder>.from(
                json["cafeOrders"]!.map((x) => CafeOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cafeOrders": cafeOrders == null
            ? []
            : List<dynamic>.from(cafeOrders!.map((x) => x.toJson())),
      };
}

class CafeOrder {
  String? id;
  String? orderId;
  List<Item>? items;
  int? total;
  String? paymentMethod;
  String? status;
  DateTime? date;

  CafeOrder({
    this.id,
    this.orderId,
    this.items,
    this.total,
    this.paymentMethod,
    this.status,
    this.date,
  });

  factory CafeOrder.fromJson(Map<String, dynamic> json) => CafeOrder(
        id: json["_id"],
        orderId: json["orderId"],
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        total: json["total"],
        paymentMethod: json["paymentMethod"],
        status: json["status"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "orderId": orderId,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "total": total,
        "paymentMethod": paymentMethod,
        "status": status,
        "date": date?.toIso8601String(),
      };
}

class Item {
  String? itemName;
  int? quantity;
  int? rate;
  int? total;

  Item({
    this.itemName,
    this.quantity,
    this.rate,
    this.total,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemName: json["itemName"],
        quantity: json["quantity"],
        rate: json["rate"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
        "quantity": quantity,
        "rate": rate,
        "total": total,
      };
}
