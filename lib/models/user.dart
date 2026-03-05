User userFromJson(Map<String, dynamic> json) => User.fromJson(json);

class User {
  User({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  late final String statusCode;
  late final String statusMessage;
  late final List<Data> data;

  User.fromJson(Map<String, dynamic> json) {
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
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.userImages,
    required this.userImage,
    required this.panCard,
    required this.state,
    required this.district,
    required this.agentMenu,
    required this.cancelList,
    required this.refundList,
    required this.isBookingHistory,
    required this.isAccount,
    required this.isHistory,
    required this.recommendedBy,
    required this.gstNumber,
    required this.iqma,
    required this.passportId,
    required this.aadharCard,
    required this.govrProf,
    required this.createdBy,
    required this.createrName,
    required this.subPassword,
    required this.agentCode,
    required this.browser,
    this.otpExpiredOn,
    required this.otp,
    required this.wallet,
    required this.walletTicketBooking,
    required this.serverWallet,
    required this.lastSignin,
    required this.isSuperadmin,
    required this.isAdmin,
    required this.isSubadmin,
    required this.isAgent,
    required this.isSuperagent,
    required this.roleName,
    required this.dateofbirth,
    required this.gender,
    required this.rememberToken,
    required this.password,
    required this.mobile,
    required this.email,
    this.countryCode,
    required this.status,
    required this.panCardNo,
    required this.aadharCardNo,
    required this.proprietorName,
    required this.kycStatus,
    required this.companyName,
    required this.companyAddress,
    required this.statusName,
    required this.balanceVerified,
    required this.representativeName,
    required this.representativeNumber,
    required this.isCustomer,
    required this.createdAt,
    required this.updatedAt,
  });

  late final int id;
  late final String firstName;
  late final String lastName;
  late final int role;
  late final String userImages;
  late final String userImage;
  late final String panCard;
  late final String state;
  late final String district;
  late final bool agentMenu;
  late final bool cancelList;
  late final bool refundList;
  late final bool isBookingHistory;
  late final bool isAccount;
  late final bool isHistory;
  late final String recommendedBy;
  late final String gstNumber;
  late final String iqma;
  late final String passportId;
  late final String aadharCard;
  late final String govrProf;
  late final int createdBy;
  late final String createrName;
  late final String subPassword;
  late final String agentCode;
  late final String browser;
  late final Null otpExpiredOn;
  late final String otp;
  late final double wallet;
  late final double walletTicketBooking;
  late final double serverWallet;
  late final String lastSignin;
  late final int isSuperadmin;
  late final int isAdmin;
  late final int isSubadmin;
  late final int isAgent;
  late final int isSuperagent;
  late final String roleName;
  late final String dateofbirth;
  late final String gender;
  late final String rememberToken;
  late final String password;
  late final String mobile;
  late final String email;
  late final Null countryCode;
  late final int status;
  late final String panCardNo;
  late final String aadharCardNo;
  late final String proprietorName;
  late final String kycStatus;
  late final String companyName;
  late final String companyAddress;
  late final String statusName;
  late final String balanceVerified;
  late final String representativeName;
  late final String representativeNumber;
  late final int isCustomer;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    role = json['role'];
    userImages = json['user_images'];
    userImage = json['user_image'];
    panCard = json['pan_card'];
    state = json['state'];
    district = json['district'];
    agentMenu = json['agent_menu'];
    cancelList = json['cancel_list'];
    refundList = json['refund_list'];
    isBookingHistory = json['isBookingHistory'];
    isAccount = json['isAccount'];
    isHistory = json['isHistory'];
    recommendedBy = json['recommended_by'];
    gstNumber = json['gst_number'];
    iqma = json['iqma'];
    passportId = json['passport_id'];
    aadharCard = json['aadhar_card'];
    govrProf = json['govr_prof'];
    createdBy = json['created_by'];
    createrName = json['creater_name'];
    subPassword = json['sub_password'];
    agentCode = json['agent_code'];
    browser = json['browser'];
    otpExpiredOn = null;
    otp = json['otp'];
    wallet = (json['wallet'] as num?)?.toDouble() ?? 0.0;
    walletTicketBooking =
        (json['wallet_ticket_booking'] as num?)?.toDouble() ?? 0.0;
    serverWallet = (json['server_wallet'] as num?)?.toDouble() ?? 0.0;
    lastSignin = json['last_signin'];
    isSuperadmin = json['is_superadmin'];
    isAdmin = json['is_admin'];
    isSubadmin = json['is_subadmin'];
    isAgent = json['is_agent'];
    isSuperagent = json['is_superagent'];
    roleName = json['role_name'];
    dateofbirth = json['dateofbirth'] ?? "";
    gender = json['gender'];
    rememberToken = json['remember_token'];
    password = json['password'];
    mobile = json['mobile'];
    email = json['email'];
    countryCode = null;
    status = json['status'];
    panCardNo = json['pan_card_no'];
    aadharCardNo = json['aadhar_card_no'];
    proprietorName = json['proprietor_name'];
    kycStatus = json['kyc_status'];
    companyName = json['company_Name'];
    companyAddress = json['company_Address'];
    statusName = json['status_name'];
    balanceVerified = json['balance_verified'];
    representativeName = json['representative_name'];
    representativeNumber = json['representative_number'];
    isCustomer = json['is_customer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['role'] = role;
    _data['user_images'] = userImages;
    _data['user_image'] = userImage;
    _data['pan_card'] = panCard;
    _data['state'] = state;
    _data['district'] = district;
    _data['agent_menu'] = agentMenu;
    _data['cancel_list'] = cancelList;
    _data['refund_list'] = refundList;
    _data['isBookingHistory'] = isBookingHistory;
    _data['isAccount'] = isAccount;
    _data['isHistory'] = isHistory;
    _data['recommended_by'] = recommendedBy;
    _data['gst_number'] = gstNumber;
    _data['iqma'] = iqma;
    _data['passport_id'] = passportId;
    _data['aadhar_card'] = aadharCard;
    _data['govr_prof'] = govrProf;
    _data['created_by'] = createdBy;
    _data['creater_name'] = createrName;
    _data['sub_password'] = subPassword;
    _data['agent_code'] = agentCode;
    _data['browser'] = browser;
    _data['otp_expired_on'] = otpExpiredOn;
    _data['otp'] = otp;
    _data['wallet'] = wallet;
    _data['wallet_ticket_booking'] = walletTicketBooking;
    _data['server_wallet'] = serverWallet;
    _data['last_signin'] = lastSignin;
    _data['is_superadmin'] = isSuperadmin;
    _data['is_admin'] = isAdmin;
    _data['is_subadmin'] = isSubadmin;
    _data['is_agent'] = isAgent;
    _data['is_superagent'] = isSuperagent;
    _data['role_name'] = roleName;
    _data['dateofbirth'] = dateofbirth;
    _data['gender'] = gender;
    _data['remember_token'] = rememberToken;
    _data['password'] = password;
    _data['mobile'] = mobile;
    _data['email'] = email;
    _data['country_code'] = countryCode;
    _data['status'] = status;
    _data['pan_card_no'] = panCardNo;
    _data['aadhar_card_no'] = aadharCardNo;
    _data['proprietor_name'] = proprietorName;
    _data['kyc_status'] = kycStatus;
    _data['company_Name'] = companyName;
    _data['company_Address'] = companyAddress;
    _data['status_name'] = statusName;
    _data['balance_verified'] = balanceVerified;
    _data['representative_name'] = representativeName;
    _data['representative_number'] = representativeNumber;
    _data['is_customer'] = isCustomer;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
