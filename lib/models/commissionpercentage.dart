ComissionPercentage comissionPercentageFromJson(Map<String, dynamic> json) =>
    ComissionPercentage.fromJson(json);

class ComissionPercentage {
  ComissionPercentage({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  late final String statusCode;
  late final String statusMessage;
  late final List<Data> data;

  ComissionPercentage.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'] ?? "";
    statusMessage = json['statusMessage'] ?? "";
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
    required this.percentage,
    required this.countryCode,
    required this.commissionforlcc,
    required this.commissionforgds,
    required this.commissionfortds,
  });

  late final int id;
  late final int percentage;
  late final int countryCode;
  late final int commissionforlcc;
  late final int commissionforgds;
  late final int commissionfortds;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    percentage = (json['percentage'] as num).toInt();
    countryCode = json['country_code'];
    commissionforlcc = (json['commissionforlcc'] as num).toInt();
    commissionforgds = (json['commissionforgds'] as num).toInt();
    commissionfortds = (json['commissionfortds'] as num).toInt();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['percentage'] = percentage;
    _data['country_code'] = countryCode;
    _data['commissionforlcc'] = commissionforlcc;
    _data['commissionforgds'] = commissionforgds;
    _data['commissionfortds'] = commissionfortds;
    return _data;
  }
}
