import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_constants.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController =
      TextEditingController(text: "3176994381");
  final TextEditingController _passwordController =
      TextEditingController(text: "12345678");

  Future<void> _login() async {
    String userName = _userNameController.text;
    String password = _passwordController.text;

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

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _userNameController,
              decoration: const InputDecoration(labelText: 'UserName'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
