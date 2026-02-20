import 'dart:convert';

FareQuotesData fareQuotesDataFromJson(Map<String, dynamic> json) =>
    FareQuotesData.fromJson(json);

class FareQuotesData {
  Response response;

  FareQuotesData({
    required this.response,
  });

  factory FareQuotesData.fromRawJson(String str) =>
      FareQuotesData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FareQuotesData.fromJson(Map<String, dynamic> json) => FareQuotesData(
        response: Response.fromJson(json["Response"]),
      );

  Map<String, dynamic> toJson() => {
        "Response": response.toJson(),
      };
}

class Response {
  Error error;
  dynamic flightDetailChangeInfo;
  bool isPriceChanged;
  int responseStatus;
  Results results;
  String traceId;

  Response({
    required this.error,
    required this.flightDetailChangeInfo,
    required this.isPriceChanged,
    required this.responseStatus,
    required this.results,
    required this.traceId,
  });

  factory Response.fromRawJson(String str) =>
      Response.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        error: Error.fromJson(json["Error"]),
        flightDetailChangeInfo: json["FlightDetailChangeInfo"],
        isPriceChanged: json["IsPriceChanged"],
        responseStatus: json["ResponseStatus"],
        results: Results.fromJson(json["Results"] ?? {}),
        traceId: json["TraceId"],
      );

  Map<String, dynamic> toJson() => {
        "Error": error.toJson(),
        "FlightDetailChangeInfo": flightDetailChangeInfo,
        "IsPriceChanged": isPriceChanged,
        "ResponseStatus": responseStatus,
        "Results": results.toJson(),
        "TraceId": traceId,
      };
}

class Error {
  int errorCode;
  String errorMessage;

  Error({
    required this.errorCode,
    required this.errorMessage,
  });

  factory Error.fromRawJson(String str) => Error.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        errorCode: json["ErrorCode"],
        errorMessage: json["ErrorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "ErrorCode": errorCode,
        "ErrorMessage": errorMessage,
      };
}

class Results {
  List<dynamic> fareInclusions;
  String firstNameFormat;
  bool isBookableIfSeatNotAvailable;
  bool isFreeMealAvailable;
  bool isHoldAllowedWithSsr;
  bool isHoldMandatoryWithSsr;
  String lastNameFormat;
  String resultIndex;
  int source;
  bool isLcc;
  bool isRefundable;
  bool isPanRequiredAtBook;
  bool isPanRequiredAtTicket;
  bool isPassportRequiredAtBook;
  bool isPassportRequiredAtTicket;
  bool gstAllowed;
  bool isCouponAppilcable;
  bool isGstMandatory;
  dynamic airlineRemark;
  bool isPassportFullDetailRequiredAtBook;
  String resultFareType;
  Fare fare;
  List<FareBreakdown> fareBreakdown;
  List<List<Segment>> segments;
  DateTime lastTicketDate;
  dynamic ticketAdvisory;
  List<FareRule> fareRules;
  String airlineCode;
  List<List<MiniFareRule>> miniFareRules;
  String validatingAirline;

  Results({
    required this.fareInclusions,
    required this.firstNameFormat,
    required this.isBookableIfSeatNotAvailable,
    required this.isFreeMealAvailable,
    required this.isHoldAllowedWithSsr,
    required this.isHoldMandatoryWithSsr,
    required this.lastNameFormat,
    required this.resultIndex,
    required this.source,
    required this.isLcc,
    required this.isRefundable,
    required this.isPanRequiredAtBook,
    required this.isPanRequiredAtTicket,
    required this.isPassportRequiredAtBook,
    required this.isPassportRequiredAtTicket,
    required this.gstAllowed,
    required this.isCouponAppilcable,
    required this.isGstMandatory,
    required this.airlineRemark,
    required this.isPassportFullDetailRequiredAtBook,
    required this.resultFareType,
    required this.fare,
    required this.fareBreakdown,
    required this.segments,
    required this.lastTicketDate,
    required this.ticketAdvisory,
    required this.fareRules,
    required this.airlineCode,
    required this.miniFareRules,
    required this.validatingAirline,
  });

  factory Results.fromRawJson(String str) => Results.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        fareInclusions: json["FareInclusions"] != null
            ? List<dynamic>.from(json["FareInclusions"].map((x) => x))
            : [],
        firstNameFormat: json["FirstNameFormat"] ?? "",
        isBookableIfSeatNotAvailable:
            json["IsBookableIfSeatNotAvailable"] ?? false,
        isFreeMealAvailable: json["IsFreeMealAvailable"] ?? false,
        isHoldAllowedWithSsr: json["IsHoldAllowedWithSSR"] ?? false,
        isHoldMandatoryWithSsr: json["IsHoldMandatoryWithSSR"] ?? false,
        lastNameFormat: json["LastNameFormat"] ?? "",
        resultIndex: json["ResultIndex"] ?? "",
        source: json["Source"] ?? 0,
        isLcc: json["IsLCC"] ?? false,
        isRefundable: json["IsRefundable"] ?? false,
        isPanRequiredAtBook: json["IsPanRequiredAtBook"] ?? false,
        isPanRequiredAtTicket: json["IsPanRequiredAtTicket"] ?? false,
        isPassportRequiredAtBook: json["IsPassportRequiredAtBook"] ?? false,
        isPassportRequiredAtTicket: json["IsPassportRequiredAtTicket"] ?? false,
        gstAllowed: json["GSTAllowed"] ?? false,
        isCouponAppilcable: json["IsCouponAppilcable"] ?? false,
        isGstMandatory: json["IsGSTMandatory"] ?? false,
        airlineRemark: json["AirlineRemark"] ?? "",
        isPassportFullDetailRequiredAtBook:
            json["IsPassportFullDetailRequiredAtBook"] ?? false,
        resultFareType: json["ResultFareType"] ?? "",
        fare: Fare.fromJson(json["Fare"] ?? {}),
        fareBreakdown: List<FareBreakdown>.from(
            json["FareBreakdown"].map((x) => FareBreakdown.fromJson(x))),
        segments: List<List<Segment>>.from(json["Segments"]
            .map((x) => List<Segment>.from(x.map((x) => Segment.fromJson(x))))),
        lastTicketDate: DateTime.parse(json["LastTicketDate"]),
        ticketAdvisory: json["TicketAdvisory"],
        fareRules: List<FareRule>.from(
            json["FareRules"].map((x) => FareRule.fromJson(x))),
        airlineCode: json["AirlineCode"],
        miniFareRules: List<List<MiniFareRule>>.from(json["MiniFareRules"].map(
            (x) => List<MiniFareRule>.from(
                x.map((x) => MiniFareRule.fromJson(x))))),
        validatingAirline: json["ValidatingAirline"],
      );

  Map<String, dynamic> toJson() => {
        "FareInclusions": List<dynamic>.from(fareInclusions.map((x) => x)),
        "FirstNameFormat": firstNameFormat,
        "IsBookableIfSeatNotAvailable": isBookableIfSeatNotAvailable,
        "IsFreeMealAvailable": isFreeMealAvailable,
        "IsHoldAllowedWithSSR": isHoldAllowedWithSsr,
        "IsHoldMandatoryWithSSR": isHoldMandatoryWithSsr,
        "LastNameFormat": lastNameFormat,
        "ResultIndex": resultIndex,
        "Source": source,
        "IsLCC": isLcc,
        "IsRefundable": isRefundable,
        "IsPanRequiredAtBook": isPanRequiredAtBook,
        "IsPanRequiredAtTicket": isPanRequiredAtTicket,
        "IsPassportRequiredAtBook": isPassportRequiredAtBook,
        "IsPassportRequiredAtTicket": isPassportRequiredAtTicket,
        "GSTAllowed": gstAllowed,
        "IsCouponAppilcable": isCouponAppilcable,
        "IsGSTMandatory": isGstMandatory,
        "AirlineRemark": airlineRemark,
        "IsPassportFullDetailRequiredAtBook":
            isPassportFullDetailRequiredAtBook,
        "ResultFareType": resultFareType,
        "Fare": fare.toJson(),
        "FareBreakdown":
            List<dynamic>.from(fareBreakdown.map((x) => x.toJson())),
        "Segments": List<dynamic>.from(
            segments.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "LastTicketDate": lastTicketDate.toIso8601String(),
        "TicketAdvisory": ticketAdvisory,
        "FareRules": List<dynamic>.from(fareRules.map((x) => x.toJson())),
        "AirlineCode": airlineCode,
        "MiniFareRules": List<dynamic>.from(miniFareRules
            .map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "ValidatingAirline": validatingAirline,
      };
}

class Fare {
  int serviceFeeDisplayType;
  String currency;
  double baseFare;
  double tax;
  List<ChargeBu> taxBreakup;
  int yqTax;
  int additionalTxnFeeOfrd;
  double additionalTxnFeePub;
  int pgCharge;
  double otherCharges;
  List<ChargeBu> chargeBu;
  double discount;
  double publishedFare;
  double commissionEarned;
  double plbEarned;
  double incentiveEarned;
  double offeredFare;
  double tdsOnCommission;
  double tdsOnPlb;
  double tdsOnIncentive;
  double serviceFee;
  double totalBaggageCharges;
  double totalMealCharges;
  double totalSeatCharges;
  double totalSpecialServiceCharges;

  Fare({
    required this.serviceFeeDisplayType,
    required this.currency,
    required this.baseFare,
    required this.tax,
    required this.taxBreakup,
    required this.yqTax,
    required this.additionalTxnFeeOfrd,
    required this.additionalTxnFeePub,
    required this.pgCharge,
    required this.otherCharges,
    required this.chargeBu,
    required this.discount,
    required this.publishedFare,
    required this.commissionEarned,
    required this.plbEarned,
    required this.incentiveEarned,
    required this.offeredFare,
    required this.tdsOnCommission,
    required this.tdsOnPlb,
    required this.tdsOnIncentive,
    required this.serviceFee,
    required this.totalBaggageCharges,
    required this.totalMealCharges,
    required this.totalSeatCharges,
    required this.totalSpecialServiceCharges,
  });

  factory Fare.fromRawJson(String str) => Fare.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Fare.fromJson(Map<String, dynamic> json) => Fare(
        serviceFeeDisplayType:
            (json["ServiceFeeDisplayType"] as num?)?.toInt() ?? 0,
        currency: json["Currency"] ?? "",
        baseFare: (json["BaseFare"] as num?)?.toDouble() ?? 0,
        tax: (json["Tax"] as num?)?.toDouble() ?? 0,
        taxBreakup: json["TaxBreakup"] != null
            ? List<ChargeBu>.from(
                json["TaxBreakup"].map((x) => ChargeBu.fromJson(x)))
            : [],
        yqTax: (json["YQTax"] as num?)?.toInt() ?? 0,
        additionalTxnFeeOfrd:
            (json["AdditionalTxnFeeOfrd"] as num?)?.toInt() ?? 0,
        additionalTxnFeePub:
            (json["AdditionalTxnFeePub"] as num?)?.toDouble() ?? 0,
        pgCharge: (json["PGCharge"] as num?)?.toInt() ?? 0,
        otherCharges: (json["OtherCharges"] as num?)?.toDouble() ?? 0,
        chargeBu: json["ChargeBU"] != null
            ? List<ChargeBu>.from(
                json["ChargeBU"].map((x) => ChargeBu.fromJson(x)))
            : [],
        discount: (json["Discount"] as num?)?.toDouble() ?? 0,
        publishedFare: (json["PublishedFare"] as num?)?.toDouble() ?? 0,
        commissionEarned: (json["CommissionEarned"] as num?)?.toDouble() ?? 0,
        plbEarned: (json["PLBEarned"] as num?)?.toDouble() ?? 0,
        incentiveEarned: (json["IncentiveEarned"] as num?)?.toDouble() ?? 0,
        offeredFare: (json["OfferedFare"] as num?)?.toDouble() ?? 0,
        tdsOnCommission: (json["TdsOnCommission"] as num?)?.toDouble() ?? 0,
        tdsOnPlb: (json["TdsOnPLB"] as num?)?.toDouble() ?? 0,
        tdsOnIncentive: (json["TdsOnIncentive"] as num?)?.toDouble() ?? 0,
        serviceFee: (json["ServiceFee"] as num?)?.toDouble() ?? 0,
        totalBaggageCharges:
            (json["TotalBaggageCharges"] as num?)?.toDouble() ?? 0,
        totalMealCharges: (json["TotalMealCharges"] as num?)?.toDouble() ?? 0,
        totalSeatCharges: (json["TotalSeatCharges"] as num?)?.toDouble() ?? 0,
        totalSpecialServiceCharges:
            (json["TotalSpecialServiceCharges"] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "ServiceFeeDisplayType": serviceFeeDisplayType,
        "Currency": currency,
        "BaseFare": baseFare,
        "Tax": tax,
        "TaxBreakup": List<dynamic>.from(taxBreakup.map((x) => x.toJson())),
        "YQTax": yqTax,
        "AdditionalTxnFeeOfrd": additionalTxnFeeOfrd,
        "AdditionalTxnFeePub": additionalTxnFeePub,
        "PGCharge": pgCharge,
        "OtherCharges": otherCharges,
        "ChargeBU": List<dynamic>.from(chargeBu.map((x) => x.toJson())),
        "Discount": discount,
        "PublishedFare": publishedFare,
        "CommissionEarned": commissionEarned,
        "PLBEarned": plbEarned,
        "IncentiveEarned": incentiveEarned,
        "OfferedFare": offeredFare,
        "TdsOnCommission": tdsOnCommission,
        "TdsOnPLB": tdsOnPlb,
        "TdsOnIncentive": tdsOnIncentive,
        "ServiceFee": serviceFee,
        "TotalBaggageCharges": totalBaggageCharges,
        "TotalMealCharges": totalMealCharges,
        "TotalSeatCharges": totalSeatCharges,
        "TotalSpecialServiceCharges": totalSpecialServiceCharges,
      };
}

class ChargeBu {
  String key;
  double value;

  ChargeBu({
    required this.key,
    required this.value,
  });

  factory ChargeBu.fromRawJson(String str) =>
      ChargeBu.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChargeBu.fromJson(Map<String, dynamic> json) => ChargeBu(
        key: json["key"],
        value: json["value"].runtimeType != double
            ? double.parse(json["value"].toString())
            : json["value"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}

class FareBreakdown {
  String currency;
  int passengerType;
  int passengerCount;
  double baseFare;
  int tax;
  List<ChargeBu> taxBreakUp;
  int yqTax;
  int additionalTxnFeeOfrd;
  double additionalTxnFeePub;
  int pgCharge;
  int supplierReissueCharges;

  FareBreakdown({
    required this.currency,
    required this.passengerType,
    required this.passengerCount,
    required this.baseFare,
    required this.tax,
    required this.taxBreakUp,
    required this.yqTax,
    required this.additionalTxnFeeOfrd,
    required this.additionalTxnFeePub,
    required this.pgCharge,
    required this.supplierReissueCharges,
  });

  factory FareBreakdown.fromRawJson(String str) =>
      FareBreakdown.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FareBreakdown.fromJson(Map<String, dynamic> json) => FareBreakdown(
        currency: json["Currency"],
        passengerType: json["PassengerType"],
        passengerCount: json["PassengerCount"],
        baseFare: (json["BaseFare"] as num?)?.toDouble() ?? 0,
        tax: (json["Tax"] as num).toInt(),
        taxBreakUp: json["TaxBreakUp"] != null
            ? List<ChargeBu>.from(
                json["TaxBreakUp"].map((x) => ChargeBu.fromJson(x)))
            : [],
        yqTax: (json["YQTax"] as num).toInt(),
        additionalTxnFeeOfrd: (json["AdditionalTxnFeeOfrd"] as num).toInt(),
        additionalTxnFeePub: json["AdditionalTxnFeePub"].toDouble() ?? 0,
        pgCharge: (json["PGCharge"] as num).toInt(),
        supplierReissueCharges: (json["SupplierReissueCharges"] as num).toInt(),
      );

  Map<String, dynamic> toJson() => {
        "Currency": currency,
        "PassengerType": passengerType,
        "PassengerCount": passengerCount,
        "BaseFare": baseFare,
        "Tax": tax,
        "TaxBreakUp": List<dynamic>.from(taxBreakUp.map((x) => x.toJson())),
        "YQTax": yqTax,
        "AdditionalTxnFeeOfrd": additionalTxnFeeOfrd,
        "AdditionalTxnFeePub": additionalTxnFeePub,
        "PGCharge": pgCharge,
        "SupplierReissueCharges": supplierReissueCharges,
      };
}

class FareRule {
  String origin;
  String destination;
  String airline;
  String fareBasisCode;
  String fareRuleDetail;
  String fareRestriction;
  String fareFamilyCode;
  String fareRuleIndex;

  FareRule({
    required this.origin,
    required this.destination,
    required this.airline,
    required this.fareBasisCode,
    required this.fareRuleDetail,
    required this.fareRestriction,
    required this.fareFamilyCode,
    required this.fareRuleIndex,
  });

  factory FareRule.fromRawJson(String str) =>
      FareRule.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FareRule.fromJson(Map<String, dynamic> json) => FareRule(
        origin: json["Origin"],
        destination: json["Destination"],
        airline: json["Airline"],
        fareBasisCode: json["FareBasisCode"],
        fareRuleDetail: json["FareRuleDetail"],
        fareRestriction: json["FareRestriction"] ?? "",
        fareFamilyCode: json["FareFamilyCode"],
        fareRuleIndex: json["FareRuleIndex"],
      );

  Map<String, dynamic> toJson() => {
        "Origin": origin,
        "Destination": destination,
        "Airline": airline,
        "FareBasisCode": fareBasisCode,
        "FareRuleDetail": fareRuleDetail,
        "FareRestriction": fareRestriction,
        "FareFamilyCode": fareFamilyCode,
        "FareRuleIndex": fareRuleIndex,
      };
}

class MiniFareRule {
  String journeyPoints;
  String type;
  String from;
  String to;
  String unit;
  String details;
  bool onlineReissueAllowed;
  bool onlineRefundAllowed;

  MiniFareRule({
    required this.journeyPoints,
    required this.type,
    required this.from,
    required this.to,
    required this.unit,
    required this.details,
    required this.onlineReissueAllowed,
    required this.onlineRefundAllowed,
  });

  factory MiniFareRule.fromRawJson(String str) =>
      MiniFareRule.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MiniFareRule.fromJson(Map<String, dynamic> json) => MiniFareRule(
        journeyPoints: json["JourneyPoints"] ?? "",
        type: json["Type"] ?? "",
        from: json["From"] ?? "",
        to: json["To"] ?? "",
        unit: json["Unit"] ?? "",
        details: json["Details"] ?? "",
        onlineReissueAllowed: json["OnlineReissueAllowed"] ?? false,
        onlineRefundAllowed: json["OnlineRefundAllowed"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "JourneyPoints": journeyPoints,
        "Type": type,
        "From": from,
        "To": to,
        "Unit": unit,
        "Details": details,
        "OnlineReissueAllowed": onlineReissueAllowed,
        "OnlineRefundAllowed": onlineRefundAllowed,
      };
}

class Segment {
  String baggage;
  String cabinBaggage;
  int cabinClass;
  String supplierFareClass;
  int tripIndicator;
  int segmentIndicator;
  Airline airline;
  Origin origin;
  Destination destination;
  int duration;
  int groundTime;
  int mile;
  bool stopOver;
  String flightInfoIndex;
  String stopPoint;
  DateTime stopPointArrivalTime;
  DateTime stopPointDepartureTime;
  String craft;
  dynamic remark;
  bool isETicketEligible;
  String flightStatus;
  String status;
  FareClassification fareClassification;

  Segment({
    required this.baggage,
    required this.cabinBaggage,
    required this.cabinClass,
    required this.supplierFareClass,
    required this.tripIndicator,
    required this.segmentIndicator,
    required this.airline,
    required this.origin,
    required this.destination,
    required this.duration,
    required this.groundTime,
    required this.mile,
    required this.stopOver,
    required this.flightInfoIndex,
    required this.stopPoint,
    required this.stopPointArrivalTime,
    required this.stopPointDepartureTime,
    required this.craft,
    required this.remark,
    required this.isETicketEligible,
    required this.flightStatus,
    required this.status,
    required this.fareClassification,
  });

  factory Segment.fromRawJson(String str) => Segment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Segment.fromJson(Map<String, dynamic> json) => Segment(
        baggage: json["Baggage"] ?? "",
        cabinBaggage: json["CabinBaggage"],
        cabinClass: json["CabinClass"],
        supplierFareClass: json["SupplierFareClass"] ?? "",
        tripIndicator: json["TripIndicator"],
        segmentIndicator: json["SegmentIndicator"],
        airline: Airline.fromJson(json["Airline"]),
        origin: Origin.fromJson(json["Origin"]),
        destination: Destination.fromJson(json["Destination"]),
        duration: json["Duration"],
        groundTime: json["GroundTime"],
        mile: json["Mile"],
        stopOver: json["StopOver"],
        flightInfoIndex: json["FlightInfoIndex"],
        stopPoint: json["StopPoint"],
        stopPointArrivalTime: DateTime.parse(json["StopPointArrivalTime"]),
        stopPointDepartureTime: DateTime.parse(json["StopPointDepartureTime"]),
        craft: json["Craft"],
        remark: json["Remark"],
        isETicketEligible: json["IsETicketEligible"] ?? false,
        flightStatus: json["FlightStatus"],
        status: json["Status"],
        fareClassification:
            FareClassification.fromJson(json["FareClassification"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "Baggage": baggage,
        "CabinBaggage": cabinBaggage,
        "CabinClass": cabinClass,
        "SupplierFareClass": supplierFareClass,
        "TripIndicator": tripIndicator,
        "SegmentIndicator": segmentIndicator,
        "Airline": airline.toJson(),
        "Origin": origin.toJson(),
        "Destination": destination.toJson(),
        "Duration": duration,
        "GroundTime": groundTime,
        "Mile": mile,
        "StopOver": stopOver,
        "FlightInfoIndex": flightInfoIndex,
        "StopPoint": stopPoint,
        "StopPointArrivalTime": stopPointArrivalTime.toIso8601String(),
        "StopPointDepartureTime": stopPointDepartureTime.toIso8601String(),
        "Craft": craft,
        "Remark": remark,
        "IsETicketEligible": isETicketEligible,
        "FlightStatus": flightStatus,
        "Status": status,
        "FareClassification": fareClassification.toJson(),
      };
}

class Airline {
  String airlineCode;
  String airlineName;
  String flightNumber;
  String fareClass;
  String operatingCarrier;

  Airline({
    required this.airlineCode,
    required this.airlineName,
    required this.flightNumber,
    required this.fareClass,
    required this.operatingCarrier,
  });

  factory Airline.fromRawJson(String str) => Airline.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Airline.fromJson(Map<String, dynamic> json) => Airline(
        airlineCode: json["AirlineCode"] ?? "",
        airlineName: json["AirlineName"] ?? "",
        flightNumber: json["FlightNumber"] ?? "",
        fareClass: json["FareClass"] ?? "",
        operatingCarrier: json["OperatingCarrier"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "AirlineCode": airlineCode,
        "AirlineName": airlineName,
        "FlightNumber": flightNumber,
        "FareClass": fareClass,
        "OperatingCarrier": operatingCarrier,
      };
}

class Destination {
  Airport airport;
  DateTime arrTime;

  Destination({
    required this.airport,
    required this.arrTime,
  });

  factory Destination.fromRawJson(String str) =>
      Destination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        airport: Airport.fromJson(json["Airport"]),
        arrTime: DateTime.parse(json["ArrTime"]),
      );

  Map<String, dynamic> toJson() => {
        "Airport": airport.toJson(),
        "ArrTime": arrTime.toIso8601String(),
      };
}

class Airport {
  String airportCode;
  String airportName;
  String terminal;
  String cityCode;
  String cityName;
  String countryCode;
  String countryName;

  Airport({
    required this.airportCode,
    required this.airportName,
    required this.terminal,
    required this.cityCode,
    required this.cityName,
    required this.countryCode,
    required this.countryName,
  });

  factory Airport.fromRawJson(String str) => Airport.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Airport.fromJson(Map<String, dynamic> json) => Airport(
        airportCode: json["AirportCode"] ?? "",
        airportName: json["AirportName"] ?? "",
        terminal: json["Terminal"] ?? "",
        cityCode: json["CityCode"] ?? "",
        cityName: json["CityName"] ?? "",
        countryCode: json["CountryCode"] ?? "",
        countryName: json["CountryName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "AirportCode": airportCode,
        "AirportName": airportName,
        "Terminal": terminal,
        "CityCode": cityCode,
        "CityName": cityName,
        "CountryCode": countryCode,
        "CountryName": countryName,
      };
}

class FareClassification {
  String type;

  FareClassification({
    required this.type,
  });

  factory FareClassification.fromRawJson(String str) =>
      FareClassification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FareClassification.fromJson(Map<String, dynamic> json) =>
      FareClassification(
        type: json["Type"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Type": type,
      };
}

class Origin {
  Airport airport;
  DateTime depTime;

  Origin({
    required this.airport,
    required this.depTime,
  });

  factory Origin.fromRawJson(String str) => Origin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Origin.fromJson(Map<String, dynamic> json) => Origin(
        airport: Airport.fromJson(json["Airport"]),
        depTime: DateTime.parse(json["DepTime"]),
      );

  Map<String, dynamic> toJson() => {
        "Airport": airport.toJson(),
        "DepTime": depTime.toIso8601String(),
      };
}
