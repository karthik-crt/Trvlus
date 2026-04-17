CancelRequest cancelRequestFromJson(Map<String, dynamic> json) =>
    CancelRequest.fromJson(json);

class CancelRequest {
  CancelRequest({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  late final String statusCode;
  late final String statusMessage;
  late final List<Data> data;

  CancelRequest.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['statusMessage'] = statusMessage;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    this.customerName,
    this.customerEmail,
    this.customerMobile,
    this.verifiedByName,
    this.verifiedByCode,
    required this.verifystatus,
    required this.ticketstatus,
    required this.pnr,
    required this.bookingId,
    required this.description,
    required this.trvlusStatus,
    required this.appRef,
    required this.remarks,
    required this.verifiedBy,
    required this.createdAt,
    required this.updatedAt,
    this.statuslist,
  });

  late final int id;
  late final String? customerName;
  late final String? customerEmail;
  late final String? customerMobile;
  late final String? verifiedByName;
  late final String? verifiedByCode;
  late final String verifystatus;
  late final String ticketstatus;
  late final String pnr;
  late final String bookingId;
  late final String description;
  late final String trvlusStatus;
  late final String appRef;
  late final String remarks;
  late final int verifiedBy;
  late final String createdAt;
  late final String updatedAt;
  late final Null statuslist;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = null;
    customerEmail = null;
    customerMobile = null;
    verifiedByName = null;
    verifiedByCode = null;
    verifystatus = json['verifystatus'];
    ticketstatus = json['ticketstatus'];
    pnr = json['pnr'];
    bookingId = json['booking_id'];
    description = json['description'];
    trvlusStatus = json['trvlus_status'];
    appRef = json['app_ref'];
    remarks = json['remarks'];
    verifiedBy = json['verified_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    statuslist = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['customer_name'] = customerName;
    _data['customer_email'] = customerEmail;
    _data['customer_mobile'] = customerMobile;
    _data['verified_by_name'] = verifiedByName;
    _data['verified_by_code'] = verifiedByCode;
    _data['verifystatus'] = verifystatus;
    _data['ticketstatus'] = ticketstatus;
    _data['pnr'] = pnr;
    _data['booking_id'] = bookingId;
    _data['description'] = description;
    _data['trvlus_status'] = trvlusStatus;
    _data['app_ref'] = appRef;
    _data['remarks'] = remarks;
    _data['verified_by'] = verifiedBy;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['statuslist'] = statuslist;
    return _data;
  }
}
