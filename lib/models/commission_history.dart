Commissionhistory commissionhistoryFromJson(Map<String, dynamic> json) =>
    Commissionhistory.fromJson(json);

class Commissionhistory {
  final String statusCode;
  final List<Data> data;

  Commissionhistory({
    required this.statusCode,
    required this.data,
  });

  factory Commissionhistory.fromJson(Map<String, dynamic> json) {
    return Commissionhistory(
      statusCode: json['statusCode'] ?? '',
      data: List.from(json['data'] ?? []).map((e) => Data.fromJson(e)).toList(),
    );
  }
}

class Data {
  final int id;
  final String appReference;
  final String bookingId;
  final String pnr;
  final String gdspnr;
  final double totalFare;
  final String originalFare;
  final double basePrice;
  final double tax;
  final double agentCommission;
  final double agentTdsCommission;
  final double tboCancellationFare;
  final double voidFare;
  final double dateChangeFare;
  final double trvlusRefundFare;
  final double refundAMT;
  final double extraServiceAMT;
  final double reTotalamt;
  final int verifyStatus;
  final int sendToRefundStatus;
  final double commissionAmt;
  final double commisionPercentageAmount;
  final double serviceTax;
  final double agentbalance;
  final String originCityName;
  final String destinationCityName;
  final String createdAt;
  final String updatedAt;
  final int userId;
  final double tboTds;
  final String agentCode;
  final String firstName;
  final String mobile;
  final String email;
  final String customerStatus;
  final List<PassengerDetails> passengerDetails;
  final String status;
  final String travelDate;
  final String returnDate;
  final int convenienceFee;
  final double customerCouponDiscount;

  Data({
    required this.id,
    required this.appReference,
    required this.bookingId,
    required this.pnr,
    required this.gdspnr,
    required this.totalFare,
    required this.originalFare,
    required this.basePrice,
    required this.tax,
    required this.agentCommission,
    required this.agentTdsCommission,
    required this.tboCancellationFare,
    required this.voidFare,
    required this.dateChangeFare,
    required this.trvlusRefundFare,
    required this.refundAMT,
    required this.extraServiceAMT,
    required this.reTotalamt,
    required this.verifyStatus,
    required this.sendToRefundStatus,
    required this.commissionAmt,
    required this.commisionPercentageAmount,
    required this.serviceTax,
    required this.agentbalance,
    required this.originCityName,
    required this.destinationCityName,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.tboTds,
    required this.agentCode,
    required this.firstName,
    required this.mobile,
    required this.email,
    required this.customerStatus,
    required this.passengerDetails,
    required this.status,
    required this.travelDate,
    required this.returnDate,
    required this.convenienceFee,
    required this.customerCouponDiscount,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? 0,
      appReference: json['app_reference'] ?? '',
      bookingId: json['booking_id'] ?? '',
      pnr: json['pnr'] ?? '',
      gdspnr: json['gdspnr'] ?? '',
      totalFare: (json['totalFare'] ?? 0).toDouble(),
      originalFare: json['originalFare'] ?? '',
      basePrice: (json['base_price'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      agentCommission: (json['agent_commission'] ?? 0).toDouble(),
      agentTdsCommission: (json['agent_tdsCommission'] ?? 0).toDouble(),
      tboCancellationFare: (json['tboCancellationFare'] ?? 0).toDouble(),
      voidFare: (json['voidFare'] ?? 0).toDouble(),
      dateChangeFare: (json['dateChangeFare'] ?? 0).toDouble(),
      trvlusRefundFare: (json['trvlusRefundFare'] ?? 0).toDouble(),
      refundAMT: (json['refundAMT'] ?? 0).toDouble(),
      extraServiceAMT: (json['extraServiceAMT'] ?? 0).toDouble(),
      reTotalamt: (json['re_totalamt'] ?? 0).toDouble(),
      verifyStatus: json['verify_status'] ?? 0,
      sendToRefundStatus: json['send_to_refund_status'] ?? 0,
      commissionAmt: (json['commission_amt'] ?? 0).toDouble(),
      commisionPercentageAmount:
          (json['commision_percentage_amount'] ?? 0).toDouble(),
      serviceTax: (json['service_tax'] ?? 0).toDouble(),
      agentbalance: (json['agentbalance'] ?? 0).toDouble(),
      originCityName: json['originCityName'] ?? '',
      destinationCityName: json['destinationCityName'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      userId: json['user_id'] ?? 0,
      tboTds: (json['tbo_tds'] ?? 0).toDouble(),
      agentCode: json['agent_code'] ?? '',
      firstName: json['first_name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      customerStatus: json['customer_status'] ?? '',
      passengerDetails: List.from(json['passenger_details'] ?? [])
          .map((e) => PassengerDetails.fromJson(e))
          .toList(),
      status: json['status'] ?? '',
      travelDate: json['travel_date'] ?? '',
      returnDate: json['return_date'] ?? '',
      convenienceFee: json['convenience_fee'] ?? 0,
      customerCouponDiscount:
          (json['customer_coupon_discount'] ?? 0).toDouble(),
    );
  }
}

class PassengerDetails {
  final String PAN;
  final List<dynamic> ssr;
  final String city;
  final Fare fare;
  final String email;
  final int paxId;
  final String title;
  final int gender;
  final Ticket ticket;
  final int paxType;
  final String? ffNumber;
  final String lastName;
  final String contactNo;
  final String firstName;
  final bool isLeadPax;
  final bool isReissued;
  final String passportNo;
  final String countryCode;
  final String dateOfBirth;
  final String nationality;
  final String addressLine1;
  final String? ffAirlineCode;
  final bool isPanRequired;
  final BarcodeDetails barcodeDetails;
  final dynamic segmentDetails;
  final List<DocumentDetails> documentDetails;
  final dynamic guardianDetails;
  final bool isPassportRequired;
  final List<SegmentAdditionalInfo> segmentAdditionalInfo;

  PassengerDetails({
    required this.PAN,
    required this.ssr,
    required this.city,
    required this.fare,
    required this.email,
    required this.paxId,
    required this.title,
    required this.gender,
    required this.ticket,
    required this.paxType,
    this.ffNumber,
    required this.lastName,
    required this.contactNo,
    required this.firstName,
    required this.isLeadPax,
    required this.isReissued,
    required this.passportNo,
    required this.countryCode,
    required this.dateOfBirth,
    required this.nationality,
    required this.addressLine1,
    this.ffAirlineCode,
    required this.isPanRequired,
    required this.barcodeDetails,
    this.segmentDetails,
    required this.documentDetails,
    this.guardianDetails,
    required this.isPassportRequired,
    required this.segmentAdditionalInfo,
  });

  factory PassengerDetails.fromJson(Map<String, dynamic> json) {
    return PassengerDetails(
      PAN: json['PAN'] ?? '',
      ssr: List.from(json['Ssr'] ?? []),
      city: json['City'] ?? '',
      fare: Fare.fromJson(json['Fare'] ?? {}),
      email: json['Email'] ?? '',
      paxId: json['PaxId'] ?? 0,
      title: json['Title'] ?? '',
      gender: json['Gender'] ?? 0,
      ticket: Ticket.fromJson(json['Ticket'] ?? {}),
      paxType: json['PaxType'] ?? 0,
      ffNumber: json['FFNumber'],
      lastName: json['LastName'] ?? '',
      contactNo: json['ContactNo'] ?? '',
      firstName: json['FirstName'] ?? '',
      isLeadPax: json['IsLeadPax'] ?? false,
      isReissued: json['IsReissued'] ?? false,
      passportNo: json['PassportNo'] ?? '',
      countryCode: json['CountryCode'] ?? '',
      dateOfBirth: json['DateOfBirth'] ?? '',
      nationality: json['Nationality'] ?? '',
      addressLine1: json['AddressLine1'] ?? '',
      ffAirlineCode: json['FFAirlineCode'],
      isPanRequired: json['IsPANRequired'] ?? false,
      barcodeDetails: BarcodeDetails.fromJson(json['BarcodeDetails'] ?? {}),
      segmentDetails: json['SegmentDetails'],
      documentDetails: List.from(json['DocumentDetails'] ?? [])
          .map((e) => DocumentDetails.fromJson(e))
          .toList(),
      guardianDetails: json['GuardianDetails'],
      isPassportRequired: json['IsPassportRequired'] ?? false,
      segmentAdditionalInfo: List.from(json['SegmentAdditionalInfo'] ?? [])
          .map((e) => SegmentAdditionalInfo.fromJson(e))
          .toList(),
    );
  }
}

class Fare {
  final double baseFare;
  final double tax;
  final double publishedFare;
  final double commissionEarned;

  Fare({
    required this.baseFare,
    required this.tax,
    required this.publishedFare,
    required this.commissionEarned,
  });

  factory Fare.fromJson(Map<String, dynamic> json) {
    return Fare(
      baseFare: (json['BaseFare'] ?? 0).toDouble(),
      tax: (json['Tax'] ?? 0).toDouble(),
      publishedFare: (json['PublishedFare'] ?? 0).toDouble(),
      commissionEarned: (json['CommissionEarned'] ?? 0).toDouble(),
    );
  }
}

class Ticket {
  final String status;
  final int ticketId;
  final String ticketNumber;

  Ticket({
    required this.status,
    required this.ticketId,
    required this.ticketNumber,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      status: json['Status'] ?? '',
      ticketId: json['TicketId'] ?? 0,
      ticketNumber: json['TicketNumber'] ?? '',
    );
  }
}

class BarcodeDetails {
  final int id;
  final List<Barcode> barcode;

  BarcodeDetails({
    required this.id,
    required this.barcode,
  });

  factory BarcodeDetails.fromJson(Map<String, dynamic> json) {
    return BarcodeDetails(
      id: json['Id'] ?? 0,
      barcode: List.from(json['Barcode'] ?? [])
          .map((e) => Barcode.fromJson(e))
          .toList(),
    );
  }
}

class Barcode {
  final int index;
  final String format;
  final String content;

  Barcode({
    required this.index,
    required this.format,
    required this.content,
  });

  factory Barcode.fromJson(Map<String, dynamic> json) {
    return Barcode(
      index: json['Index'] ?? 0,
      format: json['Format'] ?? '',
      content: json['Content'] ?? '',
    );
  }
}

class DocumentDetails {
  final int paxId;
  final String documentNumber;
  final String documentTypeId;

  DocumentDetails({
    required this.paxId,
    required this.documentNumber,
    required this.documentTypeId,
  });

  factory DocumentDetails.fromJson(Map<String, dynamic> json) {
    return DocumentDetails(
      paxId: json['PaxId'] ?? 0,
      documentNumber: json['DocumentNumber'] ?? '',
      documentTypeId: json['DocumentTypeId'] ?? '',
    );
  }
}

class SegmentAdditionalInfo {
  final String baggage;
  final String fareBasis;

  SegmentAdditionalInfo({
    required this.baggage,
    required this.fareBasis,
  });

  factory SegmentAdditionalInfo.fromJson(Map<String, dynamic> json) {
    return SegmentAdditionalInfo(
      baggage: json['Baggage'] ?? '',
      fareBasis: json['FareBasis'] ?? '',
    );
  }
}
