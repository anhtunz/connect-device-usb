// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../cache/locale_manager.dart';
import '../constants/enums/locale_keys_enum.dart';

class APIServices {
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    "Access-Control-Allow-Credentials": "false",
    "Access-Control-Allow-Headers":
    "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    'Access-Control-Allow-Origin': "*",
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS, PUT, PATCH, DELETE',
  };

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

  // Future<String> login(String path, Map<String, dynamic> loginRequest) async {
  //   final url = Uri.https(ApplicationConstants.DOMAIN, path);
  //   final headers = await getHeaders();
  //   final response =
  //   await http.post(url, headers: headers, body: jsonEncode(loginRequest));
  //   return response.body;
  // }


  // Future<void> logOut(BuildContext context) async {
  //   showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text(appLocalization(context).log_out_content,
  //             textAlign: TextAlign.center),
  //         actions: [
  //           TextButton(
  //             onPressed: () async {
  //               var url = Uri.http(ApplicationConstants.DOMAIN,
  //                   APIPathConstants.LOGOUT_PATH);
  //               final headers = await NetworkManager.instance!.getHeaders();
  //               final response = await http.post(url, headers: headers);
  //               if (response.statusCode == 200) {
  //                 LocaleManager.instance
  //                     .deleteStringValue(PreferencesKeys.UID);
  //                 LocaleManager.instance
  //                     .deleteStringValue(PreferencesKeys.TOKEN);
  //                 LocaleManager.instance
  //                     .deleteStringValue(PreferencesKeys.EXP);
  //                 LocaleManager.instance
  //                     .deleteStringValue(PreferencesKeys.ROLE);
  //                 context.goNamed(AppRoutes.LOGIN.name);
  //               } else {
  //                 showErrorTopSnackBarCustom(
  //                     context, "Error: ${response.statusCode}");
  //               }
  //             },
  //             child: Text(appLocalization(context).log_out,
  //                 style: const TextStyle(color: Colors.red)),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text(appLocalization(context).cancel_button_content),
  //           ),
  //         ],
  //       ));
  // }
  //

  Future<String> checkTheme() async {
    String theme = LocaleManager.instance.getStringValue(PreferencesKeys.THEME);
    return theme;
  }

  Future<String> checkLanguage() async {
    String language =
    LocaleManager.instance.getStringValue(PreferencesKeys.LANGUAGE_CODE);
    return language;
  }

}
