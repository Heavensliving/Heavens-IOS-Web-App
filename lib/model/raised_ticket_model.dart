class RaisedTicketModel {
  String? id;
  String? name;
  String? issue;
  String? ticketId;
  String? description;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  DateTime? assignedAt;
  String? assignedTo;
  String? timeneeded;
  DateTime? resolutionDate;

  RaisedTicketModel({
    this.id,
    this.name,
    this.issue,
    this.ticketId,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.assignedAt,
    this.assignedTo,
    this.timeneeded,
    this.resolutionDate,
  });

  factory RaisedTicketModel.fromJson(Map<String, dynamic> json) =>
      RaisedTicketModel(
        id: json["_id"],
        name: json["Name"],
        issue: json["issue"],
        ticketId: json["ticketId"],
        description: json["description"],
        status: json["Status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        assignedAt: json["AssignedAt"] == null
            ? null
            : DateTime.parse(json["AssignedAt"]),
        assignedTo: json["AssignedTo"],
        timeneeded: json["Timeneeded"],
        resolutionDate: json["ResolutionDate"] == null
            ? null
            : DateTime.parse(json["ResolutionDate"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "Name": name,
        "issue": issue,
        "ticketId": ticketId,
        "description": description,
        "Status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "AssignedAt": assignedAt?.toIso8601String(),
        "AssignedTo": assignedTo,
        "Timeneeded": timeneeded,
        "ResolutionDate": resolutionDate?.toIso8601String(),
      };
}
