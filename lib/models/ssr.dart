SsrData ssrDataFromJson(Map<String, dynamic> json) => SsrData.fromJson(json);

class SsrData {
  final ResponseData response;

  SsrData({required this.response});

  factory SsrData.fromJson(Map<String, dynamic> json) {
    return SsrData(
      response: ResponseData.fromJson(json['Response']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Response': response.toJson(),
    };
  }
}

class ResponseData {
  final int responseStatus;
  final Error error;
  final String traceId;
  final List<List<Baggage>> baggage;
  final List<List<MealDynamic>> mealDynamic;
  final List<SeatPreference> seatPreference;
  final List<SeatDynamic> seatDynamic;

  ResponseData({
    required this.responseStatus,
    required this.error,
    required this.traceId,
    required this.baggage,
    required this.mealDynamic,
    required this.seatDynamic,
    required this.seatPreference,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    var baggageList = json['Baggage'] != null ? json['Baggage'] as List : [];
    var seatDynamicList =
        json['SeatDynamic'] != null ? json['SeatDynamic'] as List : [];
    var seatPreferenceList =
        json['SeatPreference'] != null ? json['SeatPreference'] as List : [];

    // Handle both MealDynamic and Meal responses
    List<List<MealDynamic>> parsedMealDynamic = [];

    if (json['MealDynamic'] != null) {
      parsedMealDynamic = (json['MealDynamic'] as List).map((e) {
        return (e as List).map((item) => MealDynamic.fromJson(item)).toList();
      }).toList();
    } else if (json['Meal'] != null) {
      // Wrap flat meal list into one nested list
      parsedMealDynamic = [
        (json['Meal'] as List)
            .map((item) => MealDynamic.fromJson(item))
            .toList()
      ];
    }

    return ResponseData(
      responseStatus: json['ResponseStatus'],
      error: Error.fromJson(json['Error']),
      traceId: json['TraceId'],
      baggage: baggageList
          .map(
              (e) => (e as List).map((item) => Baggage.fromJson(item)).toList())
          .toList(),
      mealDynamic: parsedMealDynamic,
      seatDynamic:
          seatDynamicList.map((item) => SeatDynamic.fromJson(item)).toList(),
      seatPreference: seatPreferenceList
          .map((item) => SeatPreference.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ResponseStatus': responseStatus,
      'Error': error.toJson(),
      'TraceId': traceId,
      'Baggage':
          baggage.map((e) => e.map((item) => item.toJson()).toList()).toList(),
      'MealDynamic': mealDynamic
          .map((e) => e.map((item) => item.toJson()).toList())
          .toList(),
      'SeatDynamic': seatDynamic.map((item) => item.toJson()).toList(),
      'SeatPreference': seatPreference.map((item) => item.toJson()).toList(),
    };
  }
}

class SeatPreference {
  SeatPreference({
    required this.code,
    required this.description,
  });

  late final String code;
  late final String description;

  SeatPreference.fromJson(Map<String, dynamic> json) {
    code = json['Code'] ?? '';
    description = json['Description'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Code'] = code;
    data['Description'] = description;
    return data;
  }
}

class Error {
  final int errorCode;
  final String errorMessage;

  Error({required this.errorCode, required this.errorMessage});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      errorCode: json['ErrorCode'],
      errorMessage: json['ErrorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ErrorCode': errorCode,
      'ErrorMessage': errorMessage,
    };
  }
}

class Baggage {
  final String airlineCode;
  final String flightNumber;
  final int wayType;
  final String code;
  final int description;
  final int weight;
  final String currency;
  final double price;
  final String origin;
  final String destination;

  Baggage({
    required this.airlineCode,
    required this.flightNumber,
    required this.wayType,
    required this.code,
    required this.description,
    required this.weight,
    required this.currency,
    required this.price,
    required this.origin,
    required this.destination,
  });

  factory Baggage.fromJson(Map<String, dynamic> json) {
    return Baggage(
      airlineCode: json['AirlineCode'],
      flightNumber: json['FlightNumber'],
      wayType: json['WayType'],
      code: json['Code'],
      description: json['Description'],
      weight: json['Weight'],
      currency: json['Currency'],
      price: json['Price'].runtimeType != double
          ? double.parse(json['Price'].toString())
          : json['Price'] ?? 0,
      origin: json['Origin'],
      destination: json['Destination'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AirlineCode': airlineCode,
      'FlightNumber': flightNumber,
      'WayType': wayType,
      'Code': code,
      'Description': description,
      'Weight': weight,
      'Currency': currency,
      'Price': price,
      'Origin': origin,
      'Destination': destination,
    };
  }
}

class MealDynamic {
  final String airlineCode;
  final String flightNumber;
  final int wayType;
  final String code;
  final String description;
  final String? airlineDescription;
  final int quantity;
  final String currency;
  final double price;
  final String origin;
  final String destination;

  MealDynamic({
    required this.airlineCode,
    required this.flightNumber,
    required this.wayType,
    required this.code,
    required this.description,
    required this.airlineDescription,
    required this.quantity,
    required this.currency,
    required this.price,
    required this.origin,
    required this.destination,
  });

  factory MealDynamic.fromJson(Map<String, dynamic> json) {
    return MealDynamic(
      airlineCode: json['AirlineCode'] ?? "",
      flightNumber: json['FlightNumber'] ?? "",
      wayType: json['WayType'] ?? 0,
      code: json['Code'] ?? "",
      description: json['Description'].toString() ?? "",
      airlineDescription: json['AirlineDescription'] ?? "",
      quantity: json['Quantity'] ?? 0,
      currency: json['Currency'] ?? "",
      price: json['Price'] != null
          ? json['Price'].runtimeType != double
              ? double.parse(json['Price'].toString())
              : json['Price'] ?? 0
          : 0,
      origin: json['Origin'] ?? "",
      destination: json['Destination'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AirlineCode': airlineCode,
      'FlightNumber': flightNumber,
      'WayType': wayType,
      'Code': code,
      'Description': description,
      'AirlineDescription': airlineDescription,
      'Quantity': quantity,
      'Currency': currency,
      'Price': price,
      'Origin': origin,
      'Destination': destination,
    };
  }
}

class SeatDynamic {
  final List<SegmentSeat> segmentSeat;

  SeatDynamic({required this.segmentSeat});

  factory SeatDynamic.fromJson(Map<String, dynamic> json) {
    var segmentSeatList = json['SegmentSeat'] as List;
    return SeatDynamic(
      segmentSeat:
          segmentSeatList.map((item) => SegmentSeat.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SegmentSeat': segmentSeat.map((item) => item.toJson()).toList(),
    };
  }
}

class SegmentSeat {
  final List<RowSeats> rowSeats;

  SegmentSeat({required this.rowSeats});

  factory SegmentSeat.fromJson(Map<String, dynamic> json) {
    var rowSeatsList = json['RowSeats'] as List;
    return SegmentSeat(
      rowSeats: rowSeatsList.map((item) => RowSeats.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RowSeats': rowSeats.map((item) => item.toJson()).toList(),
    };
  }
}

class RowSeats {
  final List<Seat> seats;

  RowSeats({required this.seats});

  factory RowSeats.fromJson(Map<String, dynamic> json) {
    var seatsList = json['Seats'] as List;
    return RowSeats(
      seats: seatsList.map((item) => Seat.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Seats': seats.map((item) => item.toJson()).toList(),
    };
  }
}

class Seat {
  final String airlineCode;
  final String flightNumber;
  final String craftType;
  final String origin;
  final String destination;
  final int availablityType;
  final int description;
  final String code;
  final String rowNo;
  final String? seatNo;
  final int seatType;
  final int seatWayType;
  final int compartment;
  final int deck;
  final String currency;
  final double price;

  Seat({
    required this.airlineCode,
    required this.flightNumber,
    required this.craftType,
    required this.origin,
    required this.destination,
    required this.availablityType,
    required this.description,
    required this.code,
    required this.rowNo,
    required this.seatNo,
    required this.seatType,
    required this.seatWayType,
    required this.compartment,
    required this.deck,
    required this.currency,
    required this.price,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      airlineCode: json['AirlineCode'],
      flightNumber: json['FlightNumber'],
      craftType: json['CraftType'] ?? "",
      origin: json['Origin'],
      destination: json['Destination'],
      availablityType: json['AvailablityType'],
      description: json['Description'],
      code: json['Code'],
      rowNo: json['RowNo'],
      seatNo: json['SeatNo'],
      seatType: json['SeatType'],
      seatWayType: json['SeatWayType'],
      compartment: json['Compartment'],
      deck: json['Deck'],
      currency: json['Currency'],
      price: json['Price'].runtimeType != double
          ? double.parse(json['Price'].toString())
          : json['Price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AirlineCode': airlineCode,
      'FlightNumber': flightNumber,
      'CraftType': craftType,
      'Origin': origin,
      'Destination': destination,
      'AvailablityType': availablityType,
      'Description': description,
      'Code': code,
      'RowNo': rowNo,
      'SeatNo': seatNo,
      'SeatType': seatType,
      'SeatWayType': seatWayType,
      'Compartment': compartment,
      'Deck': deck,
      'Currency': currency,
      'Price': price,
    };
  }
}
