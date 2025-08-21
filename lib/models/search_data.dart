/*SearchData searchDataFromJson(String str) =>
    SearchData.fromJson(json.decode(str));*/

/*String searchDataToJson(SearchData data) => json.encode(data.toJson());*/
SearchData searchDataFromJson(Map<String, dynamic> str) =>
    SearchData.fromJson(str);

class SearchData {
  Response response;

  SearchData({
    required this.response,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        response: Response.fromJson(json["Response"]),
      );

  Map<String, dynamic> toJson() => {
        "Response": response.toJson(),
      };
}

class Response {
  int resultRecommendationType;
  int responseStatus;
  Error error;
  String traceId;
  String origin;
  String destination;
  List<List<Result>> results;

  Response({
    required this.resultRecommendationType,
    required this.responseStatus,
    required this.error,
    required this.traceId,
    required this.origin,
    required this.destination,
    required this.results,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        resultRecommendationType: json["ResultRecommendationType"],
        responseStatus: json["ResponseStatus"],
        error: Error.fromJson(json["Error"]),
        traceId: json["TraceId"],
        origin: json["Origin"] ?? "",
        destination: json["Destination"] ?? "",
        results: json["Results"] != null
            ? List<List<Result>>.from(json["Results"].map(
                (x) => List<Result>.from(x.map((x) => Result.fromJson(x)))))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "ResultRecommendationType": resultRecommendationType,
        "ResponseStatus": responseStatus,
        "Error": error.toJson(),
        "TraceId": traceId,
        "Origin": origin,
        "Destination": destination,
        "Results": List<dynamic>.from(
            results.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}

class Error {
  int errorCode;
  String errorMessage;

  Error({
    required this.errorCode,
    required this.errorMessage,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        errorCode: json["ErrorCode"],
        errorMessage: json["ErrorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "ErrorCode": errorCode,
        "ErrorMessage": errorMessage,
      };
}

class Result {
  List<dynamic> fareInclusions;
  dynamic firstNameFormat;
  bool isBookableIfSeatNotAvailable;
  bool isFreeMealAvailable;
  bool isHoldAllowedWithSsr;
  bool isHoldMandatoryWithSsr;
  bool isUpsellAllowed;
  dynamic lastNameFormat;
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
  String airlineRemark;
  bool isPassportFullDetailRequiredAtBook;
  String resultFareType;
  Fare fare;
  List<FareBreakdown> fareBreakdown;
  List<List<Segment>> segments;
  String lastTicketDate;
  String ticketAdvisory;
  List<FareRule> fareRules;
  PenaltyCharges penaltyCharges;
  String airlineCode;
  List<List<MiniFareRule>> miniFareRules;
  String validatingAirline;
  ResultFareClassification fareClassification;

  Result({
    required this.fareInclusions,
    required this.firstNameFormat,
    required this.isBookableIfSeatNotAvailable,
    required this.isFreeMealAvailable,
    required this.isHoldAllowedWithSsr,
    required this.isHoldMandatoryWithSsr,
    required this.isUpsellAllowed,
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
    required this.penaltyCharges,
    required this.airlineCode,
    required this.miniFareRules,
    required this.validatingAirline,
    required this.fareClassification,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        fareInclusions:
            List<dynamic>.from(json["FareInclusions"].map((x) => x)),
        firstNameFormat: json["FirstNameFormat"],
        isBookableIfSeatNotAvailable:
            json["IsBookableIfSeatNotAvailable"] ?? false,
        isFreeMealAvailable: json["IsFreeMealAvailable"] ?? false,
        isHoldAllowedWithSsr: json["IsHoldAllowedWithSSR"] ?? false,
        isHoldMandatoryWithSsr: json["IsHoldMandatoryWithSSR"],
        isUpsellAllowed: json["IsUpsellAllowed"] ?? false,
        lastNameFormat: json["LastNameFormat"] ?? "",
        resultIndex: json["ResultIndex"],
        source: json["Source"],
        isLcc: json["IsLCC"],
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
        lastTicketDate: json["LastTicketDate"] ?? "",
        ticketAdvisory: json["TicketAdvisory"] ?? "",
        fareRules: List<FareRule>.from(
            json["FareRules"].map((x) => FareRule.fromJson(x))),
        penaltyCharges: PenaltyCharges.fromJson(json["PenaltyCharges"] ?? {}),
        airlineCode: json["AirlineCode"],
        miniFareRules: json["MiniFareRules"] != null
            ? List<List<MiniFareRule>>.from(
                json["MiniFareRules"].map(
                  (x) => List<MiniFareRule>.from(
                    x.map((x) => MiniFareRule.fromJson(x)),
                  ),
                ),
              )
            : [],
        validatingAirline: json["ValidatingAirline"] ?? "",
        fareClassification:
            ResultFareClassification.fromJson(json["FareClassification"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "FareInclusions": List<dynamic>.from(fareInclusions.map((x) => x)),
        "FirstNameFormat": firstNameFormat,
        "IsBookableIfSeatNotAvailable": isBookableIfSeatNotAvailable,
        "IsFreeMealAvailable": isFreeMealAvailable,
        "IsHoldAllowedWithSSR": isHoldAllowedWithSsr,
        "IsHoldMandatoryWithSSR": isHoldMandatoryWithSsr,
        "IsUpsellAllowed": isUpsellAllowed,
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
        "LastTicketDate": lastTicketDate,
        "TicketAdvisory": ticketAdvisory,
        "FareRules": List<dynamic>.from(fareRules.map((x) => x.toJson())),
        "PenaltyCharges": penaltyCharges.toJson(),
        "AirlineCode": airlineCode,
        "MiniFareRules": List<dynamic>.from(miniFareRules
            .map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "ValidatingAirline": validatingAirline,
        "FareClassification": fareClassification.toJson(),
      };
}

class Fare {
  String currency;
  double baseFare;
  double tax;
  List<ChargeBu> taxBreakup;
  double yqTax;
  double additionalTxnFeeOfrd;
  double additionalTxnFeePub;
  double pgCharge;
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

  factory Fare.fromJson(Map<String, dynamic> json) => Fare(
        currency: json["Currency"],
        baseFare: json["BaseFare"].toDouble(),
        tax: json["Tax"].toDouble(),
        taxBreakup: List<ChargeBu>.from(
            json["TaxBreakup"].map((x) => ChargeBu.fromJson(x))),
        yqTax: json["YQTax"].toDouble(),
        additionalTxnFeeOfrd: json["AdditionalTxnFeeOfrd"].toDouble(),
        additionalTxnFeePub: json["AdditionalTxnFeePub"].toDouble(),
        pgCharge: json["PGCharge"].toDouble(),
        otherCharges: json["OtherCharges"].runtimeType != double
            ? double.parse(json["OtherCharges"].toString())
            : json["OtherCharges"] ?? 0.0,
        chargeBu: List<ChargeBu>.from(
            json["ChargeBU"].map((x) => ChargeBu.fromJson(x))),
        discount: json["Discount"].toDouble(),
        publishedFare: json["PublishedFare"].toDouble(),
        commissionEarned: json["CommissionEarned"]?.toDouble(),
        plbEarned: json["PLBEarned"].toDouble(),
        incentiveEarned: json["IncentiveEarned"].toDouble(),
        offeredFare: json["OfferedFare"]?.toDouble(),
        tdsOnCommission: json["TdsOnCommission"]?.toDouble(),
        tdsOnPlb: json["TdsOnPLB"].toDouble(),
        tdsOnIncentive: json["TdsOnIncentive"].toDouble(),
        serviceFee: json["ServiceFee"].toDouble(),
        totalBaggageCharges: json["TotalBaggageCharges"].toDouble(),
        totalMealCharges: json["TotalMealCharges"].toDouble(),
        totalSeatCharges: json["TotalSeatCharges"].toDouble(),
        totalSpecialServiceCharges:
            json["TotalSpecialServiceCharges"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
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

  factory ChargeBu.fromJson(Map<String, dynamic> json) => ChargeBu(
        key: json["key"],
        value: json["value"].runtimeType != double
            ? double.parse(json["value"].toString())
            : json["value"] ?? 0.0,
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
  int baseFare;
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

  factory FareBreakdown.fromJson(Map<String, dynamic> json) => FareBreakdown(
        currency: json["Currency"],
        passengerType: json["PassengerType"],
        passengerCount: json["PassengerCount"],
        baseFare: json["BaseFare"],
        tax: json["Tax"],
        taxBreakUp: json["TaxBreakUp"] != null && json["TaxBreakUp"] is List
            ? List<ChargeBu>.from(
                json["TaxBreakUp"].map((x) => ChargeBu.fromJson(x)))
            : [],
        yqTax: json["YQTax"],
        additionalTxnFeeOfrd: json["AdditionalTxnFeeOfrd"],
        additionalTxnFeePub: json["AdditionalTxnFeePub"].toDouble(),
        pgCharge: json["PGCharge"],
        supplierReissueCharges: json["SupplierReissueCharges"],
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

class ResultFareClassification {
  String color;
  String type;

  ResultFareClassification({
    required this.color,
    required this.type,
  });

  factory ResultFareClassification.fromJson(Map<String, dynamic> json) =>
      ResultFareClassification(
        color: json["Color"] ?? "",
        type: json["Type"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Color": color,
        "Type": type,
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

  factory FareRule.fromJson(Map<String, dynamic> json) => FareRule(
        origin: json["Origin"],
        destination: json["Destination"],
        airline: json["Airline"],
        fareBasisCode: json["FareBasisCode"],
        fareRuleDetail: json["FareRuleDetail"],
        fareRestriction: json["FareRestriction"],
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
  dynamic from;
  dynamic to;
  dynamic unit;
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

class PenaltyCharges {
  String reissueCharge;
  String cancellationCharge;

  PenaltyCharges({
    required this.reissueCharge,
    required this.cancellationCharge,
  });

  factory PenaltyCharges.fromJson(Map<String, dynamic> json) => PenaltyCharges(
        reissueCharge: json["ReissueCharge"] ?? "",
        cancellationCharge: json["CancellationCharge"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ReissueCharge": reissueCharge,
        "CancellationCharge": cancellationCharge,
      };
}

class Segment {
  String baggage;
  String cabinBaggage;
  int cabinClass;
  dynamic supplierFareClass;
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
  String stopPointArrivalTime;
  String stopPointDepartureTime;
  String craft;
  dynamic remark;
  bool isETicketEligible;
  String flightStatus;
  String status;
  SegmentFareClassification fareClassification;
  double accumulatedDuration;

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
    required this.accumulatedDuration,
  });

  factory Segment.fromJson(Map<String, dynamic> json) => Segment(
        baggage: json["Baggage"] ?? "",
        cabinBaggage: json["CabinBaggage"] ?? "",
        cabinClass: json["CabinClass"] ?? "",
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
        stopPointArrivalTime: json["StopPointArrivalTime"] ?? "",
        stopPointDepartureTime: json["StopPointDepartureTime"] ?? "",
        craft: json["Craft"],
        remark: json["Remark"],
        isETicketEligible: json["IsETicketEligible"],
        flightStatus: json["FlightStatus"],
        status: json["Status"],
        fareClassification: SegmentFareClassification.fromJson(
            json["FareClassification"] ?? {}),
        accumulatedDuration: json['AccumulatedDuration'] != null
            ? json["AccumulatedDuration"].runtimeType != double
                ? double.parse(json['AccumulatedDuration'].toString())
                : json['AccumulatedDuration'] ?? 0.0
            : 0.0,
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
        "StopPointArrivalTime": stopPointArrivalTime,
        "StopPointDepartureTime": stopPointDepartureTime,
        "Craft": craft,
        "Remark": remark,
        "IsETicketEligible": isETicketEligible,
        "FlightStatus": flightStatus,
        "Status": status,
        "FareClassification": fareClassification.toJson(),
        "AccumulatedDuration": accumulatedDuration,
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

  factory Airline.fromJson(Map<String, dynamic> json) => Airline(
        airlineCode: json["AirlineCode"],
        airlineName: json["AirlineName"],
        flightNumber: json["FlightNumber"],
        fareClass: json["FareClass"],
        operatingCarrier: json["OperatingCarrier"],
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

  factory Airport.fromJson(Map<String, dynamic> json) => Airport(
        airportCode: json["AirportCode"],
        airportName: json["AirportName"],
        terminal: json["Terminal"],
        cityCode: json["CityCode"],
        cityName: json["CityName"],
        countryCode: json["CountryCode"],
        countryName: json["CountryName"],
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

class SegmentFareClassification {
  String type;

  SegmentFareClassification({
    required this.type,
  });

  factory SegmentFareClassification.fromJson(Map<String, dynamic> json) =>
      SegmentFareClassification(
        type: json["Type"] ?? '',
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

  factory Origin.fromJson(Map<String, dynamic> json) => Origin(
        airport: Airport.fromJson(json["Airport"]),
        depTime: DateTime.parse(json["DepTime"]),
      );

  Map<String, dynamic> toJson() => {
        "Airport": airport.toJson(),
        "DepTime": depTime.toIso8601String(),
      };
}
