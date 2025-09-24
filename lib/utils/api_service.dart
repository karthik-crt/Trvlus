import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/search_data.dart' as search;

late GlobalKey<NavigatorState> _navigatorKey;

clearUserData() async {}

class ApiBaseHelper {
  initApiService(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  static const _baseUrl =
      "http://api.tektravels.com/BookingEngineService_Air/AirService.svc/rest/";
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

  Map<String, String> getMainHeaders() {
    String? token = "";
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (token != null) {
      headers['Authorization'] =
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU2NzMyNzM4LCJpYXQiOjE3NTY3MDM5MzgsImp0aSI6ImYzOTM4ZWY5N2YyMDRkMTE5ZmQzNDcxM2JkYjRlNmZiIiwidXNlcl9pZCI6NX0.aAdPPw2iReD544KvIMJckPjly631ZNDiszZVnxoW5Ks';
    }
    return headers;
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
        options: Options(headers: headers),
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

  Future<dynamic> post(String url, [dynamic body]) async {
    String params = "";

    var apiUrl = _baseUrl + url + params;
    print("apiUrl$apiUrl");
    var headers = getMainHeaders();
    dynamic responseJson;
    try {
      final response = await dio.post(
        apiUrl,
        data: body,
        options: Options(headers: headers),
      );
      responseJson = _returnResponse(response);
    } catch (e) {
      print("sfsdsdsd");
      print(e.toString());
      if (e.toString().contains("401")) {
        clearUserData();
        throw Exception('token_expired');
      } else if (e.toString().contains("403")) {
        /* _showToast(
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

  Future<dynamic> put(String url, [dynamic body]) async {
    var headers = getMainHeaders();
    dynamic responseJson;
    try {
      final response = await dio.put(
        url,
        data: jsonEncode(body),
        options: Options(headers: headers),
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
        options: Options(headers: headers),
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

  Future<String?> authenticate() async {
    const authUrl =
        "http://Sharedapi.tektravels.com/SharedData.svc/rest/Authenticate";

    final authenticate = {
      "ClientId": "ApiIntegrationNew",
      "UserName": "trvlus",
      "Password": "Trvlus@1234",
      "EndUserIp": "192.168.11.120"
    };
    print("authenticate_api$authenticate");
    print("authUrl$authUrl");

    try {
      final response = await Dio().post(authUrl, data: authenticate);
      print("Authenticate response: ${response.data}");
      _tokenId = response.data["TokenId"];
      final pref_token = await SharedPreferences.getInstance();
      print("prefs$pref_token");
      await pref_token.setString('tokenId', _tokenId!);
      return _tokenId;
    } catch (e) {
      print("❌ Authentication failed: $e");
      rethrow;
    }
  }

  // FARERULE

  Future<Map<String, dynamic>> farerule(
      String resultIndex, String traceid) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");

    if (tokenId == null) {
      throw Exception("TokenId not found in SharedPreferences");
    }

    final fareruleBody = {
      "EndUserIp": "192.168.11.58",
      "TokenId": tokenId,
      "TraceId": traceid,
      "ResultIndex": resultIndex,
    };
    // print("farerule request: $fareruleBody");

    final response = await _helper.post("FareRule", fareruleBody);
    // print("farerule response${jsonEncode(response)}");
    return response;
  }

  // FAREQUOTE
  Future<Map<String, dynamic>> farequote(
      String resultIndex, String traceid) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");

    if (tokenId == null) {
      throw Exception("TokenId not found in SharedPreferences");
    }

    final farequoteBody = {
      "EndUserIp": "192.168.11.58",
      "TokenId": tokenId,
      "TraceId": traceid,
      "ResultIndex": resultIndex,
    };
    // print("FareQuote request: $farequoteBody");

    final response = await _helper.post("FareQuote", farequoteBody);
    // print("FareQuote response${jsonEncode(response)}");
    return response;
  }

  // SSR
  Future<Map<String, dynamic>> ssr(String resultIndex, String traceid) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");

    if (tokenId == null) {
      throw Exception("TokenId not found in SharedPreferences");
    }

    final ssrBody = {
      "EndUserIp": "192.168.11.58",
      "TokenId": tokenId,
      "TraceId": traceid,
      "ResultIndex": resultIndex,
    };
    // print("SSR request: $ssrBody");

    final response = await _helper.post("SSR", ssrBody);
    print("SSR response${jsonEncode(response)}");
    return response;
  }

  //HOMEPAGE DATE PICKER
  Future<Map<String, dynamic>> getCalendarFare(
      String origin, String destination) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("tokenId");

    if (token == null) {
      throw Exception("TokenId not found in SharedPreferences");
    }

    final body = {
      'Origin': origin,
      'Destination': destination,
      // Add other required parameters here if needed
    };

    try {
      final response = await _helper.post(
        "GetCalendarFare",
        body,
      );

      return response; // assuming Dio already decodes JSON
    } catch (e) {
      print("Error fetching calendar fare: $e");
      throw Exception("Failed to fetch calendar fare");
    }
  }

  Future<Map<String, dynamic>> ticket(
      String resultIndex, String traceid) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString("tokenId");

    if (tokenId == null) {
      throw Exception("TokenId not found in SharedPreferences");
    }

    final ticketBody = {
      {
        "PreferredCurrency": null,
        "EndUserIp": "192.168.11.58",
        "TokenId": tokenId,
        "TraceId": traceid,
        "ResultIndex": resultIndex,
        "AgentReferenceNo": "sonam1234567890",
        "Passengers": [
          {
            "Title": "Mr",
            "FirstName": "OIRNEGRPN",
            "LastName": "tbo",
            "PaxType": 1,
            "DateOfBirth": "1987-12-06T00:00:00",
            "Gender": 1,
            "PassportNo": "KJHHJKHKJH",
            "PassportExpiry": "2025-12-06T00:00:00",
            "AddressLine1": "123, Test",
            "AddressLine2": "",
            "Fare": {
              "BaseFare": 550,
              "Tax": 863,
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
            "Email": "harsh@tbtq.in",
            "IsLeadPax": true,
            "FFAirlineCode": "SG",
            "FFNumber": "123",
            "GSTCompanyAddress": "",
            "GSTCompanyContactNumber": "",
            "GSTCompanyName": "",
            "GSTNumber": "",
            "GSTCompanyEmail": ""
          }
        ]
      }
    };
    print("ticketBody$ticketBody");
    final response = await _helper.post("Ticket", ticketBody);
    print("TICKET response${jsonEncode(response)}");
    return response;
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
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final adult = prefs.getInt("adults") ?? 0;
    final child = prefs.getInt("children") ?? 0;
    final infant = prefs.getInt("infants") ?? 0;

    String formatted = selectedDepDate.toString().substring(0, 10);
    int triptype = selectedTripType == "One way" ? 1 : 2;
    String formattedReturn = selectedReturnDate.toString().substring(0, 10);
    final prefToken = await SharedPreferences.getInstance();

    final params = {
      "EndUserIp": "192.168.0.2",
      "TokenId": prefToken.getString("tokenId"),
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
    final response = await _helper.post("Search", params);
    print(jsonEncode(response));
    return search.searchDataFromJson(response);
  }
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
