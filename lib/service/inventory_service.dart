import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InventoryService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<http.Response> authorizedGet(String url) async {
    String? token = await getToken();
    if (token != null) {
      return http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
    } else {
      throw Exception('No token available');
    }
  }

  Future<http.Response> authorizedPost(String url, dynamic json) async {
    String? token = await getToken();
    if (token != null) {
      return http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(json));
    } else {
      throw Exception('No token available');
    }
  }
}
