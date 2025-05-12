import 'dart:convert';

class FeesModel {
  String id;
  String studentId;
  String name;
  double? monthlyRent;
  double? totalAmountToPay;
  double amountPaid;
  double pendingBalance;
  double advanceBalance;
  List<String>? fullyClearedRentMonths;
  String? rentMonth;
  String? paymentClearedMonthYear;
  DateTime paymentDate;
  int? waveOff;
  String? paymentMode;
  String waveOffReason;
  String transactionId;
  String? remarks;
  String? collectedBy;
  String? property;
  dynamic student;
  DateTime createdAt;
  DateTime updatedAt;
  int? v;

  FeesModel({
    required this.id,
    required this.studentId,
    required this.name,
    this.monthlyRent,
    this.totalAmountToPay,
    required this.amountPaid,
    required this.pendingBalance,
    required this.advanceBalance,
    this.fullyClearedRentMonths,
    this.rentMonth,
    this.paymentClearedMonthYear,
    required this.paymentDate,
    this.waveOff,
    required this.paymentMode,
    required this.waveOffReason,
    required this.transactionId,
    this.remarks,
    this.collectedBy,
    this.property,
    required this.student,
    required this.createdAt,
    required this.updatedAt,
    this.v,
  });

  factory FeesModel.fromJson(Map<String, dynamic> json) {
    return FeesModel(
      id: json["_id"] ?? '',
      studentId: json["studentId"] ?? '',
      name: json["name"] ?? '',
      monthlyRent: json["monthlyRent"]?.toDouble(),
      totalAmountToPay: json["totalAmountToPay"]?.toDouble(),
      amountPaid: json["amountPaid"]?.toDouble() ?? 0.0,
      pendingBalance: json["pendingBalance"]?.toDouble() ?? 0.0,
      advanceBalance: json["advanceBalance"]?.toDouble() ?? 0.0,
      fullyClearedRentMonths: json["fullyClearedRentMonths"] != null
          ? List<String>.from(json["fullyClearedRentMonths"])
          : null,
      rentMonth: json["rentMonth"],
      paymentClearedMonthYear: json["paymentClearedMonthYear"],
      paymentDate: DateTime.parse(json["paymentDate"]),
      waveOff: json["waveOff"],
      paymentMode: json["paymentMode"] ?? '',
      waveOffReason: json["waveOffReason"] ?? '',
      transactionId: json["transactionId"] ?? '',
      remarks: json["remarks"],
      collectedBy: json["collectedBy"],
      property: json["property"],
      student: json["student"], // Can be String or Map
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "studentId": studentId,
      "name": name,
      "monthlyRent": monthlyRent,
      "totalAmountToPay": totalAmountToPay,
      "amountPaid": amountPaid,
      "pendingBalance": pendingBalance,
      "advanceBalance": advanceBalance,
      "fullyClearedRentMonths": fullyClearedRentMonths,
      "rentMonth": rentMonth,
      "paymentClearedMonthYear": paymentClearedMonthYear,
      "paymentDate": paymentDate.toIso8601String(),
      "waveOff": waveOff,
      "paymentMode": paymentMode,
      "waveOffReason": waveOffReason,
      "transactionId": transactionId,
      "remarks": remarks,
      "collectedBy": collectedBy,
      "property": property,
      "student": student,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "__v": v,
    };
  }
}

List<FeesModel> feesModelFromJson(String str) {
  final jsonData = json.decode(str);
  if (jsonData is List) {
    return List<FeesModel>.from(jsonData.map((x) => FeesModel.fromJson(x)));
  } else {
    return [FeesModel.fromJson(jsonData)];
  }
}

String feesModelToJson(List<FeesModel> data) {
  final list = data.map((x) => x.toJson()).toList();
  return json.encode(list);
}
