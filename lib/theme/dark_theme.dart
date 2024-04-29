import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF003473),
  secondaryHeaderColor: const Color(0xFFCC003F),
  disabledColor: const Color(0xffa2a7ad),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFbebebe),
  cardColor: Colors.black,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF343636),
    error: Color(0xFFdd3135),
  ),
  textTheme: GoogleFonts.latoTextTheme(
    // Asegúrate de pasar aquí el textTheme del contexto del MaterialApp
    const TextTheme(
      displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  ),
);
