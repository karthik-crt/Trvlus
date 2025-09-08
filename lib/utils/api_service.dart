import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

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

  Future<search.SearchData> getSearchResult(
    String airportCode,
    String fromAirport,
    String toairportCode,
    String toAirport,
    String selectedDepDate,
  ) async {
    print("Origin$airportCode");
    print("Destination$toairportCode");
    String formatted = selectedDepDate.toString().contains("PickerDateRange")
        ? selectedDepDate.toString().substring(33, 43)
        : selectedDepDate.toString();

    print(formatted);

    final params = {
      "EndUserIp": "192.168.0.2",
      "TokenId": "7ebfe1ec-337f-46c8-b042-99ec84319719",
      "AdultCount": "1",
      "ChildCount": "0",
      "InfantCount": "0",
      "DirectFlight": "false",
      "OneStopFlight": "false",
      "JourneyType": "1",
      "PreferredAirlines": null,
      "Segments": [
        {
          "Origin": airportCode,
          "Destination": toairportCode,
          "FlightCabinClass": "1",
          "PreferredDepartureTime": formatted + "T00: 00: 00",
          "PreferredArrivalTime": "2025-09-27T00:00:00"
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
