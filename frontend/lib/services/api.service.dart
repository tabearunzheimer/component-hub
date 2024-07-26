import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class APIService {
  Future<dynamic> requestWrapper(Future<Response> responseFuture) async {
    try {
      final response = await responseFuture;
      switch (response.statusCode) {
        case 401:
          debugPrint("No authorization implemented");
          break;
        case 200:
        case 204:
        default:
          return json.decode(response.body);
      }
      return {};
    } catch (e, stackTrace) {
      debugPrint("Caught exception: $e");
      debugPrint("Stack trace: $stackTrace");
      return {'Exception': e};
    }
  }
}
