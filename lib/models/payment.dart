Payment paymentStatusFromJson(Map<String, dynamic> json) =>
    Payment.fromJson(json);

class Payment {
  Payment({
    required this.statusCode,
    required this.data,
  });

  late final String statusCode;
  late final List<Data> data;

  Payment.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
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

  late final int id;
  late final int fromUserId;
  late final int toUserId;
  late final int fromRoleId;
  late final int toRoleId;
  late final String roleName;
  late final String type;
  late final double amount;
  late final int status;
  late final String createdAt;
  late final String updatedAt;
  late final String toName;
  late final String fromName;
  late final String toLastname;
  late final String fromLastname;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    fromRoleId = json['from_role_id'];
    toRoleId = json['to_role_id'];
    roleName = json['role_name'];
    type = json['type'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    toName = json['to_name'];
    fromName = json['from_name'];
    toLastname = json['to_lastname'];
    fromLastname = json['from_lastname'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['from_user_id'] = fromUserId;
    _data['to_user_id'] = toUserId;
    _data['from_role_id'] = fromRoleId;
    _data['to_role_id'] = toRoleId;
    _data['role_name'] = roleName;
    _data['type'] = type;
    _data['amount'] = amount;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['to_name'] = toName;
    _data['from_name'] = fromName;
    _data['to_lastname'] = toLastname;
    _data['from_lastname'] = fromLastname;
    return _data;
  }
}
