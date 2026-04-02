FlightBookingHistory flightBookingHistoryFromJson(Map<String, dynamic> json) =>
    FlightBookingHistory.fromJson(json);

class FlightBookingHistory {
  FlightBookingHistory({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  late final String statusCode;
  late final String statusMessage;
  late final BookingData data;

  FlightBookingHistory.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode']?.toString() ?? '';
    statusMessage = json['statusMessage'] as String? ?? '';
    data = BookingData.fromJson(json['data'] as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['statusMessage'] = statusMessage;
    map['data'] = data.toJson();
    return map;
  }
}

class BookingData {
  BookingData({required this.response});

  late final BookingResponse response;

  BookingData.fromJson(Map<String, dynamic> json) {
    response =
        BookingResponse.fromJson(json['Response'] as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Response'] = response.toJson();
    return map;
  }
}

class BookingResponse {
  BookingResponse({
    required this.error,
    required this.responseStatus,
    required this.traceId,
    required this.flightItinerary,
  });

  late final BookingError error;
  late final int responseStatus;
  late final String traceId;
  late final FlightItinerary flightItinerary;

  BookingResponse.fromJson(Map<String, dynamic> json) {
    error = BookingError.fromJson(json['Error'] as Map<String, dynamic>);
    responseStatus = (json['ResponseStatus'] as num?)?.toInt() ?? 0;
    traceId = json['TraceId'] as String? ?? '';
    flightItinerary = FlightItinerary.fromJson(
        json['FlightItinerary'] as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Error'] = error.toJson();
    map['ResponseStatus'] = responseStatus;
    map['TraceId'] = traceId;
    map['FlightItinerary'] = flightItinerary.toJson();
    return map;
  }
}

class BookingError {
  BookingError({
    required this.errorCode,
    required this.errorMessage,
  });

  late final int errorCode;
  late final String errorMessage;

  BookingError.fromJson(Map<String, dynamic> json) {
    errorCode = (json['ErrorCode'] as num?)?.toInt() ?? 0;
    errorMessage = json['ErrorMessage'] as String? ?? '';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ErrorCode'] = errorCode;
    map['ErrorMessage'] = errorMessage;
    return map;
  }
}

class FlightItinerary {
  FlightItinerary({
    required this.agentRemarks,
    this.commentDetails,
    required this.fareClassification,
    required this.isAutoReissuanceAllowed,
    required this.isPartialVoidAllowed,
    required this.isSeatsBooked,
    required this.issuancePcc,
    required this.journeyType,
    required this.searchCombinationType,
    required this.supplierFareClasses,
    required this.tboConfNo,
    this.tboTripID,
    required this.tripIndicator,
    required this.bookingAllowedForRoamer,
    required this.bookingId,
    required this.isCouponAppilcable,
    required this.isManual,
    required this.pnr,
    required this.isDomestic,
    required this.resultFareType,
    required this.source,
    required this.origin,
    required this.destination,
    required this.airlineCode,
    required this.lastTicketDate,
    required this.validatingAirlineCode,
    required this.airlineRemark,
    required this.isLCC,
    required this.nonRefundable,
    required this.fareType,
    this.creditNoteNo,
    required this.fare,
    this.creditNoteCreatedOn,
    required this.passengers,
    this.cancellationCharges,
    required this.segments,
    required this.fareRules,
    required this.miniFareRules,
    required this.penaltyCharges,
    required this.status,
    required this.invoices,
    required this.invoiceAmount,
    required this.invoiceNo,
    required this.invoiceStatus,
    required this.invoiceCreatedOn,
    required this.remarks,
    required this.isWebCheckInAllowed,
  });

  late final String agentRemarks;
  late final dynamic commentDetails;
  late final String fareClassification;
  late final bool isAutoReissuanceAllowed;
  late final bool isPartialVoidAllowed;
  late final bool isSeatsBooked;
  late final String issuancePcc;
  late final int journeyType;
  late final int searchCombinationType;
  late final String supplierFareClasses;
  late final String tboConfNo;
  late final dynamic tboTripID;
  late final int tripIndicator;
  late final bool bookingAllowedForRoamer;
  late final int bookingId;
  late final bool isCouponAppilcable;
  late final bool isManual;
  late final String pnr;
  late final bool isDomestic;
  late final String resultFareType;
  late final int source;
  late final String origin;
  late final String destination;
  late final String airlineCode;
  late final String lastTicketDate;
  late final String validatingAirlineCode;
  late final String airlineRemark;
  late final bool isLCC;
  late final bool nonRefundable;
  late final String fareType;
  late final dynamic creditNoteNo;
  late final FareInfo fare;
  late final dynamic creditNoteCreatedOn;
  late final List<PassengerInfo> passengers;
  late final dynamic cancellationCharges;
  late final List<SegmentInfo> segments;
  late final List<FareRule> fareRules;
  late final List<MiniFareRule> miniFareRules;
  late final PenaltyChargeInfo penaltyCharges;
  late final int status;
  late final List<InvoiceInfo> invoices;
  late final int invoiceAmount;
  late final String invoiceNo;
  late final int invoiceStatus;
  late final String invoiceCreatedOn;
  late final String remarks;
  late final bool isWebCheckInAllowed;

  FlightItinerary.fromJson(Map<String, dynamic> json) {
    agentRemarks = json['AgentRemarks'] as String? ?? '';
    commentDetails = null;
    fareClassification = json['FareClassification'] as String? ?? '';
    isAutoReissuanceAllowed = json['IsAutoReissuanceAllowed'] as bool? ?? false;
    isPartialVoidAllowed = json['IsPartialVoidAllowed'] as bool? ?? false;
    isSeatsBooked = json['IsSeatsBooked'] as bool? ?? false;
    issuancePcc = json['IssuancePcc'] as String? ?? '';
    journeyType = (json['JourneyType'] as num?)?.toInt() ?? 0;
    searchCombinationType =
        (json['SearchCombinationType'] as num?)?.toInt() ?? 0;
    supplierFareClasses = json['SupplierFareClasses'] as String? ?? '';
    tboConfNo = json['TBOConfNo'] as String? ?? '';
    tboTripID = null;
    tripIndicator = (json['TripIndicator'] as num?)?.toInt() ?? 0;
    bookingAllowedForRoamer = json['BookingAllowedForRoamer'] as bool? ?? false;
    bookingId = (json['BookingId'] as num?)?.toInt() ?? 0;
    isCouponAppilcable = json['IsCouponAppilcable'] as bool? ?? false;
    isManual = json['IsManual'] as bool? ?? false;
    pnr = json['PNR'] as String? ?? '';
    isDomestic = json['IsDomestic'] as bool? ?? false;
    resultFareType = json['ResultFareType'] as String? ?? '';
    source = (json['Source'] as num?)?.toInt() ?? 0;
    origin = json['Origin'] as String? ?? '';
    destination = json['Destination'] as String? ?? '';
    airlineCode = json['AirlineCode'] as String? ?? '';
    lastTicketDate = json['LastTicketDate'] as String? ?? '';
    validatingAirlineCode = json['ValidatingAirlineCode'] as String? ?? '';
    airlineRemark = json['AirlineRemark'] as String? ?? '';
    isLCC = json['IsLCC'] as bool? ?? false;
    nonRefundable = json['NonRefundable'] as bool? ?? false;
    fareType = json['FareType'] as String? ?? '';
    creditNoteNo = null;
    fare = FareInfo.fromJson(json['Fare'] as Map<String, dynamic>);
    creditNoteCreatedOn = null;
    passengers = json['Passenger'] != null
        ? List.from(json['Passenger'])
            .map((e) => PassengerInfo.fromJson(e))
            .toList()
        : [];
    cancellationCharges = null;
    segments = json['Segments'] != null
        ? List.from(json['Segments'])
            .map((e) => SegmentInfo.fromJson(e))
            .toList()
        : [];
    fareRules = json['FareRules'] != null
        ? List.from(json['FareRules']).map((e) => FareRule.fromJson(e)).toList()
        : [];
    miniFareRules = json['MiniFareRules'] != null
        ? List.from(json['MiniFareRules'])
            .map((e) => MiniFareRule.fromJson(e))
            .toList()
        : [];
    penaltyCharges = PenaltyChargeInfo.fromJson(
        json['PenaltyCharges'] as Map<String, dynamic>);
    status = (json['Status'] as num?)?.toInt() ?? 0;
    invoices = json['Invoice'] != null
        ? List.from(json['Invoice'])
            .map((e) => InvoiceInfo.fromJson(e))
            .toList()
        : [];
    invoiceAmount = (json['InvoiceAmount'] as num?)?.toInt() ?? 0;
    invoiceNo = json['InvoiceNo'] as String? ?? '';
    invoiceStatus = (json['InvoiceStatus'] as num?)?.toInt() ?? 0;
    invoiceCreatedOn = json['InvoiceCreatedOn'] as String? ?? '';
    remarks = json['Remarks'] as String? ?? '';
    isWebCheckInAllowed = json['IsWebCheckInAllowed'] as bool? ?? false;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AgentRemarks'] = agentRemarks;
    map['CommentDetails'] = commentDetails;
    map['FareClassification'] = fareClassification;
    map['IsAutoReissuanceAllowed'] = isAutoReissuanceAllowed;
    map['IsPartialVoidAllowed'] = isPartialVoidAllowed;
    map['IsSeatsBooked'] = isSeatsBooked;
    map['IssuancePcc'] = issuancePcc;
    map['JourneyType'] = journeyType;
    map['SearchCombinationType'] = searchCombinationType;
    map['SupplierFareClasses'] = supplierFareClasses;
    map['TBOConfNo'] = tboConfNo;
    map['TBOTripID'] = tboTripID;
    map['TripIndicator'] = tripIndicator;
    map['BookingAllowedForRoamer'] = bookingAllowedForRoamer;
    map['BookingId'] = bookingId;
    map['IsCouponAppilcable'] = isCouponAppilcable;
    map['IsManual'] = isManual;
    map['PNR'] = pnr;
    map['IsDomestic'] = isDomestic;
    map['ResultFareType'] = resultFareType;
    map['Source'] = source;
    map['Origin'] = origin;
    map['Destination'] = destination;
    map['AirlineCode'] = airlineCode;
    map['LastTicketDate'] = lastTicketDate;
    map['ValidatingAirlineCode'] = validatingAirlineCode;
    map['AirlineRemark'] = airlineRemark;
    map['IsLCC'] = isLCC;
    map['NonRefundable'] = nonRefundable;
    map['FareType'] = fareType;
    map['CreditNoteNo'] = creditNoteNo;
    map['Fare'] = fare.toJson();
    map['CreditNoteCreatedOn'] = creditNoteCreatedOn;
    map['Passenger'] = passengers.map((e) => e.toJson()).toList();
    map['CancellationCharges'] = cancellationCharges;
    map['Segments'] = segments.map((e) => e.toJson()).toList();
    map['FareRules'] = fareRules.map((e) => e.toJson()).toList();
    map['MiniFareRules'] = miniFareRules.map((e) => e.toJson()).toList();
    map['PenaltyCharges'] = penaltyCharges.toJson();
    map['Status'] = status;
    map['Invoice'] = invoices.map((e) => e.toJson()).toList();
    map['InvoiceAmount'] = invoiceAmount;
    map['InvoiceNo'] = invoiceNo;
    map['InvoiceStatus'] = invoiceStatus;
    map['InvoiceCreatedOn'] = invoiceCreatedOn;
    map['Remarks'] = remarks;
    map['IsWebCheckInAllowed'] = isWebCheckInAllowed;
    return map;
  }
}

class FareInfo {
  FareInfo({
    required this.cfarAmount,
    required this.dcfarAmount,
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
    required this.chargeBU,
    required this.discount,
    required this.publishedFare,
    required this.commissionEarned,
    required this.plbEarned,
    required this.incentiveEarned,
    required this.offeredFare,
    required this.tdsOnCommission,
    required this.tdsOnPLB,
    required this.tdsOnIncentive,
    required this.serviceFee,
    required this.totalBaggageCharges,
    required this.totalMealCharges,
    required this.totalSeatCharges,
    required this.totalSpecialServiceCharges,
  });

  late final double cfarAmount;
  late final double dcfarAmount;
  late final int serviceFeeDisplayType;
  late final String currency;
  late final double baseFare;
  late final double tax;
  late final List<TaxBreakupItem> taxBreakup;
  late final double yqTax;
  late final double additionalTxnFeeOfrd;
  late final double additionalTxnFeePub;
  late final double pgCharge;
  late final double otherCharges;
  late final List<ChargeBUItem> chargeBU;
  late final double discount;
  late final double publishedFare;
  late final double commissionEarned;
  late final double plbEarned;
  late final double incentiveEarned;
  late final double offeredFare;
  late final double tdsOnCommission;
  late final double tdsOnPLB;
  late final double tdsOnIncentive;
  late final double serviceFee;
  late final double totalBaggageCharges;
  late final double totalMealCharges;
  late final double totalSeatCharges;
  late final double totalSpecialServiceCharges;

  FareInfo.fromJson(Map<String, dynamic> json) {
    cfarAmount = (json['CFARAmount'] as num?)?.toDouble() ?? 0.0;
    dcfarAmount = (json['DCFARAmount'] as num?)?.toDouble() ?? 0.0;
    serviceFeeDisplayType =
        (json['ServiceFeeDisplayType'] as num?)?.toInt() ?? 0;
    currency = json['Currency'] as String? ?? '';
    baseFare = (json['BaseFare'] as num?)?.toDouble() ?? 0.0;
    tax = (json['Tax'] as num?)?.toDouble() ?? 0.0;
    taxBreakup = json['TaxBreakup'] != null
        ? List.from(json['TaxBreakup'])
            .map((e) => TaxBreakupItem.fromJson(e))
            .toList()
        : [];
    yqTax = (json['YQTax'] as num?)?.toDouble() ?? 0.0;
    additionalTxnFeeOfrd =
        (json['AdditionalTxnFeeOfrd'] as num?)?.toDouble() ?? 0.0;
    additionalTxnFeePub =
        (json['AdditionalTxnFeePub'] as num?)?.toDouble() ?? 0.0;
    pgCharge = (json['PGCharge'] as num?)?.toDouble() ?? 0.0;
    otherCharges = (json['OtherCharges'] as num?)?.toDouble() ?? 0.0;
    chargeBU = json['ChargeBU'] != null
        ? List.from(json['ChargeBU'])
            .map((e) => ChargeBUItem.fromJson(e))
            .toList()
        : [];
    discount = (json['Discount'] as num?)?.toDouble() ?? 0.0;
    publishedFare = (json['PublishedFare'] as num?)?.toDouble() ?? 0.0;
    commissionEarned = (json['CommissionEarned'] as num?)?.toDouble() ?? 0.0;
    plbEarned = (json['PLBEarned'] as num?)?.toDouble() ?? 0.0;
    incentiveEarned = (json['IncentiveEarned'] as num?)?.toDouble() ?? 0.0;
    offeredFare = (json['OfferedFare'] as num?)?.toDouble() ?? 0.0;
    tdsOnCommission = (json['TdsOnCommission'] as num?)?.toDouble() ?? 0.0;
    tdsOnPLB = (json['TdsOnPLB'] as num?)?.toDouble() ?? 0.0;
    tdsOnIncentive = (json['TdsOnIncentive'] as num?)?.toDouble() ?? 0.0;
    serviceFee = (json['ServiceFee'] as num?)?.toDouble() ?? 0.0;
    totalBaggageCharges =
        (json['TotalBaggageCharges'] as num?)?.toDouble() ?? 0.0;
    totalMealCharges = (json['TotalMealCharges'] as num?)?.toDouble() ?? 0.0;
    totalSeatCharges = (json['TotalSeatCharges'] as num?)?.toDouble() ?? 0.0;
    totalSpecialServiceCharges =
        (json['TotalSpecialServiceCharges'] as num?)?.toDouble() ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CFARAmount'] = cfarAmount;
    map['DCFARAmount'] = dcfarAmount;
    map['ServiceFeeDisplayType'] = serviceFeeDisplayType;
    map['Currency'] = currency;
    map['BaseFare'] = baseFare;
    map['Tax'] = tax;
    map['TaxBreakup'] = taxBreakup.map((e) => e.toJson()).toList();
    map['YQTax'] = yqTax;
    map['AdditionalTxnFeeOfrd'] = additionalTxnFeeOfrd;
    map['AdditionalTxnFeePub'] = additionalTxnFeePub;
    map['PGCharge'] = pgCharge;
    map['OtherCharges'] = otherCharges;
    map['ChargeBU'] = chargeBU.map((e) => e.toJson()).toList();
    map['Discount'] = discount;
    map['PublishedFare'] = publishedFare;
    map['CommissionEarned'] = commissionEarned;
    map['PLBEarned'] = plbEarned;
    map['IncentiveEarned'] = incentiveEarned;
    map['OfferedFare'] = offeredFare;
    map['TdsOnCommission'] = tdsOnCommission;
    map['TdsOnPLB'] = tdsOnPLB;
    map['TdsOnIncentive'] = tdsOnIncentive;
    map['ServiceFee'] = serviceFee;
    map['TotalBaggageCharges'] = totalBaggageCharges;
    map['TotalMealCharges'] = totalMealCharges;
    map['TotalSeatCharges'] = totalSeatCharges;
    map['TotalSpecialServiceCharges'] = totalSpecialServiceCharges;
    return map;
  }
}

class TaxBreakupItem {
  TaxBreakupItem({required this.key, required this.value});

  late final String key;
  late final double value;

  TaxBreakupItem.fromJson(Map<String, dynamic> json) {
    key = json['key'] as String? ?? '';
    value = (json['value'] as num?)?.toDouble() ?? 0.0;
  }

  Map<String, dynamic> toJson() => {'key': key, 'value': value};
}

class ChargeBUItem {
  ChargeBUItem({required this.key, required this.value});

  late final String key;
  late final double? value;

  ChargeBUItem.fromJson(Map<String, dynamic> json) {
    key = json['key'] as String? ?? '';
    value = (json['value'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {'key': key, 'value': value};
}

class PassengerInfo {
  PassengerInfo({
    required this.barcodeDetails,
    required this.documentDetails,
    this.guardianDetails,
    required this.isReissued,
    this.segmentDetails,
    required this.paxId,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.paxType,
    required this.dateOfBirth,
    required this.gender,
    required this.isPANRequired,
    required this.isPassportRequired,
    required this.pan,
    required this.passportNo,
    required this.addressLine1,
    required this.fare,
    required this.city,
    required this.countryCode,
    required this.nationality,
    required this.contactNo,
    required this.email,
    required this.isLeadPax,
    this.ffAirlineCode,
    this.ffNumber,
    required this.ssr,
    required this.ticket,
    required this.segmentAdditionalInfo,
  });

  BarcodeDetailsInfo? barcodeDetails; // ✅ add ?
  late final List<DocumentDetailsInfo> documentDetails;
  late final dynamic guardianDetails;
  late final bool isReissued;
  late final dynamic segmentDetails;
  late final int paxId;
  late final String title;
  late final String firstName;
  late final String lastName;
  late final int paxType;
  late final String dateOfBirth;
  late final int gender;
  late final bool isPANRequired;
  late final bool isPassportRequired;
  late final String pan;
  late final String passportNo;
  late final String addressLine1;
  late final FareInfo fare;
  late final String city;
  late final String countryCode;
  late final String nationality;
  late final String contactNo;
  late final String email;
  late final bool isLeadPax;
  late final dynamic ffAirlineCode;
  late final dynamic ffNumber;
  late final List<dynamic> ssr;
  late final TicketInfo ticket;
  late final List<SegmentAdditionalInfoItem> segmentAdditionalInfo;

  PassengerInfo.fromJson(Map<String, dynamic> json) {
    barcodeDetails = json['BarcodeDetails'] != null
        ? BarcodeDetailsInfo.fromJson(
            json['BarcodeDetails'] as Map<String, dynamic>)
        : null;
    documentDetails = json['DocumentDetails'] != null
        ? List.from(json['DocumentDetails'])
            .map((e) => DocumentDetailsInfo.fromJson(e))
            .toList()
        : [];
    guardianDetails = null;
    isReissued = json['IsReissued'] as bool? ?? false;
    segmentDetails = null;
    paxId = (json['PaxId'] as num?)?.toInt() ?? 0;
    title = json['Title'] as String? ?? '';
    firstName = json['FirstName'] as String? ?? '';
    lastName = json['LastName'] as String? ?? '';
    paxType = (json['PaxType'] as num?)?.toInt() ?? 0;
    dateOfBirth = json['DateOfBirth'] as String? ?? '';
    gender = (json['Gender'] as num?)?.toInt() ?? 0;
    isPANRequired = json['IsPANRequired'] as bool? ?? false;
    isPassportRequired = json['IsPassportRequired'] as bool? ?? false;
    pan = json['PAN'] as String? ?? '';
    passportNo = json['PassportNo'] as String? ?? '';
    addressLine1 = json['AddressLine1'] as String? ?? '';
    fare = FareInfo.fromJson(json['Fare'] as Map<String, dynamic>);
    city = json['City'] as String? ?? '';
    countryCode = json['CountryCode'] as String? ?? '';
    nationality = json['Nationality'] as String? ?? '';
    contactNo = json['ContactNo'] as String? ?? '';
    email = json['Email'] as String? ?? '';
    isLeadPax = json['IsLeadPax'] as bool? ?? false;
    ffAirlineCode = null;
    ffNumber = null;
    ssr = json['Ssr'] != null ? List.from(json['Ssr']) : [];
    ticket = TicketInfo.fromJson(json['Ticket'] as Map<String, dynamic>);
    segmentAdditionalInfo = json['SegmentAdditionalInfo'] != null
        ? List.from(json['SegmentAdditionalInfo'])
            .map((e) => SegmentAdditionalInfoItem.fromJson(e))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['BarcodeDetails'] = barcodeDetails?.toJson(); // ✅ add ?
    map['DocumentDetails'] = documentDetails.map((e) => e.toJson()).toList();
    map['GuardianDetails'] = guardianDetails;
    map['IsReissued'] = isReissued;
    map['SegmentDetails'] = segmentDetails;
    map['PaxId'] = paxId;
    map['Title'] = title;
    map['FirstName'] = firstName;
    map['LastName'] = lastName;
    map['PaxType'] = paxType;
    map['DateOfBirth'] = dateOfBirth;
    map['Gender'] = gender;
    map['IsPANRequired'] = isPANRequired;
    map['IsPassportRequired'] = isPassportRequired;
    map['PAN'] = pan;
    map['PassportNo'] = passportNo;
    map['AddressLine1'] = addressLine1;
    map['Fare'] = fare.toJson();
    map['City'] = city;
    map['CountryCode'] = countryCode;
    map['Nationality'] = nationality;
    map['ContactNo'] = contactNo;
    map['Email'] = email;
    map['IsLeadPax'] = isLeadPax;
    map['FFAirlineCode'] = ffAirlineCode;
    map['FFNumber'] = ffNumber;
    map['Ssr'] = ssr;
    map['Ticket'] = ticket.toJson();
    map['SegmentAdditionalInfo'] =
        segmentAdditionalInfo.map((e) => e.toJson()).toList();
    return map;
  }
}

class BarcodeDetailsInfo {
  BarcodeDetailsInfo({required this.id, required this.barcodes});

  late final int id;
  late final List<BarcodeItem> barcodes;

  BarcodeDetailsInfo.fromJson(Map<String, dynamic> json) {
    id = (json['Id'] as num?)?.toInt() ?? 0;
    barcodes = json['Barcode'] != null
        ? List.from(json['Barcode'])
            .map((e) => BarcodeItem.fromJson(e))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['Barcode'] = barcodes.map((e) => e.toJson()).toList();
    return map;
  }
}

class BarcodeItem {
  BarcodeItem({
    required this.index,
    required this.format,
    required this.content,
    this.barCodeInBase64,
    required this.journeyWayType,
  });

  late final int index;
  late final String format;
  late final String content;
  late final dynamic barCodeInBase64;
  late final int journeyWayType;

  BarcodeItem.fromJson(Map<String, dynamic> json) {
    index = (json['Index'] as num?)?.toInt() ?? 0;
    format = json['Format'] as String? ?? '';
    content = json['Content'] as String? ?? '';
    barCodeInBase64 = null;
    journeyWayType = (json['JourneyWayType'] as num?)?.toInt() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Index'] = index;
    map['Format'] = format;
    map['Content'] = content;
    map['BarCodeInBase64'] = barCodeInBase64;
    map['JourneyWayType'] = journeyWayType;
    return map;
  }
}

class DocumentDetailsInfo {
  DocumentDetailsInfo({
    required this.documentExpiryDate,
    required this.documentIssueDate,
    required this.documentIssuingCountry,
    required this.documentNumber,
    required this.documentTypeId,
    required this.paxId,
    required this.resultFareType,
  });

  late final String documentExpiryDate;
  late final String documentIssueDate;
  late final String documentIssuingCountry;
  late final String documentNumber;
  late final String documentTypeId;
  late final int paxId;
  late final int resultFareType;

  DocumentDetailsInfo.fromJson(Map<String, dynamic> json) {
    documentExpiryDate = json['DocumentExpiryDate'] as String? ?? '';
    documentIssueDate = json['DocumentIssueDate'] as String? ?? '';
    documentIssuingCountry = json['DocumentIssuingCountry'] as String? ?? '';
    documentNumber = json['DocumentNumber'] as String? ?? '';
    documentTypeId = json['DocumentTypeId'] as String? ?? '';
    paxId = (json['PaxId'] as num?)?.toInt() ?? 0;
    resultFareType = (json['ResultFareType'] as num?)?.toInt() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DocumentExpiryDate'] = documentExpiryDate;
    map['DocumentIssueDate'] = documentIssueDate;
    map['DocumentIssuingCountry'] = documentIssuingCountry;
    map['DocumentNumber'] = documentNumber;
    map['DocumentTypeId'] = documentTypeId;
    map['PaxId'] = paxId;
    map['ResultFareType'] = resultFareType;
    return map;
  }
}

class TicketInfo {
  TicketInfo({
    required this.ticketId,
    required this.ticketNumber,
    required this.issueDate,
    required this.validatingAirline,
    required this.remarks,
    required this.serviceFeeDisplayType,
    required this.status,
    required this.conjunctionNumber,
    required this.ticketType,
  });

  late final int ticketId;
  late final String ticketNumber;
  late final String issueDate;
  late final String validatingAirline;
  late final String remarks;
  late final String serviceFeeDisplayType;
  late final String status;
  late final String conjunctionNumber;
  late final String ticketType;

  TicketInfo.fromJson(Map<String, dynamic> json) {
    ticketId = (json['TicketId'] as num?)?.toInt() ?? 0;
    ticketNumber = json['TicketNumber'] as String? ?? '';
    issueDate = json['IssueDate'] as String? ?? '';
    validatingAirline = json['ValidatingAirline'] as String? ?? '';
    remarks = json['Remarks'] as String? ?? '';
    serviceFeeDisplayType = json['ServiceFeeDisplayType']?.toString() ?? '';
    status = json['Status']?.toString() ?? '';
    conjunctionNumber = json['ConjunctionNumber'] as String? ?? '';
    ticketType = json['TicketType'] as String? ?? '';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TicketId'] = ticketId;
    map['TicketNumber'] = ticketNumber;
    map['IssueDate'] = issueDate;
    map['ValidatingAirline'] = validatingAirline;
    map['Remarks'] = remarks;
    map['ServiceFeeDisplayType'] = serviceFeeDisplayType;
    map['Status'] = status;
    map['ConjunctionNumber'] = conjunctionNumber;
    map['TicketType'] = ticketType;
    return map;
  }
}

class SegmentAdditionalInfoItem {
  SegmentAdditionalInfoItem({
    required this.fareBasis,
    required this.nva,
    required this.nvb,
    required this.baggage,
    required this.meal,
    required this.seat,
    required this.specialService,
    required this.cabinBaggage,
  });

  late final String fareBasis;
  late final String nva;
  late final String nvb;
  late final String baggage;
  late final String meal;
  late final String seat;
  late final String specialService;
  late final String cabinBaggage;

  SegmentAdditionalInfoItem.fromJson(Map<String, dynamic> json) {
    fareBasis = json['FareBasis'] as String? ?? '';
    nva = json['NVA'] as String? ?? '';
    nvb = json['NVB'] as String? ?? '';
    baggage = json['Baggage'] as String? ?? '';
    meal = json['Meal'] as String? ?? '';
    seat = json['Seat'] as String? ?? '';
    specialService = json['SpecialService'] as String? ?? '';
    cabinBaggage = json['CabinBaggage'] as String? ?? '';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['FareBasis'] = fareBasis;
    map['NVA'] = nva;
    map['NVB'] = nvb;
    map['Baggage'] = baggage;
    map['Meal'] = meal;
    map['Seat'] = seat;
    map['SpecialService'] = specialService;
    map['CabinBaggage'] = cabinBaggage;
    return map;
  }
}

class SegmentInfo {
  SegmentInfo({
    required this.baggage,
    required this.cabinBaggage,
    required this.cabinClass,
    this.supplierFareClass,
    required this.tripIndicator,
    required this.segmentIndicator,
    required this.airline,
    required this.airlinePNR,
    required this.origin,
    required this.destination,
    required this.duration,
    required this.groundTime,
    required this.mile,
    this.stopOver,
    this.flightInfoIndex,
    required this.stopPoint,
    this.stopPointArrivalTime,
    this.stopPointDepartureTime,
    this.craft,
    required this.remark,
    this.isETicketEligible,
    this.flightStatus,
    required this.status,
    this.fareClassification,
  });

  late final String baggage;
  late final String cabinBaggage;
  late final int cabinClass;
  late final dynamic supplierFareClass;
  late final int tripIndicator;
  late final int segmentIndicator;
  late final AirlineInfo airline;
  late final String airlinePNR;
  late final OriginInfo origin;
  late final DestinationInfo destination;
  late final int duration;
  late final int groundTime;
  late final int mile;
  late final bool? stopOver;
  late final String? flightInfoIndex;
  late final String stopPoint;
  late final dynamic stopPointArrivalTime;
  late final dynamic stopPointDepartureTime;
  late final String? craft;
  late final String remark;
  late final bool? isETicketEligible;
  late final String? flightStatus;
  late final String status;
  late final FareClassificationInfo? fareClassification;

  SegmentInfo.fromJson(Map<String, dynamic> json) {
    baggage = json['Baggage'] as String? ?? '';
    cabinBaggage = json['CabinBaggage'] as String? ?? '';
    cabinClass = (json['CabinClass'] as num?)?.toInt() ?? 0;
    supplierFareClass = null;
    tripIndicator = (json['TripIndicator'] as num?)?.toInt() ?? 0;
    segmentIndicator = (json['SegmentIndicator'] as num?)?.toInt() ?? 0;
    airline = AirlineInfo.fromJson(json['Airline'] as Map<String, dynamic>);
    airlinePNR = json['AirlinePNR'] as String? ?? '';
    origin = OriginInfo.fromJson(json['Origin'] as Map<String, dynamic>);
    destination =
        DestinationInfo.fromJson(json['Destination'] as Map<String, dynamic>);
    duration = (json['Duration'] as num?)?.toInt() ?? 0;
    groundTime = (json['GroundTime'] as num?)?.toInt() ?? 0;
    mile = (json['Mile'] as num?)?.toInt() ?? 0;
    stopOver = json['StopOver'] as bool?;
    flightInfoIndex = json['FlightInfoIndex'] as String?;
    stopPoint = json['StopPoint'] as String? ?? '';
    stopPointArrivalTime = null;
    stopPointDepartureTime = null;
    craft = null;
    remark = json['Remark'] as String? ?? '';
    isETicketEligible = json['IsETicketEligible'] as bool?;
    flightStatus = json['FlightStatus'] as String?;
    status = json['Status']?.toString() ?? '';
    fareClassification = json['FareClassification'] != null
        ? FareClassificationInfo.fromJson(json['FareClassification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Baggage'] = baggage;
    map['CabinBaggage'] = cabinBaggage;
    map['CabinClass'] = cabinClass;
    map['SupplierFareClass'] = supplierFareClass;
    map['TripIndicator'] = tripIndicator;
    map['SegmentIndicator'] = segmentIndicator;
    map['Airline'] = airline.toJson();
    map['AirlinePNR'] = airlinePNR;
    map['Origin'] = origin.toJson();
    map['Destination'] = destination.toJson();
    map['Duration'] = duration;
    map['GroundTime'] = groundTime;
    map['Mile'] = mile;
    map['StopOver'] = stopOver;
    map['FlightInfoIndex'] = flightInfoIndex;
    map['StopPoint'] = stopPoint;
    map['StopPointArrivalTime'] = stopPointArrivalTime;
    map['StopPointDepartureTime'] = stopPointDepartureTime;
    map['Craft'] = craft;
    map['Remark'] = remark;
    map['IsETicketEligible'] = isETicketEligible;
    map['FlightStatus'] = flightStatus;
    map['Status'] = status;
    map['FareClassification'] = fareClassification?.toJson();
    return map;
  }
}

class AirlineInfo {
  AirlineInfo({
    required this.airlineCode,
    required this.airlineName,
    required this.flightNumber,
    required this.fareClass,
    required this.operatingCarrier,
  });

  late final String airlineCode;
  late final String airlineName;
  late final String flightNumber;
  late final String fareClass;
  late final String operatingCarrier;

  AirlineInfo.fromJson(Map<String, dynamic> json) {
    airlineCode = json['AirlineCode'] as String? ?? '';
    airlineName = json['AirlineName'] as String? ?? '';
    flightNumber = json['FlightNumber'] as String? ?? '';
    fareClass = json['FareClass'] as String? ?? '';
    operatingCarrier = json['OperatingCarrier'] as String? ?? '';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AirlineCode'] = airlineCode;
    map['AirlineName'] = airlineName;
    map['FlightNumber'] = flightNumber;
    map['FareClass'] = fareClass;
    map['OperatingCarrier'] = operatingCarrier;
    return map;
  }
}

class OriginInfo {
  OriginInfo({required this.airport, required this.depTime});

  late final AirportInfo airport;
  late final String depTime;

  OriginInfo.fromJson(Map<String, dynamic> json) {
    airport = AirportInfo.fromJson(json['Airport'] as Map<String, dynamic>);
    depTime = json['DepTime'] as String? ?? '';
  }

  Map<String, dynamic> toJson() => {
        'Airport': airport.toJson(),
        'DepTime': depTime,
      };
}

class DestinationInfo {
  DestinationInfo({required this.airport, required this.arrTime});

  late final AirportInfo airport;
  late final String arrTime;

  DestinationInfo.fromJson(Map<String, dynamic> json) {
    airport = AirportInfo.fromJson(json['Airport'] as Map<String, dynamic>);
    arrTime = json['ArrTime'] as String? ?? '';
  }

  Map<String, dynamic> toJson() => {
        'Airport': airport.toJson(),
        'ArrTime': arrTime,
      };
}

class AirportInfo {
  AirportInfo({
    required this.airportCode,
    required this.airportName,
    required this.terminal,
    required this.cityCode,
    required this.cityName,
    required this.countryCode,
    required this.countryName,
  });

  late final String airportCode;
  late final String airportName;
  late final String terminal;
  late final String cityCode;
  late final String cityName;
  late final String countryCode;
  late final String countryName;

  AirportInfo.fromJson(Map<String, dynamic> json) {
    airportCode = json['AirportCode'] as String? ?? '';
    airportName = json['AirportName'] as String? ?? '';
    terminal = json['Terminal'] as String? ?? '';
    cityCode = json['CityCode'] as String? ?? '';
    cityName = json['CityName'] as String? ?? '';
    countryCode = json['CountryCode'] as String? ?? '';
    countryName = json['CountryName'] as String? ?? '';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AirportCode'] = airportCode;
    map['AirportName'] = airportName;
    map['Terminal'] = terminal;
    map['CityCode'] = cityCode;
    map['CityName'] = cityName;
    map['CountryCode'] = countryCode;
    map['CountryName'] = countryName;
    return map;
  }
}

class FareClassificationInfo {
  FareClassificationInfo({required this.color, required this.type});

  late final String color;
  late final String type;

  FareClassificationInfo.fromJson(Map<String, dynamic> json) {
    color = json['Color'] as String? ?? '';
    type = json['Type'] as String? ?? '';
  }

  Map<String, dynamic> toJson() => {'Color': color, 'Type': type};
}

class FareRule {
  FareRule({
    required this.origin,
    required this.destination,
    required this.airline,
    required this.fareBasisCode,
    required this.fareRuleDetail,
    required this.fareRestriction,
    required this.fareFamilyCode,
    required this.fareRuleIndex,
    required this.fareInclusions,
  });

  late final String origin;
  late final String destination;
  late final String airline;
  late final String fareBasisCode;
  late final String fareRuleDetail;
  late final String fareRestriction;
  late final String fareFamilyCode;
  late final String fareRuleIndex;
  late final List<dynamic> fareInclusions;

  FareRule.fromJson(Map<String, dynamic> json) {
    origin = json['Origin'] as String? ?? '';
    destination = json['Destination'] as String? ?? '';
    airline = json['Airline'] as String? ?? '';
    fareBasisCode = json['FareBasisCode'] as String? ?? '';
    fareRuleDetail = json['FareRuleDetail'] as String? ?? '';
    fareRestriction = json['FareRestriction'] as String? ?? '';
    fareFamilyCode = json['FareFamilyCode'] as String? ?? '';
    fareRuleIndex = json['FareRuleIndex'] as String? ?? '';
    fareInclusions =
        json['FareInclusions'] != null ? List.from(json['FareInclusions']) : [];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Origin'] = origin;
    map['Destination'] = destination;
    map['Airline'] = airline;
    map['FareBasisCode'] = fareBasisCode;
    map['FareRuleDetail'] = fareRuleDetail;
    map['FareRestriction'] = fareRestriction;
    map['FareFamilyCode'] = fareFamilyCode;
    map['FareRuleIndex'] = fareRuleIndex;
    map['FareInclusions'] = fareInclusions;
    return map;
  }
}

class MiniFareRule {
  MiniFareRule({
    this.cfarExcludedDetails,
    required this.journeyPoints,
    required this.type,
    required this.from,
    required this.to,
    required this.unit,
    required this.details,
    required this.onlineReissueAllowed,
    required this.onlineRefundAllowed,
  });

  late final dynamic cfarExcludedDetails;
  late final String journeyPoints;
  late final String type;
  late final String from;
  late final String to;
  late final String unit;
  late final String details;
  late final bool onlineReissueAllowed;
  late final bool onlineRefundAllowed;

  MiniFareRule.fromJson(Map<String, dynamic> json) {
    cfarExcludedDetails = null;
    journeyPoints = json['JourneyPoints'] as String? ?? '';
    type = json['Type'] as String? ?? '';
    from = json['From'] as String? ?? '';
    to = json['To'] as String? ?? '';
    unit = json['Unit'] as String? ?? '';
    details = json['Details'] as String? ?? '';
    onlineReissueAllowed = json['OnlineReissueAllowed'] as bool? ?? false;
    onlineRefundAllowed = json['OnlineRefundAllowed'] as bool? ?? false;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CFARExcludedDetails'] = cfarExcludedDetails;
    map['JourneyPoints'] = journeyPoints;
    map['Type'] = type;
    map['From'] = from;
    map['To'] = to;
    map['Unit'] = unit;
    map['Details'] = details;
    map['OnlineReissueAllowed'] = onlineReissueAllowed;
    map['OnlineRefundAllowed'] = onlineRefundAllowed;
    return map;
  }
}

class PenaltyChargeInfo {
  PenaltyChargeInfo({
    required this.reissueCharge,
    required this.cancellationCharge,
  });

  late final String reissueCharge;
  late final String cancellationCharge;

  PenaltyChargeInfo.fromJson(Map<String, dynamic> json) {
    reissueCharge = json['ReissueCharge']?.toString() ?? '';
    cancellationCharge = json['CancellationCharge']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() => {
        'ReissueCharge': reissueCharge,
        'CancellationCharge': cancellationCharge,
      };
}

class InvoiceInfo {
  InvoiceInfo({
    this.creditNoteGSTIN,
    this.gstin,
    required this.invoiceCreatedOn,
    required this.invoiceId,
    required this.invoiceNo,
    required this.invoiceAmount,
    required this.remarks,
    required this.invoiceStatus,
  });

  late final dynamic creditNoteGSTIN;
  late final dynamic gstin;
  late final String invoiceCreatedOn;
  late final int invoiceId;
  late final String invoiceNo;
  late final double invoiceAmount;
  late final String remarks;
  late final int invoiceStatus;

  InvoiceInfo.fromJson(Map<String, dynamic> json) {
    creditNoteGSTIN = null;
    gstin = null;
    invoiceCreatedOn = json['InvoiceCreatedOn'] as String? ?? '';
    invoiceId = (json['InvoiceId'] as num?)?.toInt() ?? 0;
    invoiceNo = json['InvoiceNo'] as String? ?? '';
    invoiceAmount = (json['InvoiceAmount'] as num?)?.toDouble() ?? 0.0;
    remarks = json['Remarks'] as String? ?? '';
    invoiceStatus = (json['InvoiceStatus'] as num?)?.toInt() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CreditNoteGSTIN'] = creditNoteGSTIN;
    map['GSTIN'] = gstin;
    map['InvoiceCreatedOn'] = invoiceCreatedOn;
    map['InvoiceId'] = invoiceId;
    map['InvoiceNo'] = invoiceNo;
    map['InvoiceAmount'] = invoiceAmount;
    map['Remarks'] = remarks;
    map['InvoiceStatus'] = invoiceStatus;
    return map;
  }
}
