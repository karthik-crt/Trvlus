Getbookingdetailsid getbookingdetailsidFromJson(Map<String, dynamic> json) =>
    Getbookingdetailsid.fromJson(json);

class Getbookingdetailsid {
  Getbookingdetailsid({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  late final String statusCode;
  late final String statusMessage;
  late final List<Data> data;

  Getbookingdetailsid.fromJson(Map<String, dynamic> json) {
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
    required this.bookingId,
    required this.user,
    required this.role,
    required this.roleName,
    required this.customerStatus,
    required this.originAirport,
    required this.commissionAmt,
    required this.serviceTax,
    required this.checkinAdult,
    required this.cabinAdult,
    required this.originCityName,
    required this.destinationAirport,
    required this.destinationCityName,
    required this.totalFare,
    required this.originalFare,
    required this.pnr,
    required this.gdspnr,
    required this.appReference,
    required this.totalpassengers,
    required this.documentType,
    required this.documentNumber,
    required this.passengerDetails,
    required this.journeyList,
    required this.price,
    required this.travelDate,
    required this.returnDate,
    required this.commisionPercentageAmount,
    required this.status,
    required this.passengerBreakup,
    required this.reissueCharge,
    required this.cancellationCharge,
    required this.invoiceNo,
    required this.markup,
    required this.createdAt,
    required this.updatedAt,
  });

  late final int id;
  late final String bookingId;
  late final int user;
  late final int role;
  late final String roleName;
  late final String customerStatus;
  late final String originAirport;
  late final double commissionAmt;
  late final double serviceTax;
  late final String checkinAdult;
  late final String cabinAdult;
  late final String originCityName;
  late final String destinationAirport;
  late final String destinationCityName;
  late final String totalFare;
  late final String originalFare;
  late final String pnr;
  late final String gdspnr;
  late final String appReference;
  late final int totalpassengers;
  late final String documentType;
  late final String documentNumber;
  late final List<PassengerDetails> passengerDetails;
  late final List<JourneyList> journeyList;
  late final Price price;
  late final String travelDate;
  late final String returnDate;
  late final int commisionPercentageAmount;
  late final String status;
  late final List<PassengerBreakup> passengerBreakup;
  late final String reissueCharge;
  late final String cancellationCharge;
  late final int invoiceNo;
  late final int markup;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    user = json['user'];
    role = json['role'];
    roleName = json['role_name'];
    customerStatus = json['customer_status'];
    originAirport = json['originAirport'];
    commissionAmt = (json['commission_amt'] as num).toDouble();
    serviceTax = (json['service_tax'] as num).toDouble();
    checkinAdult = json['checkin_adult'];
    cabinAdult = json['cabin_adult'];
    originCityName = json['originCityName'];
    destinationAirport = json['destinationAirport'];
    destinationCityName = json['destinationCityName'];
    totalFare = json['totalFare'];
    originalFare = json['originalFare'];
    pnr = json['pnr'];
    gdspnr = json['gdspnr'];
    appReference = json['app_reference'];
    totalpassengers = json['totalpassengers'];
    documentType = json['document_type'];
    documentNumber = json['document_number'];
    passengerDetails = List.from(json['passenger_details'])
        .map((e) => PassengerDetails.fromJson(e))
        .toList();
    journeyList = List.from(json['journey_list'])
        .map((e) => JourneyList.fromJson(e))
        .toList();
    price = Price.fromJson(json['price']);
    travelDate = json['travel_date'];
    returnDate = json['return_date'];
    commisionPercentageAmount =
        (json['commision_percentage_amount'] as num).toInt();
    status = json['status'];
    // passengerBreakup = List.from(json['passenger_breakup'] ?? [])
    //     .map((e) => PassengerBreakup.fromJson(e))
    //     .toList();
    reissueCharge = json['reissue_charge'];
    cancellationCharge = json['cancellation_charge'];
    invoiceNo = json['invoiceNo'];
    markup = (json['markup'] as num).toInt();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['booking_id'] = bookingId;
    _data['user'] = user;
    _data['role'] = role;
    _data['role_name'] = roleName;
    _data['customer_status'] = customerStatus;
    _data['originAirport'] = originAirport;
    _data['commission_amt'] = commissionAmt;
    _data['service_tax'] = serviceTax;
    _data['checkin_adult'] = checkinAdult;
    _data['cabin_adult'] = cabinAdult;
    _data['originCityName'] = originCityName;
    _data['destinationAirport'] = destinationAirport;
    _data['destinationCityName'] = destinationCityName;
    _data['totalFare'] = totalFare;
    _data['originalFare'] = originalFare;
    _data['pnr'] = pnr;
    _data['gdspnr'] = gdspnr;
    _data['app_reference'] = appReference;
    _data['totalpassengers'] = totalpassengers;
    _data['document_type'] = documentType;
    _data['document_number'] = documentNumber;
    _data['passenger_details'] =
        passengerDetails.map((e) => e.toJson()).toList();
    _data['journey_list'] = journeyList.map((e) => e.toJson()).toList();
    _data['price'] = price.toJson();
    _data['travel_date'] = travelDate;
    _data['return_date'] = returnDate;
    _data['commision_percentage_amount'] = commisionPercentageAmount;
    _data['status'] = status;
    _data['passenger_breakup'] =
        passengerBreakup.map((e) => e.toJson()).toList();
    _data['reissue_charge'] = reissueCharge;
    _data['cancellation_charge'] = cancellationCharge;
    _data['invoiceNo'] = invoiceNo;
    _data['markup'] = markup;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}

class PassengerDetails {
  PassengerDetails({
    required this.PAN,
    required this.Ssr,
    required this.City,
    required this.fare,
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
  late final Fare fare;
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
    PAN = json['PAN'];
    Ssr = List.castFrom<dynamic, dynamic>(json['Ssr']);
    City = json['City'];
    fare = Fare.fromJson(json['Fare']);
    Email = json['Email'];
    PaxId = json['PaxId'];
    Title = json['Title'];
    Gender = json['Gender'];
    ticket = Ticket.fromJson(json['Ticket'] ?? {});
    baggage = List.from(json['Baggage'] ?? {})
        .map((e) => Baggage.fromJson(e))
        .toList();
    PaxType = json['PaxType'];
    FFNumber = json['FFNumber'] ?? "";
    LastName = json['LastName'];
    ContactNo = json['ContactNo'];
    FirstName = json['FirstName'];
    GSTNumber = json['GSTNumber'] ?? "";
    IsLeadPax = json['IsLeadPax'];
    PassportNo = json['PassportNo'];
    CountryCode = json['CountryCode'];
    CountryName = json['CountryName'] ?? "";
    DateOfBirth = json['DateOfBirth'] ?? "";
    Nationality = json['Nationality'];
    AddressLine1 = json['AddressLine1'];
    FFAirlineCode = json['FFAirlineCode'] ?? "";
    IsPANRequired = json['IsPANRequired'];
    barcodeDetails = BarcodeDetails.fromJson(json['BarcodeDetails']);
    GSTCompanyName = json['GSTCompanyName'] ?? "";
    PassportExpiry = json['PassportExpiry'] ?? "";
    documentDetails = List.from(json['DocumentDetails'])
        .map((e) => DocumentDetails.fromJson(e))
        .toList();
    GSTCompanyEmail = json['GSTCompanyEmail'] ?? "";
    GuardianDetails = null;
    GSTCompanyAddress = json['GSTCompanyAddress'] ?? "";
    IsPassportRequired = json['IsPassportRequired'];
    segmentAdditionalInfo = List.from(json['SegmentAdditionalInfo'])
        .map((e) => SegmentAdditionalInfo.fromJson(e))
        .toList();
    GSTCompanyContactNumber = json['GSTCompanyContactNumber'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['PAN'] = PAN;
    _data['Ssr'] = Ssr;
    _data['City'] = City;
    _data['Fare'] = fare.toJson();
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
  late final double YQTax;
  late final double BaseFare;
  late final List<ChargeBU> chargeBU;
  late final String Currency;
  late final double Discount;
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
  late final double TotalMealCharges;
  late final double TotalSeatCharges;
  late final double AdditionalTxnFeePub;
  late final double TotalBaggageCharges;
  late final int AdditionalTxnFeeOfrd;
  late final int ServiceFeeDisplayType;
  late final int TotalSpecialServiceCharges;

  Fare.fromJson(Map<String, dynamic> json) {
    Tax = json['Tax'];
    YQTax = (json['YQTax'] as num).toDouble();
    BaseFare = (json['BaseFare'] as num).toDouble();
    chargeBU =
        List.from(json['ChargeBU']).map((e) => ChargeBU.fromJson(e)).toList();
    Currency = json['Currency'];
    Discount = (json['Discount'] as num).toDouble();
    PGCharge = json['PGCharge'];
    TdsOnPLB = json['TdsOnPLB'].toDouble();
    PLBEarned = json['PLBEarned'].toDouble();
    ServiceFee = json['ServiceFee'];
    taxBreakup = List.from(json['TaxBreakup'])
        .map((e) => TaxBreakup.fromJson(e))
        .toList();
    OfferedFare = (json['OfferedFare'] as num).toDouble();
    OtherCharges = json['OtherCharges'].toDouble();
    PublishedFare = json['PublishedFare'].toDouble();
    TdsOnIncentive = json['TdsOnIncentive'].toDouble();
    IncentiveEarned = json['IncentiveEarned'].toDouble();
    TdsOnCommission = json['TdsOnCommission'].toDouble();
    CommissionEarned = json['CommissionEarned'].toDouble();
    TotalMealCharges = (json['TotalMealCharges'] as num).toDouble();
    TotalSeatCharges = (json['TotalSeatCharges'] as num).toDouble();
    AdditionalTxnFeePub = (json['AdditionalTxnFeePub'] as num).toDouble();
    TotalBaggageCharges = (json['TotalBaggageCharges'] as num).toDouble();
    AdditionalTxnFeeOfrd = json['AdditionalTxnFeeOfrd'];
    ServiceFeeDisplayType = json['ServiceFeeDisplayType'];
    TotalSpecialServiceCharges =
        (json['TotalSpecialServiceCharges'] as num).toInt();
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
    key = json['key'];
    value = json['value'] != null ? (json['value'] as num).toInt() : null;
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
    key = json['key'];
    value = (json['value'] as num).toInt(); // converts double → int safely
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
  late final String TicketId;
  late final String IssueDate;
  late final String TicketType;
  late final String TicketNumber;
  late final String ConjunctionNumber;
  late final String ValidatingAirline;
  late final String ServiceFeeDisplayType;

  Ticket.fromJson(Map<String, dynamic> json) {
    Status = json['Status'] ?? "";
    Remarks = json['Remarks'] ?? "";
    TicketId = json['TicketId'].toString();
    IssueDate = json['IssueDate'] ?? "";
    TicketType = json['TicketType'] ?? "";
    TicketNumber = json['TicketNumber'] ?? "";
    ConjunctionNumber = json['ConjunctionNumber'] ?? "";
    ValidatingAirline = json['ValidatingAirline'] ?? "";
    ServiceFeeDisplayType = json['ServiceFeeDisplayType'] ?? "";
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
    Code = json['Code'];
    Price = (json['Price'] as num).toInt();
    Origin = json['Origin'];
    Weight = json['Weight'];
    WayType = json['WayType'];
    Currency = json['Currency'];
    AirlineCode = json['AirlineCode'];
    Description = json['Description'];
    Destination = json['Destination'];
    FlightNumber = json['FlightNumber'];
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
    Id = json['Id'];
    barcode =
        List.from(json['Barcode']).map((e) => Barcode.fromJson(e)).toList();
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
    Index = json['Index'];
    Format = json['Format'];
    Content = json['Content'];
    JourneyWayType = json['JourneyWayType'];
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
    PaxId = json['PaxId'];
    DocumentNumber = json['DocumentNumber'];
    DocumentTypeId = json['DocumentTypeId'];
    ResultFareType = json['ResultFareType'];
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
    NVA = json['NVA'];
    NVB = json['NVB'];
    Meal = json['Meal'];
    Seat = json['Seat'];
    Baggage = json['Baggage'];
    FareBasis = json['FareBasis'];
    CabinBaggage = json['CabinBaggage'];
    SpecialService = json['SpecialService'];
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

class JourneyList {
  JourneyList({
    required this.Arrival,
    required this.Baggage,
    required this.Depature,
    required this.duration,
    required this.noofstop,
    required this.ToCityName,
    required this.ArrivalTime,
    required this.LayOverTime,
    required this.CabinBaggage,
    required this.DepatureTime,
    required this.FlightNumber,
    required this.FromCityName,
    required this.OperatorCode,
    required this.OperatorName,
    required this.durationTime,
    required this.ToAirportCode,
    required this.ToAirportName,
    required this.FromAirportCode,
    required this.FromAirportName,
  });

  late final String Arrival;
  late final String Baggage;
  late final String Depature;
  late final String duration;
  late final int noofstop;
  late final String ToCityName;
  late final String ArrivalTime;
  late final String LayOverTime;
  late final String CabinBaggage;
  late final String DepatureTime;
  late final String FlightNumber;
  late final String FromCityName;
  late final String OperatorCode;
  late final String OperatorName;
  late final String durationTime;
  late final String ToAirportCode;
  late final String ToAirportName;
  late final String FromAirportCode;
  late final String FromAirportName;

  JourneyList.fromJson(Map<String, dynamic> json) {
    Arrival = json['Arrival'];
    Baggage = json['Baggage'];
    Depature = json['Depature'];
    duration = json['duration']?.toString() ?? '';
    noofstop = int.tryParse(json['noofstop'].toString()) ?? 0;
    ToCityName = json['ToCityName'];
    ArrivalTime = json['ArrivalTime'];
    LayOverTime = json['LayOverTime'];
    CabinBaggage = json['CabinBaggage'];
    DepatureTime = json['DepatureTime'];
    FlightNumber = json['FlightNumber'];
    FromCityName = json['FromCityName'];
    OperatorCode = json['OperatorCode'];
    OperatorName = json['OperatorName'];
    durationTime = json['durationTime'];
    ToAirportCode = json['ToAirportCode'];
    ToAirportName = json['ToAirportName'];
    FromAirportCode = json['FromAirportCode'];
    FromAirportName = json['FromAirportName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Arrival'] = Arrival;
    _data['Baggage'] = Baggage;
    _data['Depature'] = Depature;
    _data['duration'] = duration;
    _data['noofstop'] = noofstop;
    _data['ToCityName'] = ToCityName;
    _data['ArrivalTime'] = ArrivalTime;
    _data['LayOverTime'] = LayOverTime;
    _data['CabinBaggage'] = CabinBaggage;
    _data['DepatureTime'] = DepatureTime;
    _data['FlightNumber'] = FlightNumber;
    _data['FromCityName'] = FromCityName;
    _data['OperatorCode'] = OperatorCode;
    _data['OperatorName'] = OperatorName;
    _data['durationTime'] = durationTime;
    _data['ToAirportCode'] = ToAirportCode;
    _data['ToAirportName'] = ToAirportName;
    _data['FromAirportCode'] = FromAirportCode;
    _data['FromAirportName'] = FromAirportName;
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
    Tax = json['Tax'];
    YQTax = (json['YQTax'] as num).toInt();
    BaseFare = (json['BaseFare'] as num).toInt();
    chargeBU =
        List.from(json['ChargeBU']).map((e) => ChargeBU.fromJson(e)).toList();
    Currency = json['Currency'];
    Discount = (json['Discount'] as num).toInt();
    PGCharge = json['PGCharge'];
    TdsOnPLB = (json['TdsOnPLB'] as num).toDouble();
    PLBEarned = (json['PLBEarned'] as num).toDouble();
    ServiceFee = json['ServiceFee'];
    taxBreakup = List.from(json['TaxBreakup'])
        .map((e) => TaxBreakup.fromJson(e))
        .toList();
    OfferedFare = json['OfferedFare'];
    OtherCharges = json['OtherCharges'].toDouble();
    PublishedFare = (json['PublishedFare'] as num).toDouble();
    TdsOnIncentive = (json['TdsOnIncentive'] as num).toDouble();
    IncentiveEarned = (json['IncentiveEarned'] as num).toDouble();
    TdsOnCommission = (json['TdsOnCommission'] as num).toDouble();
    CommissionEarned = (json['CommissionEarned'] as num).toDouble();
    TotalMealCharges = (json['TotalMealCharges'] as num).toInt();
    TotalSeatCharges = (json['TotalSeatCharges'] as num).toInt();
    AdditionalTxnFeePub = (json['AdditionalTxnFeePub'] as num).toInt();
    TotalBaggageCharges = (json['TotalBaggageCharges'] as num).toInt();
    AdditionalTxnFeeOfrd = json['AdditionalTxnFeeOfrd'];
    ServiceFeeDisplayType = json['ServiceFeeDisplayType'];
    TotalSpecialServiceCharges =
        (json['TotalSpecialServiceCharges'] as num).toInt();
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
  late final int value;

  PassengerBreakup.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = (json['value'] as num).toInt();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['key'] = key;
    _data['value'] = value;
    return _data;
  }
}
