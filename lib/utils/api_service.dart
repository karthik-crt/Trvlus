import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/addstatus.dart' as addstatus;
import '../models/bookinghistory.dart' as booking_history;
import '../models/countrycode.dart' as country_code;
import '../models/farequote.dart' as fareQuote;
import '../models/farerule.dart' as fare;
import '../models/search_data.dart' as search;
import '../models/ssr.dart' as ssrdata;

late GlobalKey<NavigatorState> _navigatorKey;

clearUserData() async {}

class ApiBaseHelper {
  initApiService(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  // LOCAL IP
  static const _baseUrl = 'http://192.168.0.6:8000/api/';

  // LIVE
  // static const _baseUrl = 'https://dev-api.trvlus.com/api/';

  // TBO TEST
  // 'http://Sharedapi.tektravels.com/SharedData.svc/rest/';

  // "http://api.tektravels.com/BookingEngineService_Air/AirService.svc/rest/";
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 300),
      /* receiveDataWhenStatusError: true,
      receiveTimeout: const Duration(seconds: 300),
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,*/
      // receiveTimeout: 3000,
    ),
  );

  Map<String, dynamic> decodeBase64Response(Map<String, dynamic> res) {
    try {
      const secretKey = 'ThisIsASecretKey'; // Move key inside

      final iv = encrypt.IV(base64Decode(res['iv']));
      final encryptedData =
          encrypt.Encrypted(base64Decode(res['encrypted_data']));
      final key = encrypt.Key.fromUtf8(secretKey);

      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
      );

      final decrypted = encrypter.decrypt(encryptedData, iv: iv);
      print("✅ Decrypted String: $decrypted");

      return jsonDecode(decrypted);
    } catch (e) {
      print("❌ Decryption failed: $e");
      return res;
    }
  }

  dynamic _returnResponse(Response response) {
    print("response.statusCode");
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        var responseJson = response.data;
        return responseJson;
      case 201:
        var responseJson = response.data;
        return responseJson;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
        throw UnAuthorisedException(response.data.toString());
      case 403:
        throw UnAuthorisedException(response.data.toString());

      case 500:
      default:
        throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }

  Future<Map<String, String>> getMainHeaders() async {
    String? token = "";
    Map<String, String> headers = {'Content-Type': 'application/json'};
    token = await getToken();
    if (token != null) {
      headers['Authorization'] =
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoyMDc1ODk0NjQ3LCJpYXQiOjE3NjA1MzQ2NDcsImp0aSI6IjdkYmVmZTk5NDk0ZDQ0N2ZhZWNmZjU2NDc2OTZjMGVjIiwidXNlcl9pZCI6MzZ9.TxFWyvZqr9M_GZpXQ_dorY2eGWsT8aGKefhLH6t9BZU';
    }
    return headers;
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final access = prefs.getString("access_token");
    return access ?? "";
  }

  Future<dynamic> get(String url) async {
    String params = "";

    var apiUrl = _baseUrl + url + params;
    var headers = getMainHeaders();
    print(headers);

    dynamic responseJson;
    try {
      final response = await dio.get(
        apiUrl,
        options: Options(headers: await headers),
      );
      responseJson = _returnResponse(response);
    } catch (e) {
      if (e.toString().contains("401")) {
        clearUserData();
        throw Exception('token_expired');
      } else if (e.toString().contains("403")) {
        /*  _showToast(
          _navigatorKey.currentContext!,
          "your_account_is_disabled_Please_contact_admin".tr(),
        );*/
        clearUserData();
        throw Exception('user_inactive');
      } else {
        throw Exception(e.toString());
      }
    }

    return responseJson;
  }

  void _showToast(BuildContext context, message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<dynamic> post(String url,
      [dynamic body, Map<String, String>? customHeaders]) async {
    String apiUrl = _baseUrl + url;
    print("apiUrl Post $apiUrl");

    // Get default headers
    final headers = await getMainHeaders();

    // Merge custom headers if provided
    if (customHeaders != null) {
      // headers.addAll(customHeaders);
    }

    dynamic responseJson;
    print("TICKET REQUEST");
    debugPrint('bodybody $body', wrapWidth: 3000);
    try {
      final response = await dio.post(
        apiUrl,
        data: body,
        options: (url == "ticketInvoice" || url == "ticketsearch")
            ? Options(headers: headers)
            : null,
      );
      print("reponse Data Data ${response}");
      responseJson = _returnResponse(response);
    } catch (e) {
      print("POST ERROR: $e");
      if (e.toString().contains("401")) {
        clearUserData();
        throw Exception('token_expired');
      } else if (e.toString().contains("403")) {
        clearUserData();
        throw Exception('user_inactive');
      } else {
        throw Exception(e.toString());
      }
    }

    return responseJson;
  }

  Future<dynamic> put(String url, [dynamic body]) async {
    var headers = getMainHeaders();
    dynamic responseJson;
    try {
      final response = await dio.put(
        url,
        data: jsonEncode(body),
        options: Options(headers: await headers),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    var headers = getMainHeaders();
    dynamic apiResponse;
    try {
      final response = await dio.delete(
        url,
        //  options: Options(headers: await headers),
      );
      apiResponse = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return apiResponse;
  }
}

class ApiService {
  ApiService();

  initApiService(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  final ApiBaseHelper _helper = ApiBaseHelper();
  String? _tokenId; // will hold the token
  String? get tokenId => _tokenId;

  String? accessToken;

  // BACKEND CONNECTION
  // FLIGHTAUTHENTICATE
  Future<String?> userAuthenticate() async {
    print("Calling Authenticate");
    final authenticate = {"id": "1"};
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token");
    print("accessToken$accessToken");
    try {
      final response = await _helper.dio.post(
        "flightAuthenticate",
        data: authenticate,
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
          },
        ),
      );
      print("Authenticate response: ${response.data}");
      // final decode = _helper.decodeBase64Response(response.data);
      // print("decodedecode$decode");
      final decode = response.data;
      _tokenId = decode["TokenId"];
      final token = await SharedPreferences.getInstance();
      print("prefs$token");
      await token.setString('tokenId', _tokenId!);
      return _tokenId;
    } catch (e) {
      print("❌ Authentication failed: $e");
      rethrow;
    }
  }

  // FLIGHTSEARCH BEFORE
  Future<String?> flightAuthenticate() async {
    try {
      final response = await _helper.dio.post(
        "mobileFlightAuth",
      );
      final decode = _helper.decodeBase64Response(response.data);
      print("Authenticate response mobile: $decode");
      print("response$response");
      _tokenId = decode["TokenId"];
      final token = await SharedPreferences.getInstance();
      print("prefs$token");
      await token.setString('tokenId', _tokenId!);
      return _tokenId;
    } catch (e) {
      print("❌ Authentication failed: $e");
      rethrow;
    }
  }

  // OTP
  Future<Map<String, dynamic>> otpRequest(String mobileNumber) async {
    final authenticate = {
      "mobile_number": mobileNumber,
    };

    print("Sending OTP request for: $mobileNumber");

    try {
      final response = await _helper.post("otp-request", authenticate);
      final decode = _helper.decodeBase64Response(response);

      print("OTP Request Success: $decode");
      return decode;
    } catch (e) {
      print("OTP Request Failed: $e");
      rethrow;
    }
  }

  // OTP VERIFY
  Future<Map<String, dynamic>> otpVerify(String mobileNumber, otp) async {
    final authenticate = {"mobile_number": mobileNumber, "otp": otp};
    print("VERIFY OTP request for: $authenticate");

    try {
      final response = await _helper.post("otp-verify", authenticate);
      print("responseresponse$response");
      final decode = _helper.decodeBase64Response(response);
      print("Login Success: $decode");

      // ✅ Extract user ID
      final userId = response['data']['id'];
      print("User ID: $userId");
      final accessToken = response['access_token'];
      print("accessToken$accessToken");

      // ✅ Store it in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId.toString());
      await prefs.setString('access_token', accessToken);

      print("User ID saved in SharedPreferences ✅");

      return response;
    } catch (e) {
      print("OTP Request Failed: $e");
      rethrow;
    }
  }

  // DELETE USER PROFILE

  Future<Map<String, dynamic>> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user_id');
    print("DELETE USER PROFILE$user");
    final authenticate = {"id": user};
    print("Deleted request for:$authenticate ");
    try {
      final response = await _helper.delete(
        "delete-user?id=$user",
      );
      // final decode = _helper.decodeBase64Response(response);
      print("Deleted Success: ${response['statusCode']}");
      // await prefs.clear();
      print("Clear all data");
      return response;
    } catch (e) {
      print("Deleted Failed: $e");
      rethrow;
    }
  }

  // FARERULE
  Future<fare.FareRuleData> farerule(String resultIndex, String traceid) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");
    // final accessToken = prefs.getString("access_token");

    if (tokenId == null) {
      throw Exception("TokenId not found in SharedPreferences");
    }

    final fareruleBody = {
      // "EndUserIp": "192.168.11.58",
      "TokenId": tokenId,
      "TraceId": traceid,
      "ResultIndex": resultIndex,
    };
    final response = await _helper.post("mobileFareRule", fareruleBody);
    final decode = _helper.decodeBase64Response(response);

    // final response = await _helper.post(
    //   "fareRule",
    //   fareruleBody,
    //   {
    //     "Authorization": "Bearer $accessToken",
    //   },
    // );
    print("farerule response${jsonEncode(decode)}");
    return fare.fareRuleDataFromJson(decode);
  }

  // FAREQUOTE
  Future<fareQuote.FareQuotesData> farequote(
      String resultIndex, String traceid) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");
    // final accessToken = prefs.getString("access_token");

    if (tokenId == null) {
      throw Exception("TokenId not found in SharedPreferences");
    }

    final farequoteBody = {
      // "EndUserIp": "192.168.11.58",
      "TokenId": tokenId,
      "TraceId": traceid,
      "ResultIndex": resultIndex,
    };
    // print("FareQuote request: $farequoteBody");
    final response = await _helper.post("mobileFareQuote", farequoteBody);
    final decode = _helper.decodeBase64Response(response);

    // final response = await _helper.post(
    //   "fareQuote",
    //   farequoteBody,
    //   {
    //     "Authorization": "Bearer $accessToken",
    //   },
    // );
    print("FareQuote response${jsonEncode(decode)}");
    return fareQuote.fareQuotesDataFromJson(decode);
  }

  // SSR
  Future<ssrdata.SsrData> ssr(String resultIndex, String traceid) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");
    final accessToken = prefs.getString("access_token");

    if (tokenId == null) {
      throw Exception("TokenId not found in SharedPreferences");
    }

    final ssrBody = {
      // "EndUserIp": "192.168.11.58",
      "TokenId": tokenId,
      "TraceId": traceid,
      "ResultIndex": resultIndex,
    };
    // print("SSR request: $ssrBody");
    final response = await _helper.post("mobileSSR", ssrBody);
    final decode = _helper.decodeBase64Response(response);

    // final response = await _helper.post(
    //   "getExtreaService",
    //   ssrBody,
    //   {
    //     "Authorization": "Bearer $accessToken",
    //   },
    // );
    print("SSR response${jsonEncode(decode)}");
    return ssrdata.ssrDataFromJson(decode);
  }

  //HOMEPAGE DATE PICKER
  Future<Map<String, dynamic>> getCalendarFare(
    String origin,
    String destination,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("tokenId");

    if (token == null) {
      throw Exception("TokenId not found in SharedPreferences");
    }

    final body = {
      "EndUserIp": "192.168.1.10",
      "TokenId": token,
      "JourneyType": "1",
      "PreferredAirlines": null,
      "Segments": [
        {
          "Origin": origin,
          "Destination": destination,
          "FlightCabinClass": "2",
          "PreferredDepartureTime": "2025-10-28T00:00:00"
        }
      ],
      "Sources": null
    };
    print("hello");
    print("body$body");

    try {
      final response = await _helper.post(
        "GetCalendarFare",
        body,
      );
      print("response$response");

      return response; // assuming Dio already decodes JSON
    } catch (e) {
      print("Error fetching calendar fare: $e");
      throw Exception("Failed to fetch calendar fare");
    }
  }

  // TICKET
  Future<Map<String, dynamic>> ticket(
    String resultIndex,
    String traceid,
    flightNumber,
    airlineName,
    depTime,
    depDate,
    airportName,
    arrTime,
    arrDate,
    desairportName,
    duration,
    airlineCode,
    cityCode,
    descityCode,
    cityName,
    descityName,
    Map<String, dynamic> passenger,
    Map<String, dynamic> childpassenger,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");
    final accessToken = prefs.getString("access_token");

    final savedResultIndex = prefs.getString("ResultIndex");
    final flightnumber = prefs.getString("FlightNumber");
    final fare = await SharedPreferences.getInstance();
    final baseFare = fare.getString('BaseFare');
    print("baseFare$baseFare");
    final tax = fare.getString('Tax');
    print("tax$tax");
    final fromorigin = fare.getString('Origin');
    final todestination = fare.getString(
      'Destination',
    );
    // final depDate = fare.getString(
    //   'depTime',
    // );
    print("fromorigin$fromorigin");
    print("todestination$todestination");
    print("passengeradult${passenger['Firstname']}");
    print("passengeradult${passenger['lastname']}");
    print("passengeradult${passenger['mobile']}");
    print("passengeradult${passenger['Passport No']}");
    print("passengeradult${passenger['email']}");
    print("passengeradult${passenger['Date of Birth']}");
    print("passengeradult${passenger['Expiry']}");
    print("passengeradult${passenger['Nationality']}");
    print("passengeradult${passenger['IssusingCountry']}");
    print("passengeradult${passenger['gender']}");

    final gender = passenger['gender'] == 'MALE' ? 1 : 2;
    print("gender$gender");

    final dob = passenger['Date of Birth'];
    print("dateofbirth$dob");
    final parsedDate = DateFormat('dd-MM-yyyy').parse(dob);
    final formattedDOB = DateFormat('yyyy-MM-dd').format(parsedDate);
    print("formattedDOB$formattedDOB");

    if (tokenId == null) {
      throw Exception("TokenId not found in SharedPreferences");
    }

    /// 1️⃣ Passenger array
    final passengersArray = [
      {
        "Title": "Mr",
        "FirstName": passenger['Firstname'],
        "LastName": passenger['lastname'],
        "PaxType": 1,
        "DateOfBirth": "${formattedDOB}T00:00:00",
        "Gender": 1,
        "PassportNo": passenger['Passport No'],
        "PassportExpiry": "2025-12-06T00:00:00",
        "AddressLine1": "",
        "AddressLine2": "",
        "Fare": {
          "BaseFare": baseFare,
          "Tax": tax,
          "YQTax": 0.0,
          "AdditionalTxnFeePub": 0.0,
          "AdditionalTxnFeeOfrd": 0.0,
          "OtherCharges": 0.0
        },
        "City": "",
        "CountryCode": "",
        "CountryName": passenger['IssusingCountry'],
        "Nationality": passenger['Nationality'],
        "ContactNo": passenger['mobile'],
        "Email": passenger['email'],
        "IsLeadPax": true,
        "FFAirlineCode": "",
        "FFNumber": "",
        "GSTCompanyAddress": "",
        "GSTCompanyContactNumber": "",
        "GSTCompanyName": "",
        "GSTNumber": "",
        "GSTCompanyEmail": ""
      }
    ];
    if (childpassenger != null && childpassenger.isNotEmpty) {
      passengersArray.add({
        "Title": "Master",
        "FirstName": childpassenger['Firstname'],
        "LastName": childpassenger['lastname'],
        "PaxType": 3, // child
        "DateOfBirth": childpassenger['DateOfBirth'] ?? "",
        "Gender": childpassenger['gender'],
        "PassportNo": childpassenger['PassportNo'] ?? "",
        "PassportExpiry": childpassenger['Expiry'] ?? "",
        "AddressLine1": "123, Test",
        "AddressLine2": "",
        "Fare": {
          "BaseFare": baseFare, // or child-specific fare
          "Tax": tax,
          "YQTax": 0.0,
          "AdditionalTxnFeePub": 0.0,
          "AdditionalTxnFeeOfrd": 0.0,
          "OtherCharges": 0.0
        },
        "City": "Gurgaon",
        "CountryCode": "IN",
        "CountryName": "India",
        "Nationality": "IN",
        "ContactNo": "9879879877",
        "Email": "childemail@tbtq.in",
        "IsLeadPax": false,
      });
    }

    debugPrint("passengersArray$passengersArray", wrapWidth: 3000);
    final journeyList = [
      {
        "Arrival": arrDate,
        "Baggage": "15 Kilograms",
        "Depature": depDate,
        "duration": duration,
        "noofstop": 1,
        "ToCityName": descityName,
        "ArrivalTime": arrTime,
        "LayOverTime": "undefined Mins",
        "CabinBaggage": "7 KG",
        "DepatureTime": depTime,
        "FlightNumber": flightNumber,
        "FromCityName": cityName,
        "OperatorCode": airlineCode,
        "OperatorName": airlineName,
        "durationTime": "0 Mins",
        "ToAirportCode": descityCode,
        "ToAirportName": desairportName,
        "FromAirportCode": cityCode,
        "FromAirportName": airportName
      }
    ];

    /// 3️⃣ Confirm Booking Params (converted from Angular version)
    final confirmBookingParams = {
      "PreferredCurrency": null,
      "ResultIndex": savedResultIndex,
      "AgentReferenceNo": "sonam1234567890",
      "Passengers": passengersArray,
      "TokenId": tokenId,
      "TraceId": traceid,
      "app_reference": "appRef123", // replace with your actual value
      "SequenceNumber": "0",
      "result_token": "resultToken123", // replace with actual value
      "passenger_details": passengersArray,
      "wallet_retake_params": {}, // fill as per your app
      "wallet_update_params": {}, // fill as per your app
      "user": 6, // replace with actual value
      "role": 3, // replace with actual value
      "document_type": "Passport",
      "commission_amt": 100, // double.parse if numeric
      "service_tax": 50,
      "document_number": "A1234567",
      "journey_list": journeyList,
      "checkin_adult": "1",
      "cabin_adult": "Economy",
      "reissue_charge": 0,
      "cancellation_charge": 0,
      "totalpassengers": passengersArray.length,
      "base_price": baseFare,
      "tax": tax,
      "agentbalance": 0.0,
      "agent_commission": 0.0,
      "agent_tdsCommission": 0.0,
      "origin": fromorigin,
      "destination": todestination,
      "travel_date": depDate,
      "return_date": "",
      "commision_percentage_amount": 10.0,
      "excessAmount": 0.0,
    };

    // debugPrint("ticketBody: $ticketBody");
    debugPrint("confirmBookingParams: $confirmBookingParams", wrapWidth: 2000);

    /// 4️⃣ API call
    final response = await _helper.post(
      "ticketInvoice",
      confirmBookingParams,
    );
    debugPrint("ticketResponse: ${jsonEncode(response)}", wrapWidth: 3000);

    return response;
  }

  // BOOKING HISTORY
  Future<booking_history.BookingHistory> bookingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");
    final accessToken = prefs.getString("access_token");

    if (tokenId == null) {
      throw Exception("TokenId not found in SharedPreferences");
    }

    final bookingHistoryBody = {};
    print("bookingHistoryBody request: $bookingHistoryBody");

    final response = await _helper.get(
      "ticketsearch?fromdate=2025-10-16&todate=2025-10-22&userid=6&mobile=1",
    );
    final bookings = response['data']; // List of bookings
    printFullResponse("bookings$bookings");
    debugPrint("booking${jsonEncode(bookings)}", wrapWidth: 1500);
    print("bookingHistoryBody response${jsonEncode(response)}");
    return booking_history.bookingHistoryFromJson(response);
  }

  void printFullResponse(String text) {
    final pattern = RegExp('.{1,1000}'); // split into 1000-character chunks
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  //   CountryCode
  Future<country_code.Countrycode> countryCode() async {
    final response = await _helper.get(
      "countryCode",
    );

    print("COUNTRYCODE response${jsonEncode(response)}");
    return country_code.countrycodeFromJson(response);
  }

  // SEARCHFLIGHT
  Future<search.SearchData> getSearchResult(
    String airportCode,
    String fromAirport,
    String toairportCode,
    String toAirport,
    String selectedDepDate,
    String selectedReturnDate,
    String selectedTripType,
    int adultCount,
    int? childCount,
    int? infantCount,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final adult = adultCount;
    final child = childCount;
    final infant = infantCount;
    String formatted = selectedDepDate.toString().substring(0, 10);
    int triptype = selectedTripType == "One way" ? 1 : 2;
    String formattedReturn = selectedReturnDate.toString().substring(0, 10);
    final prefToken = await SharedPreferences.getInstance();
    final tokenId = prefToken.getString("tokenId");
    // final accessToken = prefs.getString("access_token");
    // print("accessToken$accessToken");

    final params = {
      // "EndUserIp": "192.168.0.2",
      "TokenId": tokenId,
      "AdultCount": adult,
      "ChildCount": child,
      "InfantCount": infant,
      "DirectFlight": "false",
      "OneStopFlight": "false",
      "JourneyType": triptype,
      "PreferredAirlines": null,
      "Segments": triptype == 1
          ? [
              {
                "Origin": airportCode,
                "Destination": toairportCode,
                "FlightCabinClass": "1",
                "PreferredDepartureTime": formatted + "T00:00:00",
                "PreferredArrivalTime": formatted + "T00:00:00",
              },
            ]
          : [
              {
                "Origin": airportCode,
                "Destination": toairportCode,
                "FlightCabinClass": "1",
                "PreferredDepartureTime": formatted + "T00:00:00",
                "PreferredArrivalTime": formatted + "T00:00:00",
              },
              {
                "Origin": toairportCode,
                "Destination": airportCode,
                "FlightCabinClass": "1",
                "PreferredDepartureTime": formattedReturn + "T00:00:00",
                "PreferredArrivalTime": formattedReturn + "T00:00:00",
              }
            ],
      "Sources": null
    };
    print("params$params");
    final response = await _helper.post("mobileFlightSearch", params);
    final decode = _helper.decodeBase64Response(response);
    print("hello${jsonEncode(decode)}");
    return search.searchDataFromJson(decode);
  }

// COMMISSION PERCENTAGE
// Future<Map<String, dynamic>> commissionPercentage() async {
//   final prefs = await SharedPreferences.getInstance();
//   final tokenId = prefs.getString("tokenId");
//   final accessToken = prefs.getString("access_token");
//
//   if (tokenId == null) {
//     throw Exception("TokenId not found in SharedPreferences");
//   }
//
//   final commissionPercentageBody = {"country": 1};
//   print("SSR request: $commissionPercentageBody");
//
//   final response = await _helper.get(
//     "commissionPercentage",
//   );
//   print("commissionPercentage response${jsonEncode(response)}");
//   return response;
// }

//   BookingHistory
  Future<country_code.Countrycode> getbookingHsitory() async {
    final response = await _helper.get(
      "countryCode",
    );

    print("COUNTRYCODE response${jsonEncode(response)}");
    return country_code.countrycodeFromJson(response);
  }

  //  ADDSTATUS
  Future<addstatus.CancelReasonData> addStatus() async {
    final response = await _helper.get(
      "addstatus",
    );

    print("addstatus response${jsonEncode(response)}");
    return addstatus.addstatusFromJson(response);
  }

  //   CANCEL REQUEST
  Future<Map<String, dynamic>> cancelRequest({
    required String pnr,
    required String appref,
    int? bookingID,
    required String status,
    required String remark,
    String? selectCancelReason,
  }) async {
    final cancelRequest = {
      "ticketstatus": selectCancelReason,
      "pnr": pnr,
      "booking_id": bookingID.toString(),
      "remarks": remark,
      "trvlus_status": status,
      "app_ref": appref
    };
    print("cancelRequest$cancelRequest");

    final response = await _helper.post("cancel-req", cancelRequest);
    print("cancel response${jsonEncode(response)}");
    return (response);
  }
//-----------------------------------------------------------------------------------------------------------
// TBO TEST ACCOUNT

// Authenticate

// Future<String?> authenticate() async {
//   const authUrl =
//       "http://Sharedapi.tektravels.com/SharedData.svc/rest/Authenticate";
//
//   final authenticate = {
//     "ClientId": "ApiIntegrationNew",
//     "UserName": "trvlus",
//     "Password": "Trvlus@1234",
//     "EndUserIp": "192.168.11.120"
//   };
//   print("authenticate_api$authenticate");
//   print("authUrl$authUrl");
//
//   try {
//     final response = await Dio().post(authUrl, data: authenticate);
//     print("Authenticate response: ${response.data}");
//     _tokenId = response.data["TokenId"];
//     final pref_token = await SharedPreferences.getInstance();
//     print("prefs$pref_token");
//     await pref_token.setString('tokenId', _tokenId!);
//     return _tokenId;
//   } catch (e) {
//     print("❌ Authentication failed: $e");
//     rethrow;
//   }
// }

// SEARCHFLIGHTS

// Future<search.SearchData> getSearchResult(
//     String airportCode,
//     String fromAirport,
//     String toairportCode,
//     String toAirport,
//     String selectedDepDate,
//     String selectedReturnDate,
//     String selectedTripType,
//     int adultCount,
//     int? childCount,
//     int? infantCount,
//     ) async {
//   final prefs = await SharedPreferences.getInstance();
//   final adult = adultCount;
//   final child = childCount;
//   final infant = infantCount;
//   String formatted = selectedDepDate.toString().substring(0, 10);
//   int triptype = selectedTripType == "One way" ? 1 : 2;
//   String formattedReturn = selectedReturnDate.toString().substring(0, 10);
//   final prefToken = await SharedPreferences.getInstance();
//   final tokenId = prefToken.getString("tokenId");
//   // final accessToken = prefs.getString("access_token");
//   // print("accessToken$accessToken");
//
//   final params = {
// "EndUserIp": "192.168.0.2",
//     "TokenId": tokenId,
//     "AdultCount": adult,
//     "ChildCount": child,
//     "InfantCount": infant,
//     "DirectFlight": "false",
//     "OneStopFlight": "false",
//     "JourneyType": triptype,
//     "PreferredAirlines": null,
//     "Segments": triptype == 1
//         ? [
//       {
//         "Origin": airportCode,
//         "Destination": toairportCode,
//         "FlightCabinClass": "1",
//         "PreferredDepartureTime": formatted + "T00:00:00",
//         "PreferredArrivalTime": formatted + "T00:00:00",
//       },
//     ]
//         : [
//       {
//         "Origin": airportCode,
//         "Destination": toairportCode,
//         "FlightCabinClass": "1",
//         "PreferredDepartureTime": formatted + "T00:00:00",
//         "PreferredArrivalTime": formatted + "T00:00:00",
//       },
//       {
//         "Origin": toairportCode,
//         "Destination": airportCode,
//         "FlightCabinClass": "1",
//         "PreferredDepartureTime": formattedReturn + "T00:00:00",
//         "PreferredArrivalTime": formattedReturn + "T00:00:00",
//       }
//     ],
//     "Sources": null
//   };
//   print("params$params");
//   final response = await _helper.post("http://api.tektravels.com/BookingEngineService_Air/AirService.svc/rest/Search", params);
//   final decode = _helper.decodeBase64Response(response);
//
//   // final response = await _helper.post(
//   //   "mobileFlightSearch",
//   //   params,
//   //   {
//   //     "Authorization": "Bearer $accessToken",
//   //   },
//   // );
//   print("hello${jsonEncode(decode)}");
//   return search.searchDataFromJson(decode);
// }

// FARERULE

// Future<fare.FareRuleData> farerule(String resultIndex, String traceid) async {
//   final prefs = await SharedPreferences.getInstance();
//   final tokenId = prefs.getString("tokenId");
//   // final accessToken = prefs.getString("access_token");
//
//   if (tokenId == null) {
//     throw Exception("TokenId not found in SharedPreferences");
//   }
//
//   final fareruleBody = {
// "EndUserIp": "192.168.11.58",
//     "TokenId": tokenId,
//     "TraceId": traceid,
//     "ResultIndex": resultIndex,
//   };
//   final response = await _helper.post("http://api.tektravels.com/BookingEngineService_Air/AirService.svc/rest/FareRule", fareruleBody);
//   final decode = _helper.decodeBase64Response(response);
//
//   // final response = await _helper.post(
//   //   "fareRule",
//   //   fareruleBody,
//   //   {
//   //     "Authorization": "Bearer $accessToken",
//   //   },
//   // );
//   print("farerule response${jsonEncode(decode)}");
//   return fare.fareRuleDataFromJson(decode);
// }

// FAREQUOTE

// Future<fareQuote.FareQuotesData> farequote(
//     String resultIndex, String traceid) async {
//   final prefs = await SharedPreferences.getInstance();
//   final tokenId = prefs.getString("tokenId");
//   // final accessToken = prefs.getString("access_token");
//
//   if (tokenId == null) {
//     throw Exception("TokenId not found in SharedPreferences");
//   }
//
//   final farequoteBody = {
// "EndUserIp": "192.168.11.58",
//     "TokenId": tokenId,
//     "TraceId": traceid,
//     "ResultIndex": resultIndex,
//   };
//   // print("FareQuote request: $farequoteBody");
//   final response = await _helper.post("http://api.tektravels.com/BookingEngineService_Air/AirService.svc/rest/FareQuote", farequoteBody);
//   final decode = _helper.decodeBase64Response(response);
//
//   // final response = await _helper.post(
//   //   "fareQuote",
//   //   farequoteBody,
//   //   {
//   //     "Authorization": "Bearer $accessToken",
//   //   },
//   // );
//   print("FareQuote response${jsonEncode(decode)}");
//   return fareQuote.fareQuotesDataFromJson(decode);
// }

// SSR

//   Future<ssrdata.SsrData> ssr(String resultIndex, String traceid) async {
//     final prefs = await SharedPreferences.getInstance();
//     final tokenId = prefs.getString("tokenId");
//     final accessToken = prefs.getString("access_token");
//
//     if (tokenId == null) {
//       throw Exception("TokenId not found in SharedPreferences");
//     }
//
//     final ssrBody = {
// "EndUserIp": "192.168.11.58",
//       "TokenId": tokenId,
//       "TraceId": traceid,
//       "ResultIndex": resultIndex,
//     };
//     // print("SSR request: $ssrBody");
//     final response = await _helper.post("http://api.tektravels.com/BookingEngineService_Air/AirService.svc/rest/SSR", ssrBody);
//     final decode = _helper.decodeBase64Response(response);
//
//     // final response = await _helper.post(
//     //   "getExtreaService",
//     //   ssrBody,
//     //   {
//     //     "Authorization": "Bearer $accessToken",
//     //   },
//     // );
//     print("SSR response${jsonEncode(decode)}");
//     return ssrdata.ssrDataFromJson(decode);
//   }

// TICKET

// Future<Map<String, dynamic>> ticket(
//     String resultIndex, String traceid) async {
//   final prefs = await SharedPreferences.getInstance();
//   final tokenId = prefs.getString("tokenId");
//
//   final savedResultIndex = prefs.getString("ResultIndex");
//   final flightnumber = prefs.getString("FlightNumber");
//   final fare = await SharedPreferences.getInstance();
//   final baseFare = fare.getString('BaseFare');
//   print("baseFare$baseFare");
//   final tax = fare.getString('Tax');
//   print("tax$tax");
//   final fromorigin = fare.getString('Origin');
//   final todestination = fare.getString(
//     'Destination',
//   );
//   final depDate = fare.getString(
//     'depTime',
//   );
//   print("fromorigin$fromorigin");
//   print("todestination$todestination");
//   print("depDate$depDate");
//
//   if (tokenId == null) {
//     throw Exception("TokenId not found in SharedPreferences");
//   }
//
//   /// 1️⃣ Passenger array
//   final passengersArray = [
//     {
//       "Title": "Mr",
//       "FirstName": "OIRNEGRPN",
//       "LastName": "tbo",
//       "PaxType": 1,
//       "DateOfBirth": "1987-12-06T00:00:00",
//       "Gender": 1,
//       "PassportNo": "KJHHJKHKJH",
//       "PassportExpiry": "2025-12-06T00:00:00",
//       "AddressLine1": "123, Test",
//       "AddressLine2": "",
//       "Fare": {
//         "BaseFare": baseFare,
//         "Tax": tax,
//         "YQTax": 0.0,
//         "AdditionalTxnFeePub": 0.0,
//         "AdditionalTxnFeeOfrd": 0.0,
//         "OtherCharges": 0.0
//       },
//       "City": "Gurgaon",
//       "CountryCode": "IN",
//       "CountryName": "India",
//       "Nationality": "IN",
//       "ContactNo": "9879879877",
//       "Email": "harsh@tbtq.in",
//       "IsLeadPax": true,
//       "FFAirlineCode": "",
//       "FFNumber": "",
//       "GSTCompanyAddress": "",
//       "GSTCompanyContactNumber": "",
//       "GSTCompanyName": "",
//       "GSTNumber": "",
//       "GSTCompanyEmail": ""
//     }
//   ];
//
//   /// 3️⃣ Confirm Booking Params (converted from Angular version)
//   final confirmBookingParams = {
//     "PreferredCurrency": null,
//     "ResultIndex": savedResultIndex,
//     "AgentReferenceNo": "sonam1234567890",
//     "Passengers": passengersArray,
//     "TokenId": tokenId,
//     "TraceId": traceid,
//     "app_reference": "appRef123", // replace with your actual value
//     "SequenceNumber": "0",
//     "result_token": "resultToken123", // replace with actual value
//     "passenger_details": passengersArray,
//     "wallet_retake_params": {}, // fill as per your app
//     "wallet_update_params": {}, // fill as per your app
//     "user": 6, // replace with actual value
//     "role": 3, // replace with actual value
//     "document_type": "Passport",
//     "commission_amt": 100, // double.parse if numeric
//     "service_tax": 50,
//     "document_number": "A1234567",
//     "journey_list": [],
//     "checkin_adult": "1",
//     "cabin_adult": "Economy",
//     "reissue_charge": 0,
//     "cancellation_charge": 0,
//     "totalpassengers": passengersArray.length,
//     "base_price": baseFare,
//     "tax": tax,
//     "agentbalance": 0.0,
//     "agent_commission": 0.0,
//     "agent_tdsCommission": 0.0,
//     "origin": fromorigin,
//     "destination": todestination,
//     "travel_date": depDate,
//     "return_date": "",
//     "commision_percentage_amount": 10.0,
//     "excessAmount": 0.0,
//   };
//
//   // debugPrint("ticketBody: $ticketBody");
//   debugPrint("confirmBookingParams: $confirmBookingParams");
//
//   /// 4️⃣ API call
//   final response = await _helper.post("http://api.tektravels.com/BookingEngineService_Air/AirService.svc/rest/Ticket", confirmBookingParams);
//   debugPrint("ticketResponse: ${jsonEncode(response)}");
//
//   return response;
// }

// BOOKING HISTORY

// Future<Map<String, dynamic>> bookingHistory() async {
//   final prefs = await SharedPreferences.getInstance();
//   final tokenId = prefs.getString("tokenId");
//   final accessToken = prefs.getString("access_token");
//
//   if (tokenId == null) {
//     throw Exception("TokenId not found in SharedPreferences");
//   }
//
//   final bookingHistoryBody = {};
//   print("bookingHistoryBody request: $bookingHistoryBody");
//
//   final response = await _helper.get(
//     "http://api.tektravels.com/BookingEngineService_Air/AirService.svc/rest/GetBookingDetails",
//   );
//   final bookings = response['data']; // List of bookings
//   printFullResponse("bookings$bookings");
//   print("bookingHistoryBody response${jsonEncode(response)}");
//   return response;
// }
}

Map<String, dynamic> decodeBase64Response(
    Map<String, dynamic> res, String secretKey) {
  try {
    // Parse Base64 IV
    final ivBytes = base64Decode(res['iv']);
    final iv = encrypt.IV(ivBytes);

    // Secret key must be 16/24/32 bytes for AES-128/192/256
    final key = encrypt.Key.fromUtf8(secretKey);

    // Create AES encrypter
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );

    // Decode Base64 encrypted data
    final encryptedBytes = base64Decode(res['encrypted_data']);
    final encrypted = encrypt.Encrypted(encryptedBytes);

    // Decrypt to string
    final decryptedString = encrypter.decrypt(encrypted, iv: iv);
    print("decryptedString$decryptedString");

    // Parse JSON
    return jsonDecode(decryptedString);
  } catch (e) {
    print("ssdsdsdds");
    print(e.toString());
    // If decryption fails, return original response
    return res;
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnAuthorisedException extends AppException {
  UnAuthorisedException([message]) : super(message, "UnAuthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}
