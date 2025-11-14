BookingHistory bookingHistoryFromJson(Map<String, dynamic> json) =>
    BookingHistory.fromJson(json);

class BookingHistory {
  BookingHistory({
    required this.statusCode,
    required this.data,
  });

  late final String statusCode;
  late final List<Data> data;

  BookingHistory.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = List.from(json['data'] ?? {}).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.appReference,
    required this.originAirport,
    required this.originCityName,
    required this.destinationAirport,
    required this.destinationCityName,
    required this.totalFare,
    required this.originalFare,
    required this.bookingId,
    required this.status,
    required this.pnr,
    required this.gdspnr,
    required this.passengerDetails,
    required this.journeyList,
    this.TraceId,
    this.IndexId,
    required this.price,
    required this.passengerBreakup,
    required this.documentType,
    required this.documentNumber,
    required this.checkinAdult,
    required this.cabinAdult,
    required this.reissueCharge,
    required this.totalpassengers,
    required this.cancellationCharge,
    required this.travelDate,
    required this.returnDate,
    required this.commisionPercentageAmount,
    required this.commissionAmt,
    required this.serviceTax,
    required this.createdAt,
    required this.updatedAt,
    required this.invoiceNo,
    required this.roleId,
    required this.userId,
    required this.markup,
    required this.customerStatus,
    required this.convenienceFee,
  });

  late final int id;
  late final String appReference;
  late final String originAirport;
  late final String originCityName;
  late final String destinationAirport;
  late final String destinationCityName;
  late final double? totalFare;
  late final double? originalFare;
  late final int? bookingId;
  late final String status;
  late final String pnr;
  late final String gdspnr;
  late final List<PassengerDetails> passengerDetails;
  late final List<JourneyList> journeyList;
  late final Null TraceId;
  late final Null IndexId;
  late final Price? price;
  late final List<PassengerBreakup>? passengerBreakup;
  late final String documentType;
  late final String documentNumber;
  late final String checkinAdult;
  late final String cabinAdult;
  late final int reissueCharge;
  late final int totalpassengers;
  late final int cancellationCharge;
  late final String travelDate;
  late final String returnDate;
  late final double commisionPercentageAmount;
  late final double commissionAmt;
  late final double serviceTax;
  late final String createdAt;
  late final String updatedAt;
  late final int invoiceNo;
  late final int roleId;
  late final int userId;
  late final double markup;
  late final String customerStatus;
  late final int convenienceFee;
  late final String verifystatus;
  late final String cancel_description;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    appReference = json['app_reference'] ?? '';
    originAirport = json['originAirport'] ?? '';
    originCityName = json['originCityName'] ?? '';
    destinationAirport = json['destinationAirport'] ?? '';
    destinationCityName = json['destinationCityName'] ?? '';
    totalFare = json['totalFare']?.toDouble();
    originalFare = json['originalFare']?.toDouble();
    bookingId = int.tryParse(json['booking_id']?.toString() ?? '0');
    status = json['status'] ?? '';
    pnr = json['pnr'] ?? '';
    gdspnr = json['gdspnr'] ?? '';
    passengerDetails = (json['passenger_details'] is List)
        ? (json['passenger_details'] as List)
            .map((e) => PassengerDetails.fromJson(e))
            .toList()
        : [];

    List<JourneyList> journeyListTemp = <JourneyList>[];
    if (json['journey_list'] != null) {
      if (json['journey_list'] is List) {
        journeyListTemp = (json['journey_list'] as List)
            .map((e) => JourneyList.fromJson(e))
            .toList();
      } else if (json['journey_list'] is Map) {
        journeyListTemp = [JourneyList.fromJson(json['journey_list'])];
      }
    }
    journeyList = journeyListTemp;

    TraceId = null;
    IndexId = null;
    price = json['price'] is Map<String, dynamic>
        ? Price.fromJson(json['price'])
        : null;
    // passengerBreakup = json['passenger_breakup'] != null
    //     ? (json['passenger_breakup'] as List)
    //         .map((e) => PassengerBreakup.fromJson(e))
    //         .toList()
    //     : null;
    documentType = json['document_type'] ?? '';
    documentNumber = json['document_number'] ?? '';
    checkinAdult = json['checkin_adult']?.toString() ?? '';
    cabinAdult = json['cabin_adult']?.toString() ?? '';
    reissueCharge =
        int.tryParse(json['reissue_charge']?.toString() ?? '0') ?? 0;
    totalpassengers = json['totalpassengers'] ?? 0;
    cancellationCharge =
        int.tryParse(json['cancellation_charge']?.toString() ?? '0') ?? 0;
    travelDate = json['travel_date'] ?? '';
    returnDate = json['return_date'] ?? '';
    commisionPercentageAmount =
        (json['commision_percentage_amount'] as num?)?.toDouble() ?? 0.0;
    commissionAmt = (json['commission_amt'] as num?)?.toDouble() ?? 0.0;
    serviceTax = (json['service_tax'] as num?)?.toDouble() ?? 0.0;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    invoiceNo = json['invoiceNo'] ?? 0;
    roleId = json['role_id'] ?? 0;
    userId = json['user_id'] ?? 0;
    markup = (json['markup'] as num?)?.toDouble() ?? 0.0;
    customerStatus = json['customer_status'] ?? '';
    convenienceFee = json['convenience_fee'] ?? 0;
    verifystatus = json['verifystatus'] ?? '';
    cancel_description = json['cancel_description'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['app_reference'] = appReference;
    _data['originAirport'] = originAirport;
    _data['originCityName'] = originCityName;
    _data['destinationAirport'] = destinationAirport;
    _data['destinationCityName'] = destinationCityName;
    _data['totalFare'] = totalFare;
    _data['originalFare'] = originalFare;
    _data['booking_id'] = bookingId;
    _data['status'] = status;
    _data['pnr'] = pnr;
    _data['gdspnr'] = gdspnr;
    _data['passenger_details'] =
        passengerDetails.map((e) => e.toJson()).toList();
    _data['journey_list'] = journeyList.map((e) => e.toJson()).toList();
    _data['Trace_Id'] = TraceId;
    _data['Index_Id'] = IndexId;
    _data['price'] = price?.toJson();
    _data['passenger_breakup'] =
        passengerBreakup?.map((e) => e.toJson()).toList();
    _data['document_type'] = documentType;
    _data['document_number'] = documentNumber;
    _data['checkin_adult'] = checkinAdult;
    _data['cabin_adult'] = cabinAdult;
    _data['reissue_charge'] = reissueCharge;
    _data['totalpassengers'] = totalpassengers;
    _data['cancellation_charge'] = cancellationCharge;
    _data['travel_date'] = travelDate;
    _data['return_date'] = returnDate;
    _data['commision_percentage_amount'] = commisionPercentageAmount;
    _data['commission_amt'] = commissionAmt;
    _data['service_tax'] = serviceTax;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['invoiceNo'] = invoiceNo;
    _data['role_id'] = roleId;
    _data['user_id'] = userId;
    _data['markup'] = markup;
    _data['customer_status'] = customerStatus;
    _data['convenience_fee'] = convenienceFee;
    _data['verifystatus'] = verifystatus;
    _data['cancel_description'] = cancel_description;
    return _data;
  }
}

class JourneyList {
  JourneyList({
    required this.arrival,
    required this.baggage,
    required this.depature,
    required this.duration,
    required this.noofstop,
    required this.toCityName,
    required this.arrivalTime,
    required this.layOverTime,
    required this.cabinBaggage,
    required this.depatureTime,
    required this.flightNumber,
    required this.fromCityName,
    required this.operatorCode,
    required this.operatorName,
    required this.durationTime,
    required this.toAirportCode,
    required this.toAirportName,
    required this.fromAirportCode,
    required this.fromAirportName,
  });

  late final String arrival;
  late final String baggage;
  late final String depature;
  late final String duration;
  late final int noofstop;
  late final String toCityName;
  late final String arrivalTime;
  late final String layOverTime;
  late final String cabinBaggage;
  late final String depatureTime;
  late final String flightNumber;
  late final String fromCityName;
  late final String operatorCode;
  late final String operatorName;
  late final String durationTime;
  late final String toAirportCode;
  late final String toAirportName;
  late final String fromAirportCode;
  late final String fromAirportName;

  JourneyList.fromJson(Map<String, dynamic> json) {
    arrival = json['Arrival'] ?? '';
    baggage = json['Baggage'] ?? '';
    depature = json['Depature'] ?? '';
    duration = json['duration']?.toString() ?? '';
    noofstop = json['noofstop'] ?? 0;
    toCityName = json['ToCityName'] ?? '';
    arrivalTime = json['ArrivalTime'] ?? '';
    layOverTime = json['LayOverTime'] ?? '';
    cabinBaggage = json['CabinBaggage'] ?? '';
    depatureTime = json['DepatureTime'] ?? '';
    flightNumber = json['FlightNumber'] ?? '';
    fromCityName = json['FromCityName'] ?? '';
    operatorCode = json['OperatorCode'] ?? '';
    operatorName = json['OperatorName'] ?? '';
    durationTime = json['durationTime'] ?? '';
    toAirportCode = json['ToAirportCode'] ?? '';
    toAirportName = json['ToAirportName'] ?? '';
    fromAirportCode = json['FromAirportCode'] ?? '';
    fromAirportName = json['FromAirportName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Arrival'] = arrival;
    _data['Baggage'] = baggage;
    _data['Depature'] = depature;
    _data['duration'] = duration;
    _data['noofstop'] = noofstop;
    _data['ToCityName'] = toCityName;
    _data['ArrivalTime'] = arrivalTime;
    _data['LayOverTime'] = layOverTime;
    _data['CabinBaggage'] = cabinBaggage;
    _data['DepatureTime'] = depatureTime;
    _data['FlightNumber'] = flightNumber;
    _data['FromCityName'] = fromCityName;
    _data['OperatorCode'] = operatorCode;
    _data['OperatorName'] = operatorName;
    _data['durationTime'] = durationTime;
    _data['ToAirportCode'] = toAirportCode;
    _data['ToAirportName'] = toAirportName;
    _data['FromAirportCode'] = fromAirportCode;
    _data['FromAirportName'] = fromAirportName;
    return _data;
  }
}

class PassengerDetails {
  PassengerDetails({
    required this.PAN,
    required this.Ssr,
    required this.City,
    required this.farePrice,
    required this.Email,
    required this.PaxId,
    required this.Title,
    required this.Gender,
    required this.ticket,
    required this.baggage,
    required this.PaxType,
    required this.FFNumber,
    required this.LastName,
    required this.ContactNo,
    required this.FirstName,
    required this.GSTNumber,
    required this.IsLeadPax,
    required this.PassportNo,
    required this.CountryCode,
    required this.CountryName,
    required this.DateOfBirth,
    required this.Nationality,
    required this.AddressLine1,
    required this.FFAirlineCode,
    required this.IsPANRequired,
    required this.barcodeDetails,
    required this.GSTCompanyName,
    required this.PassportExpiry,
    required this.documentDetails,
    required this.GSTCompanyEmail,
    this.GuardianDetails,
    required this.GSTCompanyAddress,
    required this.IsPassportRequired,
    required this.segmentAdditionalInfo,
    required this.GSTCompanyContactNumber,
  });

  late final String PAN;
  late final List<dynamic> Ssr;
  late final String City;
  late final Fare farePrice;
  late final String Email;
  late final int PaxId;
  late final String Title;
  late final int Gender;
  late final Ticket ticket;
  late final List<Baggage> baggage;
  late final int PaxType;
  late final String FFNumber;
  late final String LastName;
  late final String ContactNo;
  late final String FirstName;
  late final String GSTNumber;
  late final bool IsLeadPax;
  late final String PassportNo;
  late final String CountryCode;
  late final String CountryName;
  late final String DateOfBirth;
  late final String Nationality;
  late final String AddressLine1;
  late final String FFAirlineCode;
  late final bool IsPANRequired;
  late final BarcodeDetails barcodeDetails;
  late final String GSTCompanyName;
  late final String PassportExpiry;
  late final List<DocumentDetails> documentDetails;
  late final String GSTCompanyEmail;
  late final Null GuardianDetails;
  late final String GSTCompanyAddress;
  late final bool IsPassportRequired;
  late final List<SegmentAdditionalInfo> segmentAdditionalInfo;
  late final String GSTCompanyContactNumber;

  PassengerDetails.fromJson(Map<String, dynamic> json) {
    PAN = json['PAN'] ?? '';
    Ssr = List.castFrom<dynamic, dynamic>(json['Ssr'] ?? []);
    City = json['City'] ?? '';
    farePrice = Fare.fromJson(json['Fare'] ?? {});
    Email = json['Email'] ?? '';
    PaxId = json['PaxId'] ?? 0;
    Title = json['Title'] ?? '';
    Gender = json['Gender'] ?? 0;
    ticket = Ticket.fromJson(json['Ticket'] ?? {});
    baggage = List.from(json['Baggage'] ?? [])
        .map((e) => Baggage.fromJson(e))
        .toList();
    PaxType = json['PaxType'] ?? 0;
    FFNumber = json['FFNumber'] ?? "";
    LastName = json['LastName'] ?? '';
    ContactNo = json['ContactNo'] ?? '';
    FirstName = json['FirstName'] ?? '';
    GSTNumber = json['GSTNumber'] ?? '';
    IsLeadPax = json['IsLeadPax'] ?? false;
    PassportNo = json['PassportNo'] ?? '';
    CountryCode = json['CountryCode'] ?? '';
    CountryName = json['CountryName'] ?? '';
    DateOfBirth = json['DateOfBirth'] ?? '';
    Nationality = json['Nationality'] ?? '';
    AddressLine1 = json['AddressLine1'] ?? '';
    FFAirlineCode = json['FFAirlineCode'] ?? "";
    IsPANRequired = json['IsPANRequired'] ?? false;
    barcodeDetails = BarcodeDetails.fromJson(json['BarcodeDetails'] ?? {});
    GSTCompanyName = json['GSTCompanyName'] ?? '';
    PassportExpiry = json['PassportExpiry'] ?? "";
    documentDetails = List.from(json['DocumentDetails'] ?? [])
        .map((e) => DocumentDetails.fromJson(e))
        .toList();
    GSTCompanyEmail = json['GSTCompanyEmail'] ?? '';
    GuardianDetails = null;
    GSTCompanyAddress = json['GSTCompanyAddress'] ?? '';
    IsPassportRequired = json['IsPassportRequired'] ?? false;
    segmentAdditionalInfo = List.from(json['SegmentAdditionalInfo'] ?? [])
        .map((e) => SegmentAdditionalInfo.fromJson(e))
        .toList();
    GSTCompanyContactNumber = json['GSTCompanyContactNumber'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['PAN'] = PAN;
    _data['Ssr'] = Ssr;
    _data['City'] = City;
    _data['Fare'] = farePrice.toJson();
    _data['Email'] = Email;
    _data['PaxId'] = PaxId;
    _data['Title'] = Title;
    _data['Gender'] = Gender;
    _data['Ticket'] = ticket.toJson();
    _data['Baggage'] = baggage.map((e) => e.toJson()).toList();
    _data['PaxType'] = PaxType;
    _data['FFNumber'] = FFNumber;
    _data['LastName'] = LastName;
    _data['ContactNo'] = ContactNo;
    _data['FirstName'] = FirstName;
    _data['GSTNumber'] = GSTNumber;
    _data['IsLeadPax'] = IsLeadPax;
    _data['PassportNo'] = PassportNo;
    _data['CountryCode'] = CountryCode;
    _data['CountryName'] = CountryName;
    _data['DateOfBirth'] = DateOfBirth;
    _data['Nationality'] = Nationality;
    _data['AddressLine1'] = AddressLine1;
    _data['FFAirlineCode'] = FFAirlineCode;
    _data['IsPANRequired'] = IsPANRequired;
    _data['BarcodeDetails'] = barcodeDetails.toJson();
    _data['GSTCompanyName'] = GSTCompanyName;
    _data['PassportExpiry'] = PassportExpiry;
    _data['DocumentDetails'] = documentDetails.map((e) => e.toJson()).toList();
    _data['GSTCompanyEmail'] = GSTCompanyEmail;
    _data['GuardianDetails'] = GuardianDetails;
    _data['GSTCompanyAddress'] = GSTCompanyAddress;
    _data['IsPassportRequired'] = IsPassportRequired;
    _data['SegmentAdditionalInfo'] =
        segmentAdditionalInfo.map((e) => e.toJson()).toList();
    _data['GSTCompanyContactNumber'] = GSTCompanyContactNumber;
    return _data;
  }
}

class Fare {
  Fare({
    required this.Tax,
    required this.YQTax,
    required this.BaseFare,
    required this.chargeBU,
    required this.Currency,
    required this.Discount,
    required this.PGCharge,
    required this.TdsOnPLB,
    required this.PLBEarned,
    required this.ServiceFee,
    required this.taxBreakup,
    required this.OfferedFare,
    required this.OtherCharges,
    required this.PublishedFare,
    required this.TdsOnIncentive,
    required this.IncentiveEarned,
    required this.TdsOnCommission,
    required this.CommissionEarned,
    required this.TotalMealCharges,
    required this.TotalSeatCharges,
    required this.AdditionalTxnFeePub,
    required this.TotalBaggageCharges,
    required this.AdditionalTxnFeeOfrd,
    required this.ServiceFeeDisplayType,
    required this.TotalSpecialServiceCharges,
  });

  late final int Tax;
  late final int YQTax;
  late final int BaseFare;
  late final List<ChargeBU> chargeBU;
  late final String Currency;
  late final int Discount;
  late final int PGCharge;
  late final double TdsOnPLB;
  late final double PLBEarned;
  late final int ServiceFee;
  late final List<TaxBreakup> taxBreakup;
  late final double OfferedFare;
  late final double OtherCharges;
  late final double PublishedFare;
  late final double TdsOnIncentive;
  late final double IncentiveEarned;
  late final double TdsOnCommission;
  late final double CommissionEarned;
  late final int TotalMealCharges;
  late final int TotalSeatCharges;
  late final int AdditionalTxnFeePub;
  late final int TotalBaggageCharges;
  late final int AdditionalTxnFeeOfrd;
  late final int ServiceFeeDisplayType;
  late final int TotalSpecialServiceCharges;

  Fare.fromJson(Map<String, dynamic> json) {
    Tax = (json['Tax'] as num?)?.toInt() ?? 0;
    YQTax = (json['YQTax'] as num?)?.toInt() ?? 0;
    BaseFare = (json['BaseFare'] as num?)?.toInt() ?? 0;
    chargeBU = List.from(json['ChargeBU'] ?? [])
        .map((e) => ChargeBU.fromJson(e))
        .toList();
    Currency = json['Currency'] ?? '';
    Discount = (json['Discount'] as num?)?.toInt() ?? 0;
    PGCharge = (json['PGCharge'] as num?)?.toInt() ?? 0;
    TdsOnPLB = (json['TdsOnPLB'] as num?)?.toDouble() ?? 0.0;
    PLBEarned = (json['PLBEarned'] as num?)?.toDouble() ?? 0.0;
    ServiceFee = (json['ServiceFee'] as num?)?.toInt() ?? 0;
    taxBreakup = List.from(json['TaxBreakup'] ?? [])
        .map((e) => TaxBreakup.fromJson(e))
        .toList();
    OfferedFare = (json['OfferedFare'] as num?)?.toDouble() ?? 0.0;
    OtherCharges = (json['OtherCharges'] as num?)?.toDouble() ?? 0.0;
    PublishedFare = (json['PublishedFare'] as num?)?.toDouble() ?? 0.0;
    TdsOnIncentive = (json['TdsOnIncentive'] as num?)?.toDouble() ?? 0.0;
    IncentiveEarned = (json['IncentiveEarned'] as num?)?.toDouble() ?? 0.0;
    TdsOnCommission = (json['TdsOnCommission'] as num?)?.toDouble() ?? 0.0;
    CommissionEarned = (json['CommissionEarned'] as num?)?.toDouble() ?? 0.0;
    TotalMealCharges = (json['TotalMealCharges'] as num?)?.toInt() ?? 0;
    TotalSeatCharges = (json['TotalSeatCharges'] as num?)?.toInt() ?? 0;
    AdditionalTxnFeePub = (json['AdditionalTxnFeePub'] as num?)?.toInt() ?? 0;
    TotalBaggageCharges = (json['TotalBaggageCharges'] as num?)?.toInt() ?? 0;
    AdditionalTxnFeeOfrd = (json['AdditionalTxnFeeOfrd'] as num?)?.toInt() ?? 0;
    ServiceFeeDisplayType =
        (json['ServiceFeeDisplayType'] as num?)?.toInt() ?? 0;
    TotalSpecialServiceCharges =
        (json['TotalSpecialServiceCharges'] as num?)?.toInt() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Tax'] = Tax;
    _data['YQTax'] = YQTax;
    _data['BaseFare'] = BaseFare;
    _data['ChargeBU'] = chargeBU.map((e) => e.toJson()).toList();
    _data['Currency'] = Currency;
    _data['Discount'] = Discount;
    _data['PGCharge'] = PGCharge;
    _data['TdsOnPLB'] = TdsOnPLB;
    _data['PLBEarned'] = PLBEarned;
    _data['ServiceFee'] = ServiceFee;
    _data['TaxBreakup'] = taxBreakup.map((e) => e.toJson()).toList();
    _data['OfferedFare'] = OfferedFare;
    _data['OtherCharges'] = OtherCharges;
    _data['PublishedFare'] = PublishedFare;
    _data['TdsOnIncentive'] = TdsOnIncentive;
    _data['IncentiveEarned'] = IncentiveEarned;
    _data['TdsOnCommission'] = TdsOnCommission;
    _data['CommissionEarned'] = CommissionEarned;
    _data['TotalMealCharges'] = TotalMealCharges;
    _data['TotalSeatCharges'] = TotalSeatCharges;
    _data['AdditionalTxnFeePub'] = AdditionalTxnFeePub;
    _data['TotalBaggageCharges'] = TotalBaggageCharges;
    _data['AdditionalTxnFeeOfrd'] = AdditionalTxnFeeOfrd;
    _data['ServiceFeeDisplayType'] = ServiceFeeDisplayType;
    _data['TotalSpecialServiceCharges'] = TotalSpecialServiceCharges;
    return _data;
  }
}

class ChargeBU {
  ChargeBU({
    required this.key,
    required this.value,
  });

  late final String key;
  late final int? value;

  ChargeBU.fromJson(Map<String, dynamic> json) {
    key = json['key'] ?? '';
    value = (json['value'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['key'] = key;
    _data['value'] = value;
    return _data;
  }
}

class TaxBreakup {
  TaxBreakup({
    required this.key,
    required this.value,
  });

  late final String key;
  late final int value;

  TaxBreakup.fromJson(Map<String, dynamic> json) {
    key = json['key'] ?? '';
    value = (json['value'] as num?)?.toInt() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['key'] = key;
    _data['value'] = value;
    return _data;
  }
}

class Ticket {
  Ticket({
    required this.Status,
    required this.Remarks,
    required this.TicketId,
    required this.IssueDate,
    required this.TicketType,
    required this.TicketNumber,
    required this.ConjunctionNumber,
    required this.ValidatingAirline,
    required this.ServiceFeeDisplayType,
  });

  late final String Status;
  late final String Remarks;
  late final int TicketId;
  late final String IssueDate;
  late final String TicketType;
  late final String TicketNumber;
  late final String ConjunctionNumber;
  late final String ValidatingAirline;
  late final String ServiceFeeDisplayType;

  Ticket.fromJson(Map<String, dynamic> json) {
    Status = json['Status'] ?? '';
    Remarks = json['Remarks'] ?? '';
    TicketId = json['TicketId'] ?? 0;
    IssueDate = json['IssueDate'] ?? '';
    TicketType = json['TicketType'] ?? '';
    TicketNumber = json['TicketNumber'] ?? '';
    ConjunctionNumber = json['ConjunctionNumber'] ?? '';
    ValidatingAirline = json['ValidatingAirline'] ?? '';
    ServiceFeeDisplayType = json['ServiceFeeDisplayType'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Status'] = Status;
    _data['Remarks'] = Remarks;
    _data['TicketId'] = TicketId;
    _data['IssueDate'] = IssueDate;
    _data['TicketType'] = TicketType;
    _data['TicketNumber'] = TicketNumber;
    _data['ConjunctionNumber'] = ConjunctionNumber;
    _data['ValidatingAirline'] = ValidatingAirline;
    _data['ServiceFeeDisplayType'] = ServiceFeeDisplayType;
    return _data;
  }
}

class Baggage {
  Baggage({
    required this.Code,
    required this.Price,
    required this.Origin,
    required this.Weight,
    required this.WayType,
    required this.Currency,
    required this.AirlineCode,
    required this.Description,
    required this.Destination,
    required this.FlightNumber,
  });

  late final String Code;
  late final int Price;
  late final String Origin;
  late final int Weight;
  late final int WayType;
  late final String Currency;
  late final String AirlineCode;
  late final int Description;
  late final String Destination;
  late final String FlightNumber;

  Baggage.fromJson(Map<String, dynamic> json) {
    Code = json['Code'] ?? '';
    Price = (json['Price'] as num?)?.toInt() ?? 0;
    Origin = json['Origin'] ?? '';
    Weight = json['Weight'] ?? 0;
    WayType = json['WayType'] ?? 0;
    Currency = json['Currency'] ?? '';
    AirlineCode = json['AirlineCode'] ?? '';
    Description = json['Description'] ?? 0;
    Destination = json['Destination'] ?? '';
    FlightNumber = json['FlightNumber'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Code'] = Code;
    _data['Price'] = Price;
    _data['Origin'] = Origin;
    _data['Weight'] = Weight;
    _data['WayType'] = WayType;
    _data['Currency'] = Currency;
    _data['AirlineCode'] = AirlineCode;
    _data['Description'] = Description;
    _data['Destination'] = Destination;
    _data['FlightNumber'] = FlightNumber;
    return _data;
  }
}

class BarcodeDetails {
  BarcodeDetails({
    required this.Id,
    required this.barcode,
  });

  late final int Id;
  late final List<Barcode> barcode;

  BarcodeDetails.fromJson(Map<String, dynamic> json) {
    Id = json['Id'] ?? 0;
    barcode = List.from(json['Barcode'] ?? [])
        .map((e) => Barcode.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Id'] = Id;
    _data['Barcode'] = barcode.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Barcode {
  Barcode({
    required this.Index,
    required this.Format,
    required this.Content,
    required this.JourneyWayType,
    this.BarCodeInBase64,
  });

  late final int Index;
  late final String Format;
  late final String Content;
  late final int JourneyWayType;
  late final Null BarCodeInBase64;

  Barcode.fromJson(Map<String, dynamic> json) {
    Index = json['Index'] ?? 0;
    Format = json['Format'] ?? '';
    Content = json['Content'] ?? '';
    JourneyWayType = json['JourneyWayType'] ?? 0;
    BarCodeInBase64 = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Index'] = Index;
    _data['Format'] = Format;
    _data['Content'] = Content;
    _data['JourneyWayType'] = JourneyWayType;
    _data['BarCodeInBase64'] = BarCodeInBase64;
    return _data;
  }
}

class DocumentDetails {
  DocumentDetails({
    required this.PaxId,
    required this.DocumentNumber,
    required this.DocumentTypeId,
    required this.ResultFareType,
    required this.DocumentExpiryDate,
  });

  late final int PaxId;
  late final String DocumentNumber;
  late final String DocumentTypeId;
  late final int ResultFareType;
  late final String DocumentExpiryDate;

  DocumentDetails.fromJson(Map<String, dynamic> json) {
    PaxId = json['PaxId'] ?? 0;
    DocumentNumber = json['DocumentNumber'] ?? '';
    DocumentTypeId = json['DocumentTypeId'] ?? '';
    ResultFareType = json['ResultFareType'] ?? 0;
    DocumentExpiryDate = json['DocumentExpiryDate'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['PaxId'] = PaxId;
    _data['DocumentNumber'] = DocumentNumber;
    _data['DocumentTypeId'] = DocumentTypeId;
    _data['ResultFareType'] = ResultFareType;
    _data['DocumentExpiryDate'] = DocumentExpiryDate;
    return _data;
  }
}

class SegmentAdditionalInfo {
  SegmentAdditionalInfo({
    required this.NVA,
    required this.NVB,
    required this.Meal,
    required this.Seat,
    required this.Baggage,
    required this.FareBasis,
    required this.CabinBaggage,
    required this.SpecialService,
  });

  late final String NVA;
  late final String NVB;
  late final String Meal;
  late final String Seat;
  late final String Baggage;
  late final String FareBasis;
  late final String CabinBaggage;
  late final String SpecialService;

  SegmentAdditionalInfo.fromJson(Map<String, dynamic> json) {
    NVA = json['NVA'] ?? '';
    NVB = json['NVB'] ?? '';
    Meal = json['Meal'] ?? '';
    Seat = json['Seat'] ?? '';
    Baggage = json['Baggage'] ?? '';
    FareBasis = json['FareBasis'] ?? '';
    CabinBaggage = json['CabinBaggage'] ?? '';
    SpecialService = json['SpecialService'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['NVA'] = NVA;
    _data['NVB'] = NVB;
    _data['Meal'] = Meal;
    _data['Seat'] = Seat;
    _data['Baggage'] = Baggage;
    _data['FareBasis'] = FareBasis;
    _data['CabinBaggage'] = CabinBaggage;
    _data['SpecialService'] = SpecialService;
    return _data;
  }
}

class Price {
  Price({
    required this.Tax,
    required this.YQTax,
    required this.BaseFare,
    required this.chargeBU,
    required this.Currency,
    required this.Discount,
    required this.PGCharge,
    required this.TdsOnPLB,
    required this.PLBEarned,
    required this.ServiceFee,
    required this.taxBreakup,
    required this.OfferedFare,
    required this.OtherCharges,
    required this.PublishedFare,
    required this.TdsOnIncentive,
    required this.IncentiveEarned,
    required this.TdsOnCommission,
    required this.CommissionEarned,
    required this.TotalMealCharges,
    required this.TotalSeatCharges,
    required this.AdditionalTxnFeePub,
    required this.TotalBaggageCharges,
    required this.AdditionalTxnFeeOfrd,
    required this.ServiceFeeDisplayType,
    required this.TotalSpecialServiceCharges,
  });

  late final int Tax;
  late final int YQTax;
  late final int BaseFare;
  late final List<ChargeBU> chargeBU;
  late final String Currency;
  late final int Discount;
  late final int PGCharge;
  late final double TdsOnPLB;
  late final double PLBEarned;
  late final int ServiceFee;
  late final List<TaxBreakup> taxBreakup;
  late final double OfferedFare;
  late final double OtherCharges;
  late final double PublishedFare;
  late final double TdsOnIncentive;
  late final double IncentiveEarned;
  late final double TdsOnCommission;
  late final double CommissionEarned;
  late final int TotalMealCharges;
  late final int TotalSeatCharges;
  late final int AdditionalTxnFeePub;
  late final int TotalBaggageCharges;
  late final int AdditionalTxnFeeOfrd;
  late final int ServiceFeeDisplayType;
  late final int TotalSpecialServiceCharges;

  Price.fromJson(Map<String, dynamic> json) {
    Tax = (json['Tax'] as num?)?.toInt() ?? 0;
    YQTax = (json['YQTax'] as num?)?.toInt() ?? 0;
    BaseFare = (json['BaseFare'] as num?)?.toInt() ?? 0;

    List<ChargeBU> chargeBUTemp = <ChargeBU>[];
    if (json['ChargeBU'] != null) {
      if (json['ChargeBU'] is List) {
        chargeBUTemp = (json['ChargeBU'] as List)
            .map((e) => ChargeBU.fromJson(e))
            .toList();
      } else if (json['ChargeBU'] is Map) {
        chargeBUTemp = [ChargeBU.fromJson(json['ChargeBU'])];
      }
    }
    chargeBU = chargeBUTemp;

    Currency = json['Currency'] ?? "";
    Discount = (json['Discount'] as num?)?.toInt() ?? 0;
    PGCharge = (json['PGCharge'] as num?)?.toInt() ?? 0;
    TdsOnPLB = (json['TdsOnPLB'] as num?)?.toDouble() ?? 0.0;
    PLBEarned = (json['PLBEarned'] as num?)?.toDouble() ?? 0.0;
    ServiceFee = (json['ServiceFee'] as num?)?.toInt() ?? 0;

    List<TaxBreakup> taxBreakupTemp = <TaxBreakup>[];
    if (json['TaxBreakup'] != null) {
      if (json['TaxBreakup'] is List) {
        taxBreakupTemp = (json['TaxBreakup'] as List)
            .map((e) => TaxBreakup.fromJson(e))
            .toList();
      } else if (json['TaxBreakup'] is Map) {
        taxBreakupTemp = [TaxBreakup.fromJson(json['TaxBreakup'])];
      }
    }
    taxBreakup = taxBreakupTemp;

    OfferedFare = (json['OfferedFare'] as num?)?.toDouble() ?? 0.0;
    OtherCharges = (json['OtherCharges'] as num?)?.toDouble() ?? 0.0;
    PublishedFare = (json['PublishedFare'] as num?)?.toDouble() ?? 0.0;
    TdsOnIncentive = (json['TdsOnIncentive'] as num?)?.toDouble() ?? 0.0;
    IncentiveEarned = (json['IncentiveEarned'] as num?)?.toDouble() ?? 0.0;
    TdsOnCommission = (json['TdsOnCommission'] as num?)?.toDouble() ?? 0.0;
    CommissionEarned = (json['CommissionEarned'] as num?)?.toDouble() ?? 0.0;
    TotalMealCharges = (json['TotalMealCharges'] as num?)?.toInt() ?? 0;
    TotalSeatCharges = (json['TotalSeatCharges'] as num?)?.toInt() ?? 0;
    AdditionalTxnFeePub = (json['AdditionalTxnFeePub'] as num?)?.toInt() ?? 0;
    TotalBaggageCharges = (json['TotalBaggageCharges'] as num?)?.toInt() ?? 0;
    AdditionalTxnFeeOfrd = (json['AdditionalTxnFeeOfrd'] as num?)?.toInt() ?? 0;
    ServiceFeeDisplayType =
        (json['ServiceFeeDisplayType'] as num?)?.toInt() ?? 0;
    TotalSpecialServiceCharges =
        (json['TotalSpecialServiceCharges'] as num?)?.toInt() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Tax'] = Tax;
    _data['YQTax'] = YQTax;
    _data['BaseFare'] = BaseFare;
    _data['ChargeBU'] = chargeBU.map((e) => e.toJson()).toList();
    _data['Currency'] = Currency;
    _data['Discount'] = Discount;
    _data['PGCharge'] = PGCharge;
    _data['TdsOnPLB'] = TdsOnPLB;
    _data['PLBEarned'] = PLBEarned;
    _data['ServiceFee'] = ServiceFee;
    _data['TaxBreakup'] = taxBreakup.map((e) => e.toJson()).toList();
    _data['OfferedFare'] = OfferedFare;
    _data['OtherCharges'] = OtherCharges;
    _data['PublishedFare'] = PublishedFare;
    _data['TdsOnIncentive'] = TdsOnIncentive;
    _data['IncentiveEarned'] = IncentiveEarned;
    _data['TdsOnCommission'] = TdsOnCommission;
    _data['CommissionEarned'] = CommissionEarned;
    _data['TotalMealCharges'] = TotalMealCharges;
    _data['TotalSeatCharges'] = TotalSeatCharges;
    _data['AdditionalTxnFeePub'] = AdditionalTxnFeePub;
    _data['TotalBaggageCharges'] = TotalBaggageCharges;
    _data['AdditionalTxnFeeOfrd'] = AdditionalTxnFeeOfrd;
    _data['ServiceFeeDisplayType'] = ServiceFeeDisplayType;
    _data['TotalSpecialServiceCharges'] = TotalSpecialServiceCharges;
    return _data;
  }
}

class PassengerBreakup {
  PassengerBreakup({
    required this.key,
    required this.value,
  });

  late final String key;
  late final num value;

  PassengerBreakup.fromJson(Map<String, dynamic> json) {
    key = json['key'] ?? "";
    value = json['value'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['key'] = key;
    _data['value'] = value;
    return _data;
  }
}
