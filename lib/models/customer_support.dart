Customersupport customersupportFromJson(Map<String, dynamic> json) =>
    Customersupport.fromJson(json);

class Customersupport {
  Customersupport({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  late final String statusCode;
  late final String statusMessage;
  late final List<Data> data;

  Customersupport.fromJson(Map<String, dynamic> json) {
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
    required this.countryCode,
    required this.salesMail,
    required this.supportMail,
    required this.number,
    required this.mobile,
    required this.customerAccountSupport,
    required this.customerMobile,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  late final int id;
  late final int countryCode;
  late final String salesMail;
  late final String supportMail;
  late final String number;
  late final String mobile;
  late final String customerAccountSupport;
  late final String customerMobile;
  late final int status;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryCode = json['country_code'];
    salesMail = json['sales_mail'];
    supportMail = json['support_mail'];
    number = json['number'];
    mobile = json['mobile'];
    customerAccountSupport = json['customer_account_support'];
    customerMobile = json['customer_mobile'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['country_code'] = countryCode;
    _data['sales_mail'] = salesMail;
    _data['support_mail'] = supportMail;
    _data['number'] = number;
    _data['mobile'] = mobile;
    _data['customer_account_support'] = customerAccountSupport;
    _data['customer_mobile'] = customerMobile;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
