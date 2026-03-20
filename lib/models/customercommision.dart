Customercommission customerCommissionFromJson(Map<String, dynamic> json) =>
    Customercommission.fromJson(json);

class Customercommission {
  Customercommission({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  late final String statusCode;
  late final String statusMessage;
  late final List<Data> data;

  Customercommission.fromJson(Map<String, dynamic> json) {
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
    required this.commission_0,
    required this.commission_0_10,
    required this.commission_10_20,
    required this.commission_20_30,
    required this.commission_30_50,
    required this.commission_50_100,
    required this.commission_100_150,
    required this.commission_150_200,
    required this.commission_200_250,
    required this.commission_250_300,
    required this.commission_above_300,
    required this.countryCode,
  });

  late final int id;
  late final double commission_0;
  late final double commission_0_10;
  late final double commission_10_20;
  late final double commission_20_30;
  late final double commission_30_50;
  late final double commission_50_100;
  late final double commission_100_150;
  late final double commission_150_200;
  late final double commission_200_250;
  late final double commission_250_300;
  late final double commission_above_300;
  late final int countryCode;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commission_0 = json['commission_0'];
    commission_0_10 = json['commission_0_10'];
    commission_10_20 = json['commission_10_20'];
    commission_20_30 = json['commission_20_30'];
    commission_30_50 = json['commission_30_50'];
    commission_50_100 = json['commission_50_100'];
    commission_100_150 = json['commission_100_150'];
    commission_150_200 = json['commission_150_200'];
    commission_200_250 = json['commission_200_250'];
    commission_250_300 = json['commission_250_300'];
    commission_above_300 = json['commission_above_300'];
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['commission_0'] = commission_0;
    _data['commission_0_10'] = commission_0_10;
    _data['commission_10_20'] = commission_10_20;
    _data['commission_20_30'] = commission_20_30;
    _data['commission_30_50'] = commission_30_50;
    _data['commission_50_100'] = commission_50_100;
    _data['commission_100_150'] = commission_100_150;
    _data['commission_150_200'] = commission_150_200;
    _data['commission_200_250'] = commission_200_250;
    _data['commission_250_300'] = commission_250_300;
    _data['commission_above_300'] = commission_above_300;
    _data['country_code'] = countryCode;
    return _data;
  }
}
