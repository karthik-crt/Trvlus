Countrycode countrycodeFromJson(Map<String, dynamic> json) =>
    Countrycode.fromJson(json);

class Countrycode {
  Countrycode({
    required this.statusCode,
    required this.data,
  });

  late final String statusCode;
  late final List<Data> data;

  Countrycode.fromJson(Map<String, dynamic> json) {
    statusCode:
    json["statusCode"].toString(); // ✅ FIX
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
    required this.countryName,
    required this.countryCode,
    required this.convenienceFee,
    required this.customerCountryAmt,
    required this.countryAmt,
    required this.mealsAmt,
    required this.seatAmt,
    required this.baggageAmt,
    required this.commissionAmt,
    required this.currencyCode,
    required this.currencySymbol,
    required this.serviceTax,
    required this.taxName,
    required this.status,
    required this.statusName,
    required this.createdAt,
    required this.updatedAt,
  });

  late final int id;
  late final String countryName;
  late final String countryCode;
  late final double convenienceFee;
  late final double customerCountryAmt;
  late final double countryAmt;
  late final double mealsAmt;
  late final double seatAmt;
  late final double baggageAmt;
  late final double commissionAmt;
  late final String currencyCode;
  late final String currencySymbol;
  late final double serviceTax;
  late final String taxName;
  late final int status;
  late final String statusName;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['country_name'] ?? "";
    countryCode = json['country_code'] ?? "";
    convenienceFee = json['convenience_fee'];
    customerCountryAmt = json['customer_country_amt'];
    countryAmt = json['country_amt'];
    mealsAmt = json['meals_amt'];
    seatAmt = json['seat_amt'];
    baggageAmt = json['baggage_amt'];
    commissionAmt = json['commission_amt'];
    currencyCode = json['currency_code'] ?? "";
    currencySymbol = json['currency_symbol'];
    serviceTax = json['service_tax'];
    taxName = json['tax_name'];
    status = json['status'];
    statusName = json['status_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['country_name'] = countryName;
    _data['country_code'] = countryCode;
    _data['convenience_fee'] = convenienceFee;
    _data['customer_country_amt'] = customerCountryAmt;
    _data['country_amt'] = countryAmt;
    _data['meals_amt'] = mealsAmt;
    _data['seat_amt'] = seatAmt;
    _data['baggage_amt'] = baggageAmt;
    _data['commission_amt'] = commissionAmt;
    _data['currency_code'] = currencyCode;
    _data['currency_symbol'] = currencySymbol;
    _data['service_tax'] = serviceTax;
    _data['tax_name'] = taxName;
    _data['status'] = status;
    _data['status_name'] = statusName;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
