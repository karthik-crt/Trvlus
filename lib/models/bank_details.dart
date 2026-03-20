Bankdetails bankdetailsFromJson(Map<String, dynamic> json) =>
    Bankdetails.fromJson(json);

class Bankdetails {
  Bankdetails({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  late final String statusCode;
  late final String statusMessage;
  late final List<Data> data;

  Bankdetails.fromJson(Map<String, dynamic> json) {
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
    required this.bankName,
    required this.accNo,
    required this.ifscCode,
    required this.accHolderName,
    required this.branchName,
  });

  late final int id;
  late final int countryCode;
  late final String bankName;
  late final String accNo;
  late final String ifscCode;
  late final String accHolderName;
  late final String branchName;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryCode = json['country_code'];
    bankName = json['bank_name'];
    accNo = json['acc_no'];
    ifscCode = json['ifsc_code'];
    accHolderName = json['acc_holder_name'];
    branchName = json['branch_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['country_code'] = countryCode;
    _data['bank_name'] = bankName;
    _data['acc_no'] = accNo;
    _data['ifsc_code'] = ifscCode;
    _data['acc_holder_name'] = accHolderName;
    _data['branch_name'] = branchName;
    return _data;
  }
}
