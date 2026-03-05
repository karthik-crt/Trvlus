Payment paymentStatusFromJson(Map<String, dynamic> json) =>
    Payment.fromJson(json);

class Payment {
  Payment({
    required this.statusCode,
    required this.data,
  });

  final String statusCode;
  final List<Data> data;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      statusCode: json['statusCode']?.toString() ?? "0",
      data: (json['data'] != null && json['data'] is List)
          ? (json['data'] as List).map((e) => Data.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Data {
  Data({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.fromRoleId,
    required this.toRoleId,
    required this.roleName,
    required this.type,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.toName,
    required this.fromName,
    required this.toLastname,
    required this.fromLastname,
  });

  final int id;
  final int fromUserId;
  final int toUserId;
  final int fromRoleId;
  final int toRoleId;
  final String roleName;
  final String type;
  final double amount;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String toName;
  final String fromName;
  final String toLastname;
  final String fromLastname;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? 0,
      fromUserId: json['from_user_id'] ?? 0,
      toUserId: json['to_user_id'] ?? 0,
      fromRoleId: json['from_role_id'] ?? 0,
      toRoleId: json['to_role_id'] ?? 0,
      roleName: json['role_name']?.toString() ?? "",
      type: json['type']?.toString() ?? "",
      amount: _parseAmount(json['amount']),
      status: json['status'] ?? 0,
      createdAt: json['created_at']?.toString() ?? "",
      updatedAt: json['updated_at']?.toString() ?? "",
      toName: json['to_name']?.toString() ?? "",
      fromName: json['from_name']?.toString() ?? "",
      toLastname: json['to_lastname']?.toString() ?? "",
      fromLastname: json['from_lastname']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'from_role_id': fromRoleId,
      'to_role_id': toRoleId,
      'role_name': roleName,
      'type': type,
      'amount': amount,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'to_name': toName,
      'from_name': fromName,
      'to_lastname': toLastname,
      'from_lastname': fromLastname,
    };
  }

  /// Safe amount parser (handles int, double, string, null)
  static double _parseAmount(dynamic value) {
    if (value == null) return 0.0;

    if (value is int) return value.toDouble();
    if (value is double) return value;

    return double.tryParse(value.toString()) ?? 0.0;
  }
}
