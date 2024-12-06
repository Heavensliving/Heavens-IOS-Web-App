class StudentDetailModel {
  final Student? student;

  StudentDetailModel({this.student});

  factory StudentDetailModel.fromJson(Map<String, dynamic> json) {
    return StudentDetailModel(
      student: json["result"] == null ? null : Student.fromJson(json["result"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "result": student?.toJson(),
    };
  }

  @override
  String toString() {
    return 'StudentDetailModel(student: $student)';
  }
}

class Student {
  final String? id;
  final String? name;
  final String? address;
  final String? contactNo;
  final String? email;
  final String? bloodGroup;
  final String? parentName;
  final String? parentNumber;
  final String? course;
  final int? advanceFee;
  final int? nonRefundableDeposit;
  final int? monthlyRent;
  final String? adharFrontImage;
  final String? adharBackImage;
  final String? photo;
  final String? roomType;
  final String? roomNo;
  final String? referredBy;
  final String? typeOfStay;
  final String? paymentStatus;
  final String? pgName;
  final String? studentId;
  final bool? isBlocked;
  final String? joinDate;
  final String? dateOfBirth; // Ensure this is DateTime
  final String? currentStatus; // Added field
  final String? password; // Added field
  final String? gender; // Added field
  final String? year; // Added field
  final String? collegeName; // Added field
  final String? parentOccupation; // Added field
  final String? workingPlace; // Added field
  final String? branch; // Added field
  final String? phase; // Added field
  final String? profileCompletionPercentage;
  final List<dynamic>? maintenance; // Adjust based on expected data type
  final List<dynamic>? messOrders; // Adjust based on expected data type
  final String? propertyId; // Changed from 'property' to 'propertyId'
  final DateTime? createdAt; // Added field
  final DateTime? updatedAt; // Added field
  // __v field renamed for clarity
  final List<String>? payments; // Adjusted for payments
  final int? version;
  final int? warningStatus;

  Student({
    this.id,
    this.name,
    this.address,
    this.contactNo,
    this.email,
    this.bloodGroup,
    this.parentName,
    this.parentNumber,
    this.course,
    this.advanceFee,
    this.nonRefundableDeposit,
    this.monthlyRent,
    this.adharFrontImage,
    this.adharBackImage,
    this.photo,
    this.roomType,
    this.roomNo,
    this.referredBy,
    this.typeOfStay,
    this.paymentStatus,
    this.pgName,
    this.studentId,
    this.isBlocked,
    this.joinDate,
    this.dateOfBirth,
    this.currentStatus,
    this.password,
    this.gender,
    this.year,
    this.collegeName,
    this.parentOccupation,
    this.workingPlace,
    this.branch,
    this.phase,
    this.profileCompletionPercentage,
    this.maintenance,
    this.messOrders,
    this.propertyId,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.payments,
    this.warningStatus,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json["_id"],
      name: json["name"],
      address: json["address"],
      contactNo: json["contactNo"],
      email: json["email"],
      bloodGroup: json["bloodGroup"],
      parentName: json["parentName"],
      parentNumber: json["parentNumber"],
      course: json["course"],
      advanceFee: json["advanceFee"],
      nonRefundableDeposit: json["nonRefundableDeposit"],
      monthlyRent: json["monthlyRent"],
      adharFrontImage: json["adharFrontImage"],
      adharBackImage: json["adharBackImage"],
      photo: json["photo"],
      roomType: json["roomType"],
      roomNo: json["roomNo"],
      referredBy: json["referredBy"],
      typeOfStay: json["typeOfStay"],
      paymentStatus: json["paymentStatus"],
      pgName: json["pgName"],
      studentId: json["studentId"],
      isBlocked: json["isBlocked"],
      joinDate: json["joinDate"],
      dateOfBirth: json["dateOfBirth"],
      currentStatus: json['currentStatus'],
      password: json['password'],
      gender: json['gender'],
      year: json['year'],
      collegeName: json['collegeName'],
      parentOccupation: json['parentOccupation'],
      workingPlace: json['workingPlace'],
      branch: json['branch'],
      phase: json['phase'],
      profileCompletionPercentage: json['profileCompletionPercentage'],
      maintenance:
          (json['maintenance'] as List<dynamic>?)?.map((item) => item).toList(),
      messOrders:
          (json['messOrders'] as List<dynamic>?)?.map((item) => item).toList(),
      propertyId: json['property'], // Changed from 'property' to 'propertyId'
      createdAt:
          json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
      version: json['__v'], // Changed from '__v' to 'version'
      payments: (json['payments'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
      warningStatus: json['warningStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "address": address,
      "contactNo": contactNo,
      "email": email,
      "bloodGroup": bloodGroup,
      "parentName": parentName,
      "parentNumber": parentNumber,
      "course": course,
      "advanceFee": advanceFee,
      "nonRefundableDeposit": nonRefundableDeposit,
      "monthlyRent": monthlyRent,
      "adharFrontImage": adharFrontImage,
      "adharBackImage": adharBackImage,
      "photo": photo,
      "roomType": roomType,
      "roomNo": roomNo,
      "referredBy": referredBy,
      "typeOfStay": typeOfStay,
      "paymentStatus": paymentStatus,
      "pgName": pgName,
      "studentId": studentId,
      "isBlocked": isBlocked,
      "joinDate": joinDate,
      "dateOfBirth": dateOfBirth,
      'currentStatus': currentStatus,
      'password': password,
      'gender': gender,
      'year': year,
      'collegeName': collegeName,
      'parentOccupation': parentOccupation,
      'workingPlace': workingPlace,
      'branch': branch,
      'phase': phase,
      'profileCompletionPercentage': profileCompletionPercentage,
      'maintenance': maintenance,
      'messOrders': messOrders,
      'property': propertyId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
      'payments': payments,
      'warningStatus': warningStatus,
    };
  }

  @override
  String toString() {
    return 'Student(id: $id, name: $name,profileCompletionPercentage:$profileCompletionPercentage)';
  }
}
