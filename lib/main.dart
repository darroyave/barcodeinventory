import 'package:dailystopstock/screens/Login/login_screen.dart';
import 'package:dailystopstock/utils/custom_color.g.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        extensions: [lightCustomColors],
      ),
      darkTheme: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.orange.shade100,
          indicatorColor: Colors.orange.shade700,
        ),
        useMaterial3: true,
        extensions: [darkCustomColors],
      ),
      home: const LoginScreen(),
    );
  }
}
