import 'dart:convert';

class FeesModel {
  String id;
  String studentId;
  double? totalAmountToPay;
  double amountPaid;
  double pendingBalance;
  double advanceBalance;
  String paymentClearedMonthYear;
  DateTime paymentDate;
  String? waveOff;
  String? paymentMode;
  String waveOffReason;
  String transactionId;
  String student;
  DateTime createdAt;
  DateTime updatedAt;

  FeesModel({
    required this.id,
    required this.studentId,
    this.totalAmountToPay,
    required this.amountPaid,
    required this.pendingBalance,
    required this.advanceBalance,
    required this.paymentClearedMonthYear,
    required this.paymentDate,
    this.waveOff,
    required this.paymentMode,
    required this.waveOffReason,
    required this.transactionId,
    required this.student,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a PaymentHistoryModel from JSON
  factory FeesModel.fromJson(Map<String, dynamic> json) {
    return FeesModel(
      id: json["_id"],
      studentId: json["studentId"],
      totalAmountToPay: json["totalAmountToPay"]?.toDouble(),
      amountPaid: json["amountPaid"].toDouble(),
      pendingBalance: json["pendingBalance"].toDouble(),
      advanceBalance: json["advanceBalance"].toDouble(),
      paymentClearedMonthYear: json["paymentClearedMonthYear"],
      paymentDate: DateTime.parse(json["paymentDate"]),
      waveOff: json["waveOff"],
      paymentMode: json["paymentMode"],
      waveOffReason: json["waveOffReason"],
      transactionId: json["transactionId"],
      student: json["student"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  // Method to convert a PaymentHistoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "studentId": studentId,
      "totalAmountToPay": totalAmountToPay,
      "amountPaid": amountPaid,
      "pendingBalance": pendingBalance,
      "advanceBalance": advanceBalance,
      "paymentClearedMonthYear": paymentClearedMonthYear,
      "paymentDate": paymentDate.toIso8601String(),
      "waveOff": waveOff,
      "paymentMode": paymentMode,
      "waveOffReason": waveOffReason,
      "transactionId": transactionId,
      "student": student,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

// Function to parse JSON string to List of PaymentHistoryModel
List<FeesModel> paymentHistoryModelFromJson(String str) {
  final List<dynamic> jsonData = json.decode(str);
  return List<FeesModel>.from(jsonData.map((data) => FeesModel.fromJson(data)));
}

// Function to convert List of PaymentHistoryModel to JSON string
String paymentHistoryModelToJson(List<FeesModel> data) {
  final List<Map<String, dynamic>> jsonData =
      data.map((model) => model.toJson()).toList();
  return json.encode(jsonData);
}
