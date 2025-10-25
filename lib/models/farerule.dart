FareRuleData fareRuleDataFromJson(Map<String, dynamic> json) =>
    FareRuleData.fromJson(json);

class FareRuleData {
  FareRuleData({
    required this.responseData,
  });

  late final ResponseData responseData;

  FareRuleData.fromJson(Map<String, dynamic> json) {
    responseData = ResponseData.fromJson(json['Response']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Response'] = responseData.toJson();
    return _data;
  }
}

class ResponseData {
  ResponseData({
    required this.errorData,
    required this.fareRules,
    required this.ResponseStatus,
    required this.TraceId,
  });

  late final ErrorData errorData;
  late final List<FareRules> fareRules;
  late final int ResponseStatus;
  late final String TraceId;

  ResponseData.fromJson(Map<String, dynamic> json) {
    errorData = ErrorData.fromJson(json['Error']);
    fareRules = List.from(json['FareRules'] ?? {})
        .map((e) => FareRules.fromJson(e))
        .toList();
    ResponseStatus = json['ResponseStatus'];
    TraceId = json['TraceId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Error'] = errorData.toJson();
    _data['FareRules'] = fareRules.map((e) => e.toJson()).toList();
    _data['ResponseStatus'] = ResponseStatus;
    _data['TraceId'] = TraceId;
    return _data;
  }
}

class ErrorData {
  ErrorData({
    required this.ErrorCode,
    required this.ErrorMessage,
  });

  late final int ErrorCode;
  late final String ErrorMessage;

  ErrorData.fromJson(Map<String, dynamic> json) {
    ErrorCode = json['ErrorCode'];
    ErrorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ErrorCode'] = ErrorCode;
    _data['ErrorMessage'] = ErrorMessage;
    return _data;
  }
}

class FareRules {
  FareRules({
    required this.Airline,
    required this.DepartureTime,
    required this.Destination,
    required this.FareBasisCode,
    required this.FareInclusions,
    this.FareRestriction,
    required this.FareRuleDetail,
    required this.FlightId,
    required this.Origin,
    required this.ReturnDate,
  });

  late final String Airline;
  late final String DepartureTime;
  late final String Destination;
  late final String FareBasisCode;
  late final List<String> FareInclusions;
  late final Null FareRestriction;
  late final String FareRuleDetail;
  late final int FlightId;
  late final String Origin;
  late final String ReturnDate;

  FareRules.fromJson(Map<String, dynamic> json) {
    Airline = json['Airline'];
    DepartureTime = json['DepartureTime'];
    Destination = json['Destination'];
    FareBasisCode = json['FareBasisCode'];
    FareInclusions = json['FareInclusions'] != null
        ? List.castFrom<dynamic, String>(json['FareInclusions'])
        : [];
    FareRestriction = null;
    FareRuleDetail = json['FareRuleDetail'];
    FlightId = json['FlightId'];
    Origin = json['Origin'];
    ReturnDate = json['ReturnDate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Airline'] = Airline;
    _data['DepartureTime'] = DepartureTime;
    _data['Destination'] = Destination;
    _data['FareBasisCode'] = FareBasisCode;
    _data['FareInclusions'] = FareInclusions;
    _data['FareRestriction'] = FareRestriction;
    _data['FareRuleDetail'] = FareRuleDetail;
    _data['FlightId'] = FlightId;
    _data['Origin'] = Origin;
    _data['ReturnDate'] = ReturnDate;
    return _data;
  }
}
