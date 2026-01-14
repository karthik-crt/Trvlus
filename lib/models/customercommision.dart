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
    statusCode = json['statusCode'] ?? "";
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
  int? id;
  double? commission_0_50;
  double? commission_50_100;
  double? commission_100_150;
  double? commission_150_200;
  double? commission_200_250;
  double? commission_250_300;
  double? commission_above_300;
  int? country_code;

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        commission_0_50 = (json['commission_0_50'] as num?)?.toDouble(),
        commission_50_100 = (json['commission_50_100'] as num?)?.toDouble(),
        commission_100_150 = (json['commission_100_150'] as num?)?.toDouble(),
        commission_150_200 = (json['commission_150_200'] as num?)?.toDouble(),
        commission_200_250 = (json['commission_200_250'] as num?)?.toDouble(),
        commission_250_300 = (json['commission_250_300'] as num?)?.toDouble(),
        commission_above_300 =
            (json['commission_above_300'] as num?)?.toDouble(),
        country_code = json['country_code'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'commission_0_50': commission_0_50,
        'commission_50_100': commission_50_100,
        'commission_100_150': commission_100_150,
        'commission_150_200': commission_150_200,
        'commission_200_250': commission_200_250,
        'commission_250_300': commission_250_300,
        'commission_above_300': commission_above_300,
        'country_code': country_code,
      };
}
