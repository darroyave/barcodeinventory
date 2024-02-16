import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_constants.dart';

class AuthService {
  Future<void> login(String userName, String password) async {
    final response = await http.post(
      Uri.parse('${AppConstants.urlBase}${AppConstants.login}'),
      body: json.encode({'email': userName, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      String accessToken = responseData['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', accessToken);
    } else {
      throw Exception('Login failed');
    }
  }
}
