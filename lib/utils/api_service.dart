import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/addstatus.dart' as addstatus;
import '../models/bookinghistory.dart' as booking_history;
import '../models/commissionpercentage.dart' as commissionpercentage;
import '../models/countrycode.dart' as country_code;
import '../models/farequote.dart' as fareQuote;
import '../models/farerule.dart' as fare;
import '../models/getbookingdetailsid.dart' as bookinghistoryID;
import '../models/getprofile.dart' as profileupdatation;
import '../models/search_data.dart' as search;
import '../models/ssr.dart' as ssrdata;

late GlobalKey<NavigatorState> _navigatorKey;

clearUserData() async {}

class ApiBaseHelper {
  initApiService(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  List<Map<String, dynamic>> passengersList = [];

  // LOCAL IP
  static const _baseUrl = 'http://192.168.0.11:8000/api/';

  // LIVE
  // static const _baseUrl = 'https://dev-api.trvlus.com/api/';

  // TBO TEST
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
    print("res$res");
    // try {
    const secretKey = 'ThisIsASecretKey'; // Move key inside

    final iv = encrypt.IV(base64Decode(res['iv'] ?? "0"));
    final encryptedData = encrypt.Encrypted(
      base64Decode(res['encrypted_data']),
    );
    final key = encrypt.Key.fromUtf8(secretKey);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );

    final decrypted = encrypter.decrypt(encryptedData, iv: iv);
    print("✅ Decrypted String: $decrypted");

    return jsonDecode(decrypted);
    // } catch (e) {
    //   print("❌ Decryption failed: $e");
    //   return res;
    // }
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
    final prefs = await SharedPreferences.getInstance();
    final access = prefs.getString("access_token");

    Map<String, String> headers = {'Content-Type': 'application/json'};

    // Add Authorization only when access token exists
    if (access != null && access.isNotEmpty) {
      headers['Authorization'] = 'Bearer $access';
    }

    print("FINAL HEADERS = $headers");
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

    final headers = await getMainHeaders();
    print("GET HEADERS → $headers");

    try {
      final response = await dio.get(
        apiUrl,
        options: Options(headers: headers),
      );

      return _returnResponse(response);
    } catch (e) {
      print("❌ GET ERROR: $e");

      // 401 handling
      if (e.toString().contains("401")) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');

        if (token != null && token.isNotEmpty && token != "null") {
          clearUserData();
          throw Exception('token_expired');
        }

        print("⚠ 401 but NO TOKEN → allow as guest.");

        // Return a VALID EMPTY RESPONSE
        return {"statusCode": 200, "data": []};
      }

      // 403
      if (e.toString().contains("403")) {
        clearUserData();
        throw Exception('user_inactive');
      }

      throw Exception(e.toString());
    }
  }

  void _showToast(BuildContext context, message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<dynamic> post(
    String url, [
    dynamic body,
    Map<String, String>? customHeaders,
  ]) async {
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
    debugPrint(
      const JsonEncoder.withIndent('  ').convert(body),
      wrapWidth: 7000,
    );
    try {
      final response = await dio.post(
        apiUrl,
        data: body,
        options: (url == "ticketInvoice" ||
                url == "ticketsearch" ||
                url == "noLccBook")
            ? Options(headers: headers)
            : null,
      );
      print("reponse Data Data $response");
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

  Future<dynamic> postCalender(
    String url, [
    dynamic body,
    Map<String, String>? customHeaders,
  ]) async {
    String apiUrl =
        'http://api.tektravels.com/BookingEngineService_Air/AirService.svc/rest/' +
            url;
    print("apiUrl Post $apiUrl");

    // Get default headers
    final headers = await getMainHeaders();

    // Merge custom headers if provided
    if (customHeaders != null) {
      // headers.addAll(customHeaders);
    }

    dynamic responseJson;
    print("TICKET REQUEST");
    debugPrint(
      const JsonEncoder.withIndent('  ').convert(body),
      wrapWidth: 7000,
    );
    try {
      final response = await dio.post(
        apiUrl,
        data: body,
        options: (url == "ticketInvoice" ||
                url == "ticketsearch" ||
                url == "noLccBook")
            ? Options(headers: headers)
            : null,
      );
      print("reponse Data Data $response");
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

  List<Map<String, dynamic>> passengersArray = [];

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
        options: Options(headers: {"Authorization": "Bearer $accessToken"}),
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
      final response = await _helper.dio.post("mobileFlightAuth");
      // final decode = _helper.decodeBase64Response(response.data);
      final decode = response.data;
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
    final authenticate = {"mobile_number": mobileNumber};

    print("Sending OTP request for: $mobileNumber");

    try {
      final response = await _helper.post("otp-request", authenticate);
      // final decode = _helper.decodeBase64Response(response);
      final decode = response;

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
      // final decode = _helper.decodeBase64Response(response);
      final decode = response;
      print("Login Success: $decode");

      // ✅ Extract user ID
      final userId = decode['data']['id'];
      print("User ID: $userId");
      final accessToken = decode['access_token'];
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
      final response = await _helper.delete("delete-user?id=$user");
      final decode = _helper.decodeBase64Response(response);
      // final decode = response;
      print("Deleted Success: ${response['statusCode']}");
      // await prefs.clear();
      print("Clear all data");
      return decode;
    } catch (e) {
      print("Deleted Failed: $e");
      rethrow;
    }
  }

  // FARERULE
  Future<fare.FareRuleData> farerule(String resultIndex, String traceid) async {
    final prefs = await SharedPreferences.getInstance();
    print("fareeeee$resultIndex");
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
    print("fareruleBody$fareruleBody");
    final response = await _helper.post("mobileFareRule", fareruleBody);
    // final decode = _helper.decodeBase64Response(response);
    final decode = response;

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
    String resultIndex,
    String traceid,
  ) async {
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
    // final decode = _helper.decodeBase64Response(response);
    final decode = response;

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
    // final decode = _helper.decodeBase64Response(response);
    final decode = response;
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
          "PreferredDepartureTime": "2025-12-12T00:00:00",
        },
      ],
      "Sources": null,
    };
    print("hello");
    print("body$body");

    try {
      final response = await _helper.postCalender("GetCalendarFare", body);
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      print("FULL CALENDAR API RESPONSE:");
      print(encoder.convert(response));
      return response; // assuming Dio already decodes JSON
    } catch (e) {
      print("Error fetching calendar fare: $e");
      throw Exception("Failed to fetch calendar fare");
    }
  }

  // HOLD TICKET BOOKING

  Future<Map<String, dynamic>> holdTicket(
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
    baseFare,
    tax,
    List<Map<String, dynamic>> passenger,
    List<Map<String, dynamic>> childpassenger,
    List<Map<String, dynamic>> infantpassenger,
    Map<String, dynamic> meal,
    stop,
    journeyList,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");
    print("APICALLING$passenger");
    print("RESULT INDEX$resultIndex");
    print("cityName$cityName");
    print("descityName$descityName");
    print("depDate$depDate");
    final userID = prefs.getString('user_id');

    var passengersArrayData = [];
    var passengersDetailData = [];
    var journeyListarray = [];

    // ADDING ADULTS
    for (var passenger in passenger) {
      print("passengerTotal$passenger");
      // GENDER
      final gender = passenger['gender'] == 'Mr' ? 1 : 2;
      print("gender$gender");

      // // DATEOFBIRTH FORMAT
      final dob = passenger['Date of Birth'];
      print("dateofbirth$dob");
      final parsedDate = DateFormat('dd-MM-yyyy').parse(dob);
      final formattedDOB = DateFormat('yyyy-MM-dd').format(parsedDate);
      print("formattedDOB$formattedDOB");

      //EXPIRYDATE FORMAT
      // final expiry = passenger['Expiry'];
      // print("expiry$expiry");
      // final parsedexpiryDate = DateFormat('dd-MM-yyyy').parse(expiry);
      // final formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedexpiryDate);
      // print("formattedExpiry$formattedExpiry");

      final expiry = passenger['Expiry'];

      String formattedExpiry = "";
      if (expiry != null && expiry.toString().trim().isNotEmpty) {
        final parsedExpiry = DateFormat('dd-MM-yyyy').parse(expiry);
        formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedExpiry);
      } else {
        formattedExpiry = "";
      }

      if (tokenId == null) {
        throw Exception("TokenId not found in SharedPreferences");
      }

      /// 1️⃣ Passenger array
      passengersArrayData.add({
        "Title": passenger['gender'],
        "FirstName": passenger['Firstname'],
        "LastName": passenger['lastname'],
        "PaxType": 1,
        "DateOfBirth": "${formattedDOB}T00:00:00",
        "Gender": gender,
        "PassportNo": passenger['Passport No'] ?? "",
        "PassportExpiry": formattedExpiry.trim().isNotEmpty
            ? "${formattedExpiry}T00:00:00"
            : "",
        "AddressLine1": "NA",
        "AddressLine2": "",
        "Fare": {
          "BaseFare": baseFare,
          "Tax": tax,
          "YQTax": 0.0,
          "AdditionalTxnFeePub": 0.0,
          "AdditionalTxnFeeOfrd": 0.0,
          "OtherCharges": 0.0,
        },
        "City": "NA",
        "CountryCode": "NA",
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
        "GSTCompanyEmail": "",
      });
    }

    // ADDING CHILD
    for (var childpassenger in childpassenger) {
      // GENDER
      final gender = childpassenger['gender'] == 'Mr' ? 1 : 2;
      print("childgender$gender");

      // // DATEOFBIRTH FORMAT
      final dob = childpassenger['Date of Birth'];
      print("dateofbirth$dob");
      final parsedDate = DateFormat('dd-MM-yyyy').parse(dob);
      final formattedDOB = DateFormat('yyyy-MM-dd').format(parsedDate);
      print("childformattedDOB$formattedDOB");

      //EXPIRYDATE FORMAT
      final expiry = childpassenger['Expiry'];

      String formattedExpiry = "";
      if (expiry != null && expiry.toString().trim().isNotEmpty) {
        final parsedExpiry = DateFormat('dd-MM-yyyy').parse(expiry);
        formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedExpiry);
      } else {
        formattedExpiry = "";
      }

      if (childpassenger != null && childpassenger.isNotEmpty) {
        passengersArrayData.add({
          "Title": "Master",
          "FirstName": childpassenger['Firstname'],
          "LastName": childpassenger['lastname'],
          "PaxType": 2, // child
          "DateOfBirth": "${formattedDOB}T00:00:00",
          "Gender": '1',
          "PassportNo": childpassenger['Passport No'] ?? "",
          "PassportExpiry": formattedExpiry.trim().isNotEmpty
              ? "${formattedExpiry}T00:00:00"
              : "",
          "AddressLine1": "NA",
          "AddressLine2": "",
          "Fare": {
            "BaseFare": baseFare, // or child-specific fare
            "Tax": tax,
            "YQTax": 0.0,
            "AdditionalTxnFeePub": 0.0,
            "AdditionalTxnFeeOfrd": 0.0,
            "OtherCharges": 0.0,
          },
          "City": "Gurgaon",
          "CountryCode": "IN",
          "CountryName": "India",
          "Nationality": "IN",
          "ContactNo": childpassenger['mobile'],
          "Email": childpassenger['email'],
          "IsLeadPax": false,
        });
      }
      print("CHILD API SENDING");
    }

    // ADDING INFANT
    for (var infantpassenger in infantpassenger) {
      // GENDER
      final gender = infantpassenger['gender'] == 'Mr' ? 1 : 2;
      print("infantgender$gender");

      // // DATEOFBIRTH FORMAT
      final dob = infantpassenger['Date of Birth'];
      print("dateofbirth$dob");
      final parsedDate = DateFormat('dd-MM-yyyy').parse(dob);
      final formattedDOB = DateFormat('yyyy-MM-dd').format(parsedDate);
      print("childformattedDOB$formattedDOB");

      //EXPIRYDATE FORMAT
      final expiry = infantpassenger['Expiry'];

      String formattedExpiry = "";
      if (expiry != null && expiry.toString().trim().isNotEmpty) {
        final parsedExpiry = DateFormat('dd-MM-yyyy').parse(expiry);
        formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedExpiry);
      } else {
        formattedExpiry = "";
      }
      print("formattedExpiryinfant$formattedExpiry");

      if (infantpassenger != null && infantpassenger.isNotEmpty) {
        passengersArrayData.add({
          "Title": "Master",
          "FirstName": infantpassenger['Firstname'],
          "LastName": infantpassenger['lastname'],
          "PaxType": 3, // child
          "DateOfBirth": "${formattedDOB}T00:00:00",
          "Gender": '1',
          "PassportNo": infantpassenger['Passport No'] ?? "",
          "PassportExpiry": formattedExpiry.trim().isNotEmpty
              ? "${formattedExpiry}T00:00:00"
              : "",
          "AddressLine1": "NA",
          "AddressLine2": "",
          "Fare": {
            "BaseFare": baseFare, // or child-specific fare
            "Tax": tax,
            "YQTax": 0.0,
            "AdditionalTxnFeePub": 0.0,
            "AdditionalTxnFeeOfrd": 0.0,
            "OtherCharges": 0.0,
          },
          "City": "Gurgaon",
          "CountryCode": "IN",
          "CountryName": "India",
          "Nationality": "IN",
          "ContactNo": infantpassenger['mobile'],
          "Email": infantpassenger['email'],
          "IsLeadPax": false,
        });
      }
      print("CHILD API SENDING");
    }
    debugPrint(
      "passengersArray(ADULT,CHILD,INFANT)$passengersArrayData",
      wrapWidth: 5000,
    );

    // JOURNEYLIST
    print("journeyListarray$journeyListarray");
    for (var item in journeyList) {
      print("journeyList$item");
      print("journeyListarray$journeyListarray");

      journeyListarray.add({
        "Baggage": "15 Kilograms",
        "duration": item['duration'] != "" && item['duration'] != null
            ? int.parse(item['duration'].toString())
            : 0,
        "ToCityName": item['toCity'],
        "Arrival": item['arrival'],
        "ArrivalTime": item['arrTime'],
        "LayOverTime": item['layover'],
        "CabinBaggage": "7 KG",
        "Depature": item['departure'],
        "DepatureTime": item['depTime'],
        "FlightNumber": item['flightNumber'],
        "FromCityName": item['fromCity'],
        "OperatorCode": item['airlineCode'],
        "OperatorName": item['airlineName'],
        "noofstop": item['noofstop'],
        "durationTime": "0 Mins",
        "ToAirportCode": item['toAirportCode'],
        "ToAirportName": item['toAirport'],
        "FromAirportCode": item['fromAirportCode'],
        "FromAirportName": item['fromAirport'],
      });
    }

    // MEALS + SEAT + ADULT(passengersDetailData)
    for (var i = 0; i < passenger.length; i++) {
      final p = passenger[i];
      final gender = p['gender'] == 'Mr' ? 1 : 2;

      final dob = DateFormat('dd-MM-yyyy').parse(p['Date of Birth']);
      final formattedDOB = DateFormat('yyyy-MM-dd').format(dob);
      // final expiry = DateFormat('dd-MM-yyyy').parse(p['Expiry']);
      // final formattedExpiry = DateFormat('yyyy-MM-dd').format(expiry);

      final expiry = p['Expiry'];
      print("expiry$expiry");

      String formattedExpiry = "";
      if (expiry != null && expiry.toString().trim().isNotEmpty) {
        final parsedExpiry = DateFormat('dd-MM-yyyy').parse(expiry);
        formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedExpiry);
      } else {
        formattedExpiry = "";
      }
      String paxKey = "Adult ${i + 1}";
      Map<String, dynamic>? paxMeal;

      List<Map<String, dynamic>> passengerMeals = [];
      meal.forEach((routeKey, routeData) {
        if (routeData.containsKey(paxKey)) {
          passengerMeals.addAll(
            List<Map<String, dynamic>>.from(routeData[paxKey]),
          );
        }
      });
      print("passengerMeals$passengerMeals");

      passengersDetailData.add({
        "Title": p['gender'],
        "FirstName": p['Firstname'],
        "LastName": p['lastname'],
        "PaxType": 1,
        "DateOfBirth":
            formattedDOB.isNotEmpty ? "${formattedDOB}T00:00:00" : null,
        "Gender": 1,
        "GSTCompanyAddress": "",
        "GSTCompanyContactNumber": "",
        "GSTCompanyName": "",
        "GSTNumber": "",
        "GSTCompanyEmail": "",
        "PassportNo": p['Passport No'] ?? "",
        "PassportExpiry": formattedExpiry.trim().isNotEmpty
            ? "${formattedExpiry}T00:00:00"
            : "",
        "PassportIssueDate": "",
        "PassportIssueCountryCode": "",
        "AddressLine1": "NA",
        "AddressLine2": "",
        "City": "Gurgaon",
        "CountryCode": "IN",
        "CountryName": "India",
        "ContactNo": p['mobile'],
        "Email": p['email'],
        "IsLeadPax": true,
        "FFAirlineCode": null,
        "FFNumber": "",
        "Fare": {
          "BaseFare": baseFare,
          "Tax": tax,
          "TransactionFee": 0,
          "YQTax": 0,
          "AdditionalTxnFeePub": 0,
          "AdditionalTxnFeeOfrd": 0,
          "AirTransFee": 0,
        },
        "Nationality": "",
        "CellCountryCode": "",
        "MealDynamic": passengerMeals,
        // "MealDynamic": paxMeal == null
        //     ? []
        //     : [
        //         {
        //           "AirlineCode": paxMeal["AirlineCode"],
        //           "FlightNumber": paxMeal["FlightNumber"],
        //           "WayType": paxMeal["WayType"],
        //           "Code": paxMeal["Code"],
        //           "Description": paxMeal["Description"],
        //           "AirlineDescription": paxMeal["AirlineDescription"],
        //           "Quantity": paxMeal["Quantity"],
        //           "Currency": paxMeal["Currency"],
        //           "Price": paxMeal["Price"],
        //           "Origin": paxMeal["Origin"],
        //           "Destination": paxMeal["Destination"],
        //         }
        //       ],
      });
    }

    // MEALS + SEAT + CHILD(passengersDetailData)
    for (var i = 0; i < childpassenger.length; i++) {
      final cp = childpassenger[i];
      print("hellllllll$cp");

      String paxKey = "Child ${i + 1}";
      List<Map<String, dynamic>> passengerMeals = [];

      meal.forEach((routeKey, routeData) {
        if (routeData.containsKey(paxKey)) {
          passengerMeals.addAll(
            List<Map<String, dynamic>>.from(routeData[paxKey]),
          );
        }
      });
      print("CHILD MEAL");
      print(passengerMeals);

      final gender = cp['gender'] == 'Mstr' ? 1 : 2;

      final dob = cp['Date of Birth'];
      final parsedDate = DateFormat('dd-MM-yyyy').parse(dob);
      final formattedDOB = DateFormat('yyyy-MM-dd').format(parsedDate);

      // final expiry = cp['Expiry'];
      // final parsedexpiryDate = DateFormat('dd-MM-yyyy').parse(expiry);
      // final formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedexpiryDate);

      final expiry = cp['Expiry'];
      print("expiry$expiry");

      String formattedExpiry = "";
      if (expiry != null && expiry.toString().trim().isNotEmpty) {
        final parsedExpiry = DateFormat('dd-MM-yyyy').parse(expiry);
        formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedExpiry);
      } else {
        formattedExpiry = "";
      }

      passengersDetailData.add({
        "Title": cp['gender'],
        "FirstName": cp['Firstname'],
        "LastName": cp['lastname'],
        "PaxType": 2,
        "DateOfBirth":
            formattedDOB.isNotEmpty ? "${formattedDOB}T00:00:00" : null,
        "Gender": gender,
        "GSTCompanyAddress": "",
        "GSTCompanyContactNumber": "",
        "GSTCompanyName": "",
        "GSTNumber": "",
        "GSTCompanyEmail": "",
        "PassportNo": cp['Passport No'] ?? "",
        "PassportExpiry": formattedExpiry.trim().isNotEmpty
            ? "${formattedExpiry}T00:00:00"
            : "",
        "PassportIssueDate": "",
        "PassportIssueCountryCode": "",
        "AddressLine1": "NA",
        "AddressLine2": "",
        "City": "Gurgaon",
        "CountryCode": "IN",
        "CountryName": "India",
        "ContactNo": cp['mobile'],
        "Email": cp['email'],
        "IsLeadPax": true,
        "FFAirlineCode": null,
        "FFNumber": "",
        "Fare": {
          "BaseFare": baseFare,
          "Tax": tax,
          "TransactionFee": 0,
          "YQTax": 0,
          "AdditionalTxnFeePub": 0,
          "AdditionalTxnFeeOfrd": 0,
          "AirTransFee": 0,
        },
        "Nationality": "",
        "CellCountryCode": "",
        "MealDynamic": passengerMeals,
        // paxMeal == null
        //     // ? []
        //     // : [
        //     //     {
        //     //       "AirlineCode": paxMeal["AirlineCode"],
        //     //       "FlightNumber": paxMeal["FlightNumber"],
        //     //       "WayType": paxMeal["WayType"],
        //     //       "AirlineDescription": paxMeal["AirlineDescription"],
        //     //       "Quantity": paxMeal["Quantity"],
        //     //       "Currency": paxMeal["Currency"],
        //     //       "Code": paxMeal["Code"],
        //     //       "Price": paxMeal["Price"],
        //     //       "Description": paxMeal["Description"],
        //     //       "Destination": paxMeal["Destination"],
        //     //       "Origin": paxMeal["Origin"],
        //     //     }
        //     //   ],
      });
    }

    // MEALS + SEAT + INFANTS(passengersDetailData)
    for (var i = 0; i < infantpassenger.length; i++) {
      final ip = infantpassenger[i];
      print("hellllllll$ip");

      String paxKey = "Infants ${i + 1}";
      List<Map<String, dynamic>> passengerMeals = [];

      meal.forEach((routeKey, routeData) {
        if (routeData.containsKey(paxKey)) {
          passengerMeals.addAll(
            List<Map<String, dynamic>>.from(routeData[paxKey]),
          );
        }
      });
      print("Infants MEAL");
      print(passengerMeals);

      final gender = ip['gender'] == 'Mstr' ? 1 : 2;

      final dob = ip['Date of Birth'];
      final parsedDate = DateFormat('dd-MM-yyyy').parse(dob);
      final formattedDOB = DateFormat('yyyy-MM-dd').format(parsedDate);

      // final expiry = cp['Expiry'];
      // final parsedexpiryDate = DateFormat('dd-MM-yyyy').parse(expiry);
      // final formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedexpiryDate);

      final expiry = ip['Expiry'];
      print("expiry$expiry");

      String formattedExpiry = "";
      if (expiry != null && expiry.toString().trim().isNotEmpty) {
        final parsedExpiry = DateFormat('dd-MM-yyyy').parse(expiry);
        formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedExpiry);
      } else {
        formattedExpiry = "";
      }

      passengersDetailData.add({
        "Title": ip['gender'],
        "FirstName": ip['Firstname'],
        "LastName": ip['lastname'],
        "PaxType": 3,
        "DateOfBirth":
            formattedDOB.isNotEmpty ? "${formattedDOB}T00:00:00" : null,
        "Gender": gender,
        "GSTCompanyAddress": "",
        "GSTCompanyContactNumber": "",
        "GSTCompanyName": "",
        "GSTNumber": "",
        "GSTCompanyEmail": "",
        "PassportNo": ip['Passport No'] ?? "",
        "PassportExpiry": formattedExpiry.trim().isNotEmpty
            ? "${formattedExpiry}T00:00:00"
            : "",
        "PassportIssueDate": "",
        "PassportIssueCountryCode": "",
        "AddressLine1": "NA",
        "AddressLine2": "",
        "City": "Gurgaon",
        "CountryCode": "IN",
        "CountryName": "India",
        "ContactNo": ip['mobile'],
        "Email": ip['email'],
        "IsLeadPax": true,
        "FFAirlineCode": null,
        "FFNumber": "",
        "Fare": {
          "BaseFare": baseFare,
          "Tax": tax,
          "TransactionFee": 0,
          "YQTax": 0,
          "AdditionalTxnFeePub": 0,
          "AdditionalTxnFeeOfrd": 0,
          "AirTransFee": 0,
        },
        "Nationality": "",
        "CellCountryCode": "",
        "MealDynamic": passengerMeals,
        // paxMeal == null
        //     // ? []
        //     // : [
        //     //     {
        //     //       "AirlineCode": paxMeal["AirlineCode"],
        //     //       "FlightNumber": paxMeal["FlightNumber"],
        //     //       "WayType": paxMeal["WayType"],
        //     //       "AirlineDescription": paxMeal["AirlineDescription"],
        //     //       "Quantity": paxMeal["Quantity"],
        //     //       "Currency": paxMeal["Currency"],
        //     //       "Code": paxMeal["Code"],
        //     //       "Price": paxMeal["Price"],
        //     //       "Description": paxMeal["Description"],
        //     //       "Destination": paxMeal["Destination"],
        //     //       "Origin": paxMeal["Origin"],
        //     //     }
        //     //   ],
      });
    }

    // GENERATE APP REFRENCE NUMBER
    String generateReferenceNumber() {
      final random = Random();

      String firstCode = "CR${random.nextInt(100)}"; // 0–99
      String middleCode =
          random.nextInt(1000000).toString().padLeft(6, '0'); // 000000–999999
      String endCode =
          random.nextInt(1000000).toString().padLeft(6, '0'); // 000000–999999

      return "$firstCode-$middleCode-$endCode";
    }

    String appReferenceNumber = generateReferenceNumber();
    print("appReferenceNumber$appReferenceNumber");
    final holdparams = {
      "PreferredCurrency": null,
      "ResultIndex": resultIndex,
      "AgentReferenceNo": "CR9-985839-706449",
      "Passengers": passengersDetailData,
      "TokenId": tokenId,
      "TraceId": traceid,
      "app_reference": appReferenceNumber,
      "SequenceNumber": "0",
      "passenger_details": passengersDetailData,
      "wallet_retake_params": {
        "from_user_id": userID,
        "role_id": "3",
        "wallet": 0.0,
        "type": "booking",
      },
      "wallet_update_params": {"type": "booking", "booking_amount": 0.0},
      "user": userID,
      "role": "3",
      "document_type": "Passport",
      "commission_amt": 20,
      "service_tax": 0,
      "document_number": "",
      "journey_list": journeyListarray,
      "checkin_adult": "15 KG",
      "cabin_adult": "Included",
      "reissue_charge": "",
      "cancellation_charge": "",
      "totalpassengers": passengersDetailData.length,
      "base_price": baseFare,
      "tax": tax,
      "agentbalance": 0.0,
      "agent_commission": 0.0,
      "agent_tdsCommission": 0.0,
      "origin": cityName,
      "destination": descityName,
      "travel_date": depDate,
      "return_date": "",
      "commision_percentage_amount": 0.0,
      "excessAmount": 0,
    };

    /// 4️⃣ API call
    final response = await _helper.post("noLccBook", holdparams);
    print(jsonEncode(holdparams));
    // final decode = _helper.decodeBase64Response(response);
    final decode = response;

    debugPrint("holdticketResponseHold: $holdparams", wrapWidth: 2500);

    debugPrint("holdticketResponse: ${jsonEncode(decode)}", wrapWidth: 4000);

    return decode;
  }

  // DIRECTTICKET
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
    baseFare,
    tax,
    List<Map<String, dynamic>> passenger,
    List<Map<String, dynamic>> childpassenger,
    List<Map<String, dynamic>> infantpassenger,
    Map<String, dynamic> meal,
    stop,
    journeyList,
  ) async {
    print("APISERVICEEEEE$meal");

    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");
    final accessToken = prefs.getString("access_token");
    final savedResultIndex = prefs.getString("ResultIndex");
    final flightnumber = prefs.getString("FlightNumber");
    final fare = await SharedPreferences.getInstance();
    final fromorigin = fare.getString('Origin');
    final todestination = fare.getString('Destination');
    final userID = prefs.getString('user_id');
    print("APICALLING$passenger");
    print(meal);
    var passengersArrayData = [];
    var passengersDetailData = [];
    var journeyListarray = [];

    // ADDING ADULTS
    for (var passenger in passenger) {
      print("passengerTotal$passenger");

      // GENDER
      final gender = passenger['gender'] == 'Mr' ? 1 : 2;
      print("gender$gender");

      // DOB FORMAT (SAFE)
      final dob = passenger['Date of Birth'];
      print("dateofbirth$dob");

      String formattedDOB = "";
      if (dob != null && dob.toString().isNotEmpty) {
        final parsedDate = DateFormat('dd-MM-yyyy').parse(dob);
        formattedDOB = DateFormat('yyyy-MM-dd').format(parsedDate);
      } else {
        formattedDOB = ""; // or null if API accepts
      }
      print("formattedDOB$formattedDOB");

      final expiry = passenger['Expiry'];
      print("expiry$expiry");

      String formattedExpiry = "";
      if (expiry != null && expiry.toString().trim().isNotEmpty) {
        final parsedExpiry = DateFormat('dd-MM-yyyy').parse(expiry);
        formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedExpiry);
      } else {
        formattedExpiry = "";
      }
      print("formattedExpiry$formattedExpiry");

      print("formattedExpiry$formattedExpiry");

      if (tokenId == null) {
        throw Exception("TokenId not found in SharedPreferences");
      }
      print("PassportExpiry => [${passenger['PassportExpiry']}]");
      print("ExpiryExpiry$passenger['Expiry']");

      passengersArrayData.add({
        "Title": passenger['gender'],
        "FirstName": passenger['Firstname'],
        "LastName": passenger['lastname'],
        "PaxType": 1,
        "DateOfBirth":
            formattedDOB.isNotEmpty ? "${formattedDOB}T00:00:00" : null,
        "Gender": gender,

        // PASSPORT NO SAFE
        "PassportNo": passenger['Passport No'] ?? "",

        // PASSPORT EXPIRY SAFE
        "PassportExpiry": formattedExpiry.trim().isNotEmpty
            ? "${formattedExpiry}T00:00:00"
            : "",

        "AddressLine1": "NA",
        "AddressLine2": "",
        "Fare": {
          "BaseFare": baseFare,
          "Tax": tax,
          "YQTax": 0.0,
          "AdditionalTxnFeePub": 0.0,
          "AdditionalTxnFeeOfrd": 0.0,
          "OtherCharges": 0.0,
        },
        "City": "NA",
        "CountryCode": "NA",
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
        "GSTCompanyEmail": "",
      });
    }
    print("CHILDPASSSENGER$childpassenger");

    // ADDING CHILD
    for (var childpassenger in childpassenger) {
      // GENDER
      final gender = childpassenger['gender'] == 'Mstr' ? 1 : 2;
      print("childgender$gender");

      // // DATEOFBIRTH FORMAT
      final dob = childpassenger['Date of Birth'];
      print("dateofbirth$dob");
      final parsedDate = DateFormat('dd-MM-yyyy').parse(dob);
      final formattedDOB = DateFormat('yyyy-MM-dd').format(parsedDate);
      print("childformattedDOB$formattedDOB");

      //EXPIRYDATE FORMAT
      final expiry = childpassenger['Expiry'];
      print("expiry$expiry");

      String formattedExpiry = "";
      if (expiry != null && expiry.toString().trim().isNotEmpty) {
        final parsedExpiry = DateFormat('dd-MM-yyyy').parse(expiry);
        formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedExpiry);
      } else {
        formattedExpiry = "";
      }
      if (childpassenger != null && childpassenger.isNotEmpty) {
        passengersArrayData.add({
          "Title": childpassenger['gender'],
          "FirstName": childpassenger['Firstname'],
          "LastName": childpassenger['lastname'],
          "PaxType": 2, // child
          "DateOfBirth":
              formattedDOB.isNotEmpty ? "${formattedDOB}T00:00:00" : null,
          "Gender": '1',
          "PassportNo": childpassenger['Passport No'] ?? "",
          "PassportExpiry": formattedExpiry.trim().isNotEmpty
              ? "${formattedExpiry}T00:00:00"
              : "",
          "AddressLine1": "NA",
          "AddressLine2": "",
          "Fare": {
            "BaseFare": baseFare, // or child-specific fare
            "Tax": tax,
            "YQTax": 0.0,
            "AdditionalTxnFeePub": 0.0,
            "AdditionalTxnFeeOfrd": 0.0,
            "OtherCharges": 0.0,
          },
          "City": "Gurgaon",
          "CountryCode": "IN",
          "CountryName": "India",
          "Nationality": "IN",
          "ContactNo": childpassenger['mobile'],
          "Email": childpassenger['email'],
          "IsLeadPax": false,
        });
      }
      print("CHILD API SENDING");
    }

    // ADDING INFANT
    for (var infantpassenger in infantpassenger) {
      // GENDER
      final gender = infantpassenger['gender'] == 'Mstr' ? 1 : 2;
      print("childgender$gender");

      // // DATEOFBIRTH FORMAT
      final dob = infantpassenger['Date of Birth'];
      print("dateofbirth$dob");
      final parsedDate = DateFormat('dd-MM-yyyy').parse(dob);
      final formattedDOB = DateFormat('yyyy-MM-dd').format(parsedDate);
      print("childformattedDOB$formattedDOB");

      //EXPIRYDATE FORMAT
      final expiry = infantpassenger['Expiry'];
      print("expiry$expiry");

      String formattedExpiry = "";
      if (expiry != null && expiry.toString().trim().isNotEmpty) {
        final parsedExpiry = DateFormat('dd-MM-yyyy').parse(expiry);
        formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedExpiry);
      } else {
        formattedExpiry = "";
      }

      if (infantpassenger != null && infantpassenger.isNotEmpty) {
        passengersArrayData.add({
          "Title": "Master",
          "FirstName": infantpassenger['Firstname'],
          "LastName": infantpassenger['lastname'],
          "PaxType": 3,
          "DateOfBirth":
              formattedDOB.isNotEmpty ? "${formattedDOB}T00:00:00" : null,
          "Gender": '1',
          "PassportNo": infantpassenger['Passport No'] ?? "",
          "PassportExpiry": formattedExpiry.trim().isNotEmpty
              ? "${formattedExpiry}T00:00:00"
              : "",
          "AddressLine1": "NA",
          "AddressLine2": "",
          "Fare": {
            "BaseFare": baseFare, // or child-specific fare
            "Tax": tax,
            "YQTax": 0.0,
            "AdditionalTxnFeePub": 0.0,
            "AdditionalTxnFeeOfrd": 0.0,
            "OtherCharges": 0.0,
          },
          "City": "Gurgaon",
          "CountryCode": "IN",
          "CountryName": "India",
          "Nationality": "IN",
          "ContactNo": infantpassenger['mobile'],
          "Email": infantpassenger['email'],
          "IsLeadPax": false,
        });
      }
      print("INFANT API SENDING");
    }
    debugPrint(
      "passengersArray(ADULT,CHILD,INFANT)$passengersArrayData",
      wrapWidth: 5000,
    );
// -------------------------------------------------------------------------------------
    // GENERATE APP REFRENCE NUMBER
    String generateReferenceNumber() {
      final random = Random();

      String firstCode = "CR${random.nextInt(100)}"; // 0–99
      String middleCode =
          random.nextInt(1000000).toString().padLeft(6, '0'); // 000000–999999
      String endCode =
          random.nextInt(1000000).toString().padLeft(6, '0'); // 000000–999999

      return "$firstCode-$middleCode-$endCode";
    }

    // JOURNEYLIST
    print("journeyListarray$journeyListarray");
    for (var item in journeyList) {
      print("journeyList$item");
      print("journeyListarray$journeyListarray");

      journeyListarray.add({
        "Baggage": "15 Kilograms",
        "duration": item['duration'] != "" && item['duration'] != null
            ? int.parse(item['duration'].toString())
            : 0,
        "ToCityName": item['toCity'],
        "Arrival": item['arrival'],
        "ArrivalTime": item['arrTime'],
        "LayOverTime": item['layover'],
        "CabinBaggage": "7 KG",
        "Depature": item['departure'],
        "DepatureTime": item['depTime'],
        "FlightNumber": item['flightNumber'],
        "FromCityName": item['fromCity'],
        "OperatorCode": item['airlineCode'],
        "OperatorName": item['airlineName'],
        "noofstop": item['noofstop'],
        "durationTime": "0 Mins",
        "ToAirportCode": item['toAirportCode'],
        "ToAirportName": item['toAirport'],
        "FromAirportCode": item['fromAirportCode'],
        "FromAirportName": item['fromAirport'],
      });
    }

    // MEALS + SEAT + ADULT(passengersDetailData)
    for (var i = 0; i < passenger.length; i++) {
      final p = passenger[i];
      final gender = p['gender'] == 'Mr' ? 1 : 2;

      final dob = DateFormat('dd-MM-yyyy').parse(p['Date of Birth']);
      final formattedDOB = DateFormat('yyyy-MM-dd').format(dob);
      // final expiry = DateFormat('dd-MM-yyyy').parse(p['Expiry']);
      // final formattedExpiry = DateFormat('yyyy-MM-dd').format(expiry);

      final expiry = p['Expiry'];
      print("expiry$expiry");

      String formattedExpiry = "";
      if (expiry != null && expiry.toString().trim().isNotEmpty) {
        final parsedExpiry = DateFormat('dd-MM-yyyy').parse(expiry);
        formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedExpiry);
      } else {
        formattedExpiry = "";
      }
      String paxKey = "Adult ${i + 1}";
      Map<String, dynamic>? paxMeal;

      List<Map<String, dynamic>> passengerMeals = [];
      meal.forEach((routeKey, routeData) {
        if (routeData.containsKey(paxKey)) {
          passengerMeals.addAll(
            List<Map<String, dynamic>>.from(routeData[paxKey]),
          );
        }
      });
      print("passengerMeals$passengerMeals");

      passengersDetailData.add({
        "Title": p['gender'],
        "FirstName": p['Firstname'],
        "LastName": p['lastname'],
        "PaxType": 1,
        "DateOfBirth":
            formattedDOB.isNotEmpty ? "${formattedDOB}T00:00:00" : null,
        "Gender": 1,
        "GSTCompanyAddress": "",
        "GSTCompanyContactNumber": "",
        "GSTCompanyName": "",
        "GSTNumber": "",
        "GSTCompanyEmail": "",
        "PassportNo": p['Passport No'] ?? "",
        "PassportExpiry": formattedExpiry.trim().isNotEmpty
            ? "${formattedExpiry}T00:00:00"
            : "",
        "PassportIssueDate": "",
        "PassportIssueCountryCode": "",
        "AddressLine1": "NA",
        "AddressLine2": "",
        "City": "Gurgaon",
        "CountryCode": "IN",
        "CountryName": "India",
        "ContactNo": p['mobile'],
        "Email": p['email'],
        "IsLeadPax": true,
        "FFAirlineCode": null,
        "FFNumber": "",
        "Fare": {
          "BaseFare": baseFare,
          "Tax": tax,
          "TransactionFee": 0,
          "YQTax": 0,
          "AdditionalTxnFeePub": 0,
          "AdditionalTxnFeeOfrd": 0,
          "AirTransFee": 0,
        },
        "Nationality": "",
        "CellCountryCode": "",
        "MealDynamic": passengerMeals,
        // "MealDynamic": paxMeal == null
        //     ? []
        //     : [
        //         {
        //           "AirlineCode": paxMeal["AirlineCode"],
        //           "FlightNumber": paxMeal["FlightNumber"],
        //           "WayType": paxMeal["WayType"],
        //           "Code": paxMeal["Code"],
        //           "Description": paxMeal["Description"],
        //           "AirlineDescription": paxMeal["AirlineDescription"],
        //           "Quantity": paxMeal["Quantity"],
        //           "Currency": paxMeal["Currency"],
        //           "Price": paxMeal["Price"],
        //           "Origin": paxMeal["Origin"],
        //           "Destination": paxMeal["Destination"],
        //         }
        //       ],
      });
    }

    // MEALS + SEAT + CHILD(passengersDetailData)
    for (var i = 0; i < childpassenger.length; i++) {
      final cp = childpassenger[i];
      print("hellllllll$cp");

      String paxKey = "Child ${i + 1}";
      List<Map<String, dynamic>> passengerMeals = [];

      meal.forEach((routeKey, routeData) {
        if (routeData.containsKey(paxKey)) {
          passengerMeals.addAll(
            List<Map<String, dynamic>>.from(routeData[paxKey]),
          );
        }
      });
      print("CHILD MEAL");
      print(passengerMeals);

      final gender = cp['gender'] == 'Mstr' ? 1 : 2;

      final dob = cp['Date of Birth'];
      final parsedDate = DateFormat('dd-MM-yyyy').parse(dob);
      final formattedDOB = DateFormat('yyyy-MM-dd').format(parsedDate);

      // final expiry = cp['Expiry'];
      // final parsedexpiryDate = DateFormat('dd-MM-yyyy').parse(expiry);
      // final formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedexpiryDate);

      final expiry = cp['Expiry'];
      print("expiry$expiry");

      String formattedExpiry = "";
      if (expiry != null && expiry.toString().trim().isNotEmpty) {
        final parsedExpiry = DateFormat('dd-MM-yyyy').parse(expiry);
        formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedExpiry);
      } else {
        formattedExpiry = "";
      }

      passengersDetailData.add({
        "Title": cp['gender'],
        "FirstName": cp['Firstname'],
        "LastName": cp['lastname'],
        "PaxType": 2,
        "DateOfBirth":
            formattedDOB.isNotEmpty ? "${formattedDOB}T00:00:00" : null,
        "Gender": gender,
        "GSTCompanyAddress": "",
        "GSTCompanyContactNumber": "",
        "GSTCompanyName": "",
        "GSTNumber": "",
        "GSTCompanyEmail": "",
        "PassportNo": cp['Passport No'] ?? "",
        "PassportExpiry": formattedExpiry.trim().isNotEmpty
            ? "${formattedExpiry}T00:00:00"
            : "",
        "PassportIssueDate": "",
        "PassportIssueCountryCode": "",
        "AddressLine1": "NA",
        "AddressLine2": "",
        "City": "Gurgaon",
        "CountryCode": "IN",
        "CountryName": "India",
        "ContactNo": cp['mobile'],
        "Email": cp['email'],
        "IsLeadPax": true,
        "FFAirlineCode": null,
        "FFNumber": "",
        "Fare": {
          "BaseFare": baseFare,
          "Tax": tax,
          "TransactionFee": 0,
          "YQTax": 0,
          "AdditionalTxnFeePub": 0,
          "AdditionalTxnFeeOfrd": 0,
          "AirTransFee": 0,
        },
        "Nationality": "",
        "CellCountryCode": "",
        "MealDynamic": passengerMeals,
        // paxMeal == null
        //     // ? []
        //     // : [
        //     //     {
        //     //       "AirlineCode": paxMeal["AirlineCode"],
        //     //       "FlightNumber": paxMeal["FlightNumber"],
        //     //       "WayType": paxMeal["WayType"],
        //     //       "AirlineDescription": paxMeal["AirlineDescription"],
        //     //       "Quantity": paxMeal["Quantity"],
        //     //       "Currency": paxMeal["Currency"],
        //     //       "Code": paxMeal["Code"],
        //     //       "Price": paxMeal["Price"],
        //     //       "Description": paxMeal["Description"],
        //     //       "Destination": paxMeal["Destination"],
        //     //       "Origin": paxMeal["Origin"],
        //     //     }
        //     //   ],
      });
    }

    // MEALS + SEAT + INFANTS(passengersDetailData)
    for (var i = 0; i < infantpassenger.length; i++) {
      final ip = infantpassenger[i];
      print("hellllllll$ip");

      String paxKey = "Infants ${i + 1}";
      List<Map<String, dynamic>> passengerMeals = [];

      meal.forEach((routeKey, routeData) {
        if (routeData.containsKey(paxKey)) {
          passengerMeals.addAll(
            List<Map<String, dynamic>>.from(routeData[paxKey]),
          );
        }
      });
      print("Infants MEAL");
      print(passengerMeals);

      final gender = ip['gender'] == 'Mstr' ? 1 : 2;

      final dob = ip['Date of Birth'];
      final parsedDate = DateFormat('dd-MM-yyyy').parse(dob);
      final formattedDOB = DateFormat('yyyy-MM-dd').format(parsedDate);

      // final expiry = cp['Expiry'];
      // final parsedexpiryDate = DateFormat('dd-MM-yyyy').parse(expiry);
      // final formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedexpiryDate);

      final expiry = ip['Expiry'];
      print("expiry$expiry");

      String formattedExpiry = "";
      if (expiry != null && expiry.toString().trim().isNotEmpty) {
        final parsedExpiry = DateFormat('dd-MM-yyyy').parse(expiry);
        formattedExpiry = DateFormat('yyyy-MM-dd').format(parsedExpiry);
      } else {
        formattedExpiry = "";
      }

      passengersDetailData.add({
        "Title": ip['gender'],
        "FirstName": ip['Firstname'],
        "LastName": ip['lastname'],
        "PaxType": 3,
        "DateOfBirth":
            formattedDOB.isNotEmpty ? "${formattedDOB}T00:00:00" : null,
        "Gender": gender,
        "GSTCompanyAddress": "",
        "GSTCompanyContactNumber": "",
        "GSTCompanyName": "",
        "GSTNumber": "",
        "GSTCompanyEmail": "",
        "PassportNo": ip['Passport No'] ?? "",
        "PassportExpiry": formattedExpiry.trim().isNotEmpty
            ? "${formattedExpiry}T00:00:00"
            : "",
        "PassportIssueDate": "",
        "PassportIssueCountryCode": "",
        "AddressLine1": "NA",
        "AddressLine2": "",
        "City": "Gurgaon",
        "CountryCode": "IN",
        "CountryName": "India",
        "ContactNo": ip['mobile'],
        "Email": ip['email'],
        "IsLeadPax": true,
        "FFAirlineCode": null,
        "FFNumber": "",
        "Fare": {
          "BaseFare": baseFare,
          "Tax": tax,
          "TransactionFee": 0,
          "YQTax": 0,
          "AdditionalTxnFeePub": 0,
          "AdditionalTxnFeeOfrd": 0,
          "AirTransFee": 0,
        },
        "Nationality": "",
        "CellCountryCode": "",
        "MealDynamic": passengerMeals,
        // paxMeal == null
        //     // ? []
        //     // : [
        //     //     {
        //     //       "AirlineCode": paxMeal["AirlineCode"],
        //     //       "FlightNumber": paxMeal["FlightNumber"],
        //     //       "WayType": paxMeal["WayType"],
        //     //       "AirlineDescription": paxMeal["AirlineDescription"],
        //     //       "Quantity": paxMeal["Quantity"],
        //     //       "Currency": paxMeal["Currency"],
        //     //       "Code": paxMeal["Code"],
        //     //       "Price": paxMeal["Price"],
        //     //       "Description": paxMeal["Description"],
        //     //       "Destination": paxMeal["Destination"],
        //     //       "Origin": paxMeal["Origin"],
        //     //     }
        //     //   ],
      });
    }

    String appReferenceNumber = generateReferenceNumber();
    print("appReferenceNumber$appReferenceNumber");

    /// 3️⃣ Confirm Booking Params (converted from Angular version)
    final confirmBookingParams = {
      "PreferredCurrency": null,
      "ResultIndex": resultIndex,
      "AgentReferenceNo": "sonam1234567890",
      "Passengers": passengersDetailData,
      "TokenId": tokenId,
      "TraceId": traceid,
      "app_reference": appReferenceNumber, // replace with your actual value
      "SequenceNumber": "0",
      "result_token": "resultToken123", // replace with actual value
      "passenger_details": passengersDetailData,
      "wallet_retake_params": {}, // fill as per your app
      "wallet_update_params": {}, // fill as per your app
      "user": userID, // replace with actual value
      "role": 3, // replace with actual value
      "document_type": "Passport",
      "commission_amt": 100, // double.parse if numeric
      "service_tax": 50,
      "document_number": "A1234567",
      "journey_list": journeyListarray,
      "checkin_adult": "1",
      "cabin_adult": "Economy",
      "reissue_charge": 0,
      "cancellation_charge": 0,
      "totalpassengers": passengersDetailData.length,
      "base_price": baseFare,
      "tax": tax,
      "agentbalance": 0.0,
      "agent_commission": 0.0,
      "agent_tdsCommission": 0.0,
      "origin": cityName,
      "destination": descityName,
      "travel_date": depDate,
      "return_date": "",
      "commision_percentage_amount": 10.0,
      "excessAmount": 0.0,
    };

    // debugPrint("ticketBody: $ticketBody");
    debugPrint(
      "confirmBookingParams: ${jsonEncode(confirmBookingParams)}",
      wrapWidth: 4000,
    );
    print("confirmBookingParams:${jsonEncode(confirmBookingParams)}");
    final formattedJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(confirmBookingParams);
    log(formattedJson);

    /// 4️⃣ API call
    final response = await _helper.post("ticketInvoice", confirmBookingParams);
    // final decode = _helper.decodeBase64Response(response);
    final decode = response;

    debugPrint("ticketResponse: ${jsonEncode(response)}", wrapWidth: 3000);

    return decode;
  }

  // HOLD-->TICKET BOOKING
  Future<Map<String, dynamic>> ticketInvoice(
    String pnr,
    String bookingId,
    traceid,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");
    final userID = prefs.getString('user_id');

    if (tokenId == null) {
      throw Exception("TokenId not found in SharedPreferences");
    }

    final body = {
      "TokenId": tokenId,
      "TraceId": traceid,
      "PNR": pnr,
      "BookingId": bookingId,
      "wallet_retake_params": {
        "type": "booking",
        "wallet": 7245.0336,
        "role_id": "3",
        "from_user_id": userID,
      },
      "wallet_update_params": {"type": "booking", "booking_amount": 7245.0336},
      "user": userID,
    };

    print("ticketInvoice body: $body");

    final response = await _helper.post("ticketInvoice", body);

    // 🔥 Fix here
    final decode =
        response is Map<String, dynamic> ? response : {"success": response};

    debugPrint(
      "ticketInvoice response: ${jsonEncode(decode)}",
      wrapWidth: 3000,
    );

    return decode;
  }

  // BOOKING HISTORY
  // Future<booking_history.BookingHistory> bookingHistory() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final tokenId = prefs.getString("tokenId");
  //   final accessToken = prefs.getString("access_token");
  //   print("accessToken$accessToken");
  //   final userID = prefs.getString('user_id');
  //   print("userID$userID");
  //
  //   if (tokenId == null) {
  //     throw Exception("TokenId not found in SharedPreferences");
  //   }
  //
  //   final bookingHistoryBody = {};
  //   print("bookingHistoryBody request: $bookingHistoryBody");
  //
  //   final response = await _helper.get(
  //     "ticketsearch?userid=$userID&mobile=1",
  //   );
  //   // final decode = _helper.decodeBase64Response(response);
  //   final decode = response;
  //   print("accesstokenresponse$response");
  //   final bookings = decode['data'];
  //   print("bookingHistoryBody response${jsonEncode(decode)}");
  //   return booking_history.bookingHistoryFromJson(decode);
  // }
  Future<booking_history.BookingHistory> bookingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString('user_id') ?? "";

    print("📌 bookingHistory() userID = $userID");
    final response = await _helper.get("mobileTicket?userid=$userID&mobile=1");
    // final decode = _helper.decodeBase64Response(response);
    final decode = response;
    print("📩 API Response: $response");
    // Normalize backend response
    if (decode == null || decode["data"] == null || decode["data"] is! List) {
      print("⚠ No data returned. Sending empty list.");
      return booking_history.BookingHistory(data: [], statusCode: "");
    }

    return booking_history.bookingHistoryFromJson(decode);
  }

  void printFullResponse(String text) {
    final pattern = RegExp('.{1,1000}'); // split into 1000-character chunks
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  //   CountryCode
  Future<country_code.Countrycode> countryCode() async {
    final response = await _helper.get("mobilecountryCode");
    // final decode = _helper.decodeBase64Response(response);
    final decode = response;

    print("COUNTRYCODE response${jsonEncode(decode)}");
    if (decode["data"] == null) {
      return country_code.Countrycode(data: [], statusCode: "200");
    }

    return country_code.countrycodeFromJson(decode);
  }

  // SEARCHFLIGHT
  String? formattedReturnDate;

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
    if (selectedReturnDate != "") {
      formattedReturnDate = selectedReturnDate.toString().substring(0, 10);
      print("formattedReturnformattedReturn$formattedReturnDate");
    }
    final prefToken = await SharedPreferences.getInstance();
    final tokenId = prefToken.getString("tokenId");
    final userID = prefs.getString('user_id');

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
                "PreferredDepartureTime": "${formattedReturnDate}T00:00:00",
                "PreferredArrivalTime": "${formattedReturnDate}T00:00:00",
              },
            ],
      "Sources": null,
    };
    print("params$params");
    final response = await _helper.post("mobileFlightSearch", params);
    // final decode = _helper.decodeBase64Response(response);
    final decode = response;
    print("hello${jsonEncode(decode)}");
    return search.searchDataFromJson(decode);
  }

  // COMMISSION PERCENTAGE
  Future<commissionpercentage.ComissionPercentage>
      commissionPercentage() async {
    try {
      print("mobileCommission");
      // 🔹 Call API (no token check required)
      final response = await _helper.get("mobileCommission");

      print("📩 API Raw Response: $response");

      // 🔹 Decrypt response (if required)
      // final decode = _helper.decodeBase64Response(response);
      final decode = response;
      print("🔓 Decrypted Response: $decode");

      // 🔹 Normalize backend response EXACTLY like bookingHistory()
      if (decode == null || decode["data"] == null || decode["data"] is! List) {
        print("⚠ No commission data → returning empty model");

        return commissionpercentage.ComissionPercentage(
          data: [],
          statusCode: "",
          statusMessage: "",
        );
      }

      // 🔹 Parse valid response
      return commissionpercentage.comissionPercentageFromJson(decode);
    } catch (e) {
      print("🚨 commissionPercentage() error: $e");

      // 🔹 Fail-safe (same as bookingHistory)
      return commissionpercentage.ComissionPercentage(
        data: [],
        statusCode: "",
        statusMessage: "",
      );
    }
  }

  // GET BookingHistory BY ID
  Future<bookinghistoryID.Getbookingdetailsid> getbookingdetailHistory(
    id,
  ) async {
    final response = await _helper.get("ticketbooking?id=$id");
    // final decode = _helper.decodeBase64Response(response);
    final decode = response;

    return bookinghistoryID.getbookingdetailsidFromJson(decode);
  }

  // PROFILEUPDATE
  Future<profileupdatation.Getprofile> getprofileupdate(id) async {
    final response = await _helper.dio.get("updatemobileUser?id=$id");
    print("decodedecode$response");
    // final decode = _helper.decodeBase64Response(response);
    final decode = response.data;
    print("decodedecode$decode");
    return profileupdatation.getprofileFromJson(decode);
  }

  Future<profileupdatation.Getprofile> profileupdate(
    firstname,
    lastname,
    email,
    mobile,
    date,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final body = {
      "first_name": firstname,
      "last_name": lastname,
      "email": email,
      "gst_number": "",
      "mobile": mobile,
      "user_image": "",
      "dateofbirth": date,
      "wallet": 0.0,
      "wallet_ticket_booking": 0.0,
      "balance_verified": "1",
      "server_wallet": 0.0,
    };

    final response = await _helper.dio.patch(
      "updatemobileUser?id=$userId",
      data: body,
    );

    print("decodedecode$response");
    // final decode = _helper.decodeBase64Response(response);
    final decode = response.data;
    print("decodedecode$decode");
    return profileupdatation.getprofileFromJson(decode);
  }

  // PROFILE UPDATION
  Future<profileupdatation.Getprofile> userprofileupdate(
    id,
    String imagePath,
  ) async {
    final fileName = imagePath.split('/').last;

    final formData = FormData.fromMap({
      "user_image": await MultipartFile.fromFile(
        imagePath,
        filename: fileName,
        contentType: MediaType("image", "jpeg"), // important
      ),
    });

    final response = await _helper.dio.patch(
      "updateprofileUser?id=$id",
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    );

    print("decodedecode$response");
    final decode = response.data;
    print("decodedecode$decode");

    return profileupdatation.getprofileFromJson(decode);
  }

  //  ADDSTATUS
  Future<addstatus.CancelReasonData> addStatus() async {
    final response = await _helper.get("addstatus");
    final decode = _helper.decodeBase64Response(response);
    // final decode = response;

    print("addstatus response${jsonEncode(decode)}");
    return addstatus.addstatusFromJson(decode);
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
      "app_ref": appref,
    };
    print("cancelRequest$cancelRequest");

    final response = await _helper.post("cancel-req", cancelRequest);
    print("cancel response${jsonEncode(response)}");
    return (response);
  }

  //   DOWNLOAD TICKET

  Future<void> downloadTicket(String bookingId, String pnr) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");
    try {
      final url =
          "http://192.168.0.6:8000/api/ticket-download/$bookingId/$pnr/$tokenId";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Get downloads folder path
        Directory downloadsDir;
        if (Platform.isAndroid) {
          downloadsDir = Directory(
            '/storage/emulated/0/Download',
          ); // Standard Downloads folder
          if (!await downloadsDir.exists()) {
            await downloadsDir.create(recursive: true);
          }
        } else {
          downloadsDir =
              await getApplicationDocumentsDirectory(); // iOS fallback
        }

        String filePath = "${downloadsDir.path}/ticket_$bookingId.pdf";

        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print("Ticket saved at $filePath");
      } else {
        print("Failed to download ticket: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading ticket: $e");
    }
  }

  // DOWNLOAD INVOICE

  Future<void> downloadInvoice(String bookingId, String pnr) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");
    try {
      final url =
          "http://192.168.0.9:8000/api/invoice-download/$bookingId/$pnr/$tokenId";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Get downloads folder path
        Directory downloadsDir;
        if (Platform.isAndroid) {
          downloadsDir = Directory(
            '/storage/emulated/0/Download',
          ); // Standard Downloads folder
          if (!await downloadsDir.exists()) {
            await downloadsDir.create(recursive: true);
          }
        } else {
          downloadsDir =
              await getApplicationDocumentsDirectory(); // iOS fallback
        }

        String filePath = "${downloadsDir.path}/invoice_$bookingId.pdf";

        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print("Ticket saved at $filePath");
      } else {
        print("Failed to download ticket: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading ticket: $e");
    }
  }

  Future<bool> requestStoragePermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    } else {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  // PRIVACYPOLICYURL
  Future<void> privacyPolicy() async {
    final url = Uri.parse("https://dev.trvlus.com/privacy-policy");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("Privacy Policy content:\n${response.body}");
      } else {
        print("Failed to load privacy policy. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching privacy policy: $e");
    }
  }
}

Map<String, dynamic> decodeBase64Response(
  Map<String, dynamic> res,
  String secretKey,
) {
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
