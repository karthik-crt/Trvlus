Getprofile getprofileFromJson(Map<String, dynamic> json) =>
    Getprofile.fromJson(json);

class Getprofile {
  Getprofile({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  late final String statusCode;
  late final String statusMessage;
  late final Data data;

  Getprofile.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['statusMessage'] = statusMessage;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gstNumber,
    required this.mobile,
    required this.userImages,
    this.dateofbirth,
  });

  late final String firstName;
  late final String lastName;
  late final String email;
  late final String gstNumber;
  late final String mobile;
  late final String userImages;
  late final Null dateofbirth;

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    email = json['email'] ?? "";
    gstNumber = json['gst_number'] ?? "";
    mobile = json['mobile'] ?? "";
    userImages = json['user_images'] ?? "";
    dateofbirth = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['email'] = email;
    _data['gst_number'] = gstNumber;
    _data['mobile'] = mobile;
    _data['user_images'] = userImages;
    _data['dateofbirth'] = dateofbirth;
    return _data;
  }
}
