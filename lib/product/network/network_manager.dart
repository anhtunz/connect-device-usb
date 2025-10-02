import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../cache/locale_manager.dart';
import '../constants/app/app_constants.dart';
import '../constants/status_code/status_code_constants.dart';
import '../constants/enums/locale_keys_enum.dart';

class NetworkManager {
  NetworkManager._init();
  static NetworkManager? _instance;
  static NetworkManager? get instance => _instance ??= NetworkManager._init();

  Future<Map<String, String>> getHeaders() async {
    String? token =
    LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Access-Control-Allow-Credentials": "false",
      "Access-Control-Allow-Headers":
      "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      'Access-Control-Allow-Origin': "*",
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS, PUT, PATCH, DELETE',
      'Authorization': token,
    };
    return headers;
  }

  /// Retrieves data from the server using a GET request.
  ///
  /// [path] is the endpoint for the request. Returns the response body as a
  /// [String] if the request is successful (status code 200), or an empty
  /// string if the request fails
  Future<String> getDataFromServer(String path) async {
    final url = Uri.https(ApplicationConstants.DOMAIN, path);
    log("[${DateTime.now().toLocal().toString().split(' ')[1]}] GET url: $url");
    final headers = await getHeaders();
    final response = await http.get(url, headers: headers);
    if (response.statusCode == StatusCodeConstants.OK ||
        response.statusCode == StatusCodeConstants.CREATED) {
      return response.body;
    } else {
      return "";
    }
  }

  /// Sends a GET request to the server with the specified parameters.
  ///
  /// This function constructs a URL from the provided [path] and [params],
  /// then sends an HTTP GET request to the server. If the response has a
  /// status code of 200, the function returns the response body.
  /// Otherwise, it returns an empty string.
  ///
  /// [path] is the endpoint on the server.
  /// [params] is a map containing query parameters for the request.
  ///
  /// Returns a [Future<String>] containing the server response body.
  Future<String> getDataFromServerWithParams(
      String path, Map<String, dynamic> params) async {
    final url = Uri.https(ApplicationConstants.DOMAIN, path, params);
    log("[${DateTime.now().toLocal().toString().split(' ')[1]}] GET Params url: $url");
    final headers = await getHeaders();
    final response = await http.get(url, headers: headers);
    if (response.statusCode == StatusCodeConstants.CREATED ||
        response.statusCode == StatusCodeConstants.OK) {
      return response.body;
    } else {
      return "";
    }
  }

  /// Creates new data on the server using a POST request.
  ///
  /// [path] is the endpoint for the request, and [body] contains the data
  /// to be sent. Returns the HTTP status code of the response.
  Future<int> createDataInServer(String path, Map<String, dynamic> body) async {
    final url = Uri.https(ApplicationConstants.DOMAIN, path);
    log("[${DateTime.now().toLocal().toString().split(' ')[1]}] POST url: $url");
    final headers = await getHeaders();
    final response =
    await http.post(url, headers: headers, body: jsonEncode(body));
    return response.statusCode;
  }

  /// Updates existing data on the server using a PUT request.
  ///
  /// [path] is the endpoint for the request, and [body] contains the data
  /// to be updated. Returns the HTTP status code of the response.
  Future<int> updateDataInServer(String path, Map<String, dynamic> body) async {
    final url = Uri.https(ApplicationConstants.DOMAIN, path);
    log("[${DateTime.now().toLocal().toString().split(' ')[1]}] PUT url: $url");
    final headers = await getHeaders();
    final response =
    await http.put(url, headers: headers, body: jsonEncode(body));
    return response.statusCode;
  }

  /// Deletes data from the server using a DELETE request.
  ///
  /// [path] is the endpoint for the request. Returns the HTTP status code
  /// of the response, indicating the result of the deletion operation.
  /// A status code of 200 indicates success, while other codes indicate
  /// failure or an error.
  Future<int> deleteDataInServer(String path) async {
    final url = Uri.https(ApplicationConstants.DOMAIN, path);
    log("[${DateTime.now().toLocal().toString().split(' ')[1]}]   DELETE url: $url");
    final headers = await getHeaders();
    final response = await http.delete(url, headers: headers);
    return response.statusCode;
  }
}
