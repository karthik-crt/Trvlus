DepositStatus depositStatusFromJson(Map<String, dynamic> json) =>
    DepositStatus.fromJson(json);

class DepositStatus {
  DepositStatus({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  late final String statusCode;
  late final String statusMessage;
  late final List<Data> data;

  DepositStatus.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    data = json['data'] != null
        ? List.from(json['data']).map((e) => Data.fromJson(e)).toList()
        : [];
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
    required this.userName,
    required this.agentCode,
    required this.agentEmail,
    required this.agentContact,
    required this.approvedUserName,
    required this.systemTransaction,
    required this.modeOfPayment,
    required this.TransactionNumber,
    required this.ourBranchAccount,
    required this.depositeBank,
    this.branch,
    required this.depositeSlip,
    this.amount,
    required this.currency,
    required this.dateOfDeposite,
    required this.user,
    required this.approvedBy,
    this.referenceNumber,
    this.remarks,
    required this.openingBalance,
    required this.closingBalance,
    required this.billStatus,
    required this.description,
    required this.credit,
    required this.debit,
    required this.historyStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  late final int id;
  late final String userName;
  late final String agentCode;
  late final String agentEmail;
  late final String agentContact;
  late final String approvedUserName;
  late final String systemTransaction;
  late final String modeOfPayment;
  late final String TransactionNumber;
  late final String ourBranchAccount;
  late final String depositeBank;
  late final String? branch;
  late final String depositeSlip;
  late final double? amount; // was int?
  late final String currency;
  late final String dateOfDeposite;
  late final int user;
  late final int approvedBy;
  late final Null referenceNumber;
  late final String? remarks;
  late final double openingBalance;
  late final double closingBalance;
  late final String billStatus;
  late final String description;
  late final double credit;
  late final double debit;
  late final String historyStatus;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    agentCode = json['agent_code'];
    agentEmail = json['agent_email'];
    agentContact = json['agent_contact'];
    approvedUserName = json['approved_user_name'];
    systemTransaction = json['system_transaction'];
    modeOfPayment = json['mode_of_payment'];
    TransactionNumber = json['Transaction_number'];
    ourBranchAccount = json['our_branch_account'];
    depositeBank = json['deposite_bank'];
    branch = json['branch'];
    depositeSlip = json['deposite_slip'];
    amount = json['amount'];
    currency = json['currency'];
    dateOfDeposite = json['date_of_deposite'];
    user = json['user'];
    approvedBy = json['approved_by'];
    referenceNumber = null;
    remarks = json['remarks'];
    openingBalance = json['opening_balance'];
    closingBalance = json['closing_balance'];
    billStatus = json['bill_status'];
    description = json['description'];
    credit = json['credit'];
    debit = json['debit'];
    historyStatus = json['history_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_name'] = userName;
    _data['agent_code'] = agentCode;
    _data['agent_email'] = agentEmail;
    _data['agent_contact'] = agentContact;
    _data['approved_user_name'] = approvedUserName;
    _data['system_transaction'] = systemTransaction;
    _data['mode_of_payment'] = modeOfPayment;
    _data['Transaction_number'] = TransactionNumber;
    _data['our_branch_account'] = ourBranchAccount;
    _data['deposite_bank'] = depositeBank;
    _data['branch'] = branch;
    _data['deposite_slip'] = depositeSlip;
    _data['amount'] = amount;
    _data['currency'] = currency;
    _data['date_of_deposite'] = dateOfDeposite;
    _data['user'] = user;
    _data['approved_by'] = approvedBy;
    _data['reference_number'] = referenceNumber;
    _data['remarks'] = remarks;
    _data['opening_balance'] = openingBalance;
    _data['closing_balance'] = closingBalance;
    _data['bill_status'] = billStatus;
    _data['description'] = description;
    _data['credit'] = credit;
    _data['debit'] = debit;
    _data['history_status'] = historyStatus;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
