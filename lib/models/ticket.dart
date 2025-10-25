import 'dart:convert';

/// Top-level function to parse
ApiResponse apiResponseFromJson(String str) =>
    ApiResponse.fromJson(json.decode(str));

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  ResponseValue response;

  ApiResponse({required this.response});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        response: ResponseValue.fromJson(json["Response"]),
      );

  Map<String, dynamic> toJson() => {
        "Response": response.toJson(),
      };
}

class ResponseValue {
  bool b2b2bStatus;
  ErrorDetails error;
  int responseStatus;
  String traceId;
  ResponseResult response;

  ResponseValue({
    required this.b2b2bStatus,
    required this.error,
    required this.responseStatus,
    required this.traceId,
    required this.response,
  });

  factory ResponseValue.fromJson(Map<String, dynamic> json) => ResponseValue(
        b2b2bStatus: json["B2B2BStatus"],
        error: ErrorDetails.fromJson(json["Error"]),
        responseStatus: json["ResponseStatus"],
        traceId: json["TraceId"],
        response: ResponseResult.fromJson(json["Response"]),
      );

  Map<String, dynamic> toJson() => {
        "B2B2BStatus": b2b2bStatus,
        "Error": error.toJson(),
        "ResponseStatus": responseStatus,
        "TraceId": traceId,
        "Response": response.toJson(),
      };
}

class ErrorDetails {
  int errorCode;
  String errorMessage;

  ErrorDetails({
    required this.errorCode,
    required this.errorMessage,
  });

  factory ErrorDetails.fromJson(Map<String, dynamic> json) => ErrorDetails(
        errorCode: json["ErrorCode"],
        errorMessage: json["ErrorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "ErrorCode": errorCode,
        "ErrorMessage": errorMessage,
      };
}

/// The actual booking response
class ResponseResult {
  String? pnr;
  int? bookingId;
  int? status;
  bool? isPriceChanged;
  bool? isTimeChanged;
  FlightItinerary? flightItinerary;
  int? ticketStatus;

  ResponseResult({
    this.pnr,
    this.bookingId,
    this.status,
    this.isPriceChanged,
    this.isTimeChanged,
    this.flightItinerary,
    this.ticketStatus,
  });

  factory ResponseResult.fromJson(Map<String, dynamic> json) => ResponseResult(
        pnr: json["PNR"],
        bookingId: json["BookingId"],
        status: json["Status"],
        isPriceChanged: json["IsPriceChanged"],
        isTimeChanged: json["IsTimeChanged"],
        flightItinerary: json["FlightItinerary"] != null
            ? FlightItinerary.fromJson(json["FlightItinerary"])
            : null,
        ticketStatus: json["TicketStatus"],
      );

  Map<String, dynamic> toJson() => {
        "PNR": pnr,
        "BookingId": bookingId,
        "Status": status,
        "IsPriceChanged": isPriceChanged,
        "IsTimeChanged": isTimeChanged,
        "FlightItinerary": flightItinerary?.toJson(),
        "TicketStatus": ticketStatus,
      };
}

/// Simplified FlightItinerary (you can expand as needed)
class FlightItinerary {
  String? origin;
  String? destination;
  String? airlineCode;
  Fare? fare;

  FlightItinerary({
    this.origin,
    this.destination,
    this.airlineCode,
    this.fare,
  });

  factory FlightItinerary.fromJson(Map<String, dynamic> json) =>
      FlightItinerary(
        origin: json["Origin"],
        destination: json["Destination"],
        airlineCode: json["AirlineCode"],
        fare: json["Fare"] != null ? Fare.fromJson(json["Fare"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "Origin": origin,
        "Destination": destination,
        "AirlineCode": airlineCode,
        "Fare": fare?.toJson(),
      };
}

class Fare {
  String? currency;
  double? baseFare;
  double? tax;
  double? publishedFare;
  double? offeredFare;

  Fare({
    this.currency,
    this.baseFare,
    this.tax,
    this.publishedFare,
    this.offeredFare,
  });

  factory Fare.fromJson(Map<String, dynamic> json) => Fare(
        currency: json["Currency"],
        baseFare: (json["BaseFare"] as num?)?.toDouble(),
        tax: (json["Tax"] as num?)?.toDouble(),
        publishedFare: (json["PublishedFare"] as num?)?.toDouble(),
        offeredFare: (json["OfferedFare"] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Currency": currency,
        "BaseFare": baseFare,
        "Tax": tax,
        "PublishedFare": publishedFare,
        "OfferedFare": offeredFare,
      };
}
