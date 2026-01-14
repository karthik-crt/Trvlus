Selecttraveler selecttravelerdetailFromJson(Map<String, dynamic> json) =>
    Selecttraveler.fromJson(json);

class Selecttraveler {
  Selecttraveler({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  late final String statusCode;
  late final String statusMessage;
  late final List<PassengerDetails> data;

  Selecttraveler.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    data = List.from(json['data'] ?? {})
        .map((e) => PassengerDetails.fromJson(e))
        .toList();
  }
}

class PassengerDetails {
  PassengerDetails({
    required this.id,
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.passportNo,
    required this.paxType,
    required this.title,
    required this.passportExpiry,
    required this.dob,
    required this.gender,
    required this.mobile,
    required this.email,
  });

  late final int id;
  late final int user;
  late final String firstName;
  late final String lastName;
  late final String passportNo;
  late final String paxType;
  late final String title;
  late final String? passportExpiry;
  late final String dob;
  late final String gender;
  late final String mobile;
  late final String email;

  PassengerDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    user = json['user'] ?? 0;
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    passportNo = json['passport_no'] ?? "";
    paxType = json['pax_type'] ?? "";
    title = json['title'] ?? "";
    passportExpiry = json['passport_expiry'] ?? "";
    dob = json['dob'] ?? "";
    gender = json['gender'] ?? "";
    mobile = json['mobile'] ?? "";
    email = json['email'] ?? "";
  }
}
