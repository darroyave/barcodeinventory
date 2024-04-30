import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData light = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF003473),
  secondaryHeaderColor: const Color(0xFFCC003F),
  disabledColor: const Color(0xFFBABFC4),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.white,
    elevation: 10,
    shadowColor: Color(0xFFC2CAD9),
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFFEEBD8D),
    onPrimary: const Color(0xFF003473),
    secondary: const Color(0xFFCC003F),
    onSecondary: const Color(0xFFCC003F),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    surface: Colors.white,
    onSurface: const Color(0xFF002349),
    shadow: Colors.grey[300],
    // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
  ),
  textTheme: GoogleFonts.latoTextTheme(
    // Asegúrate de pasar aquí el textTheme del contexto del MaterialApp
    TextTheme(
        displayLarge:
            const TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        titleLarge:
            const TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyMedium: const TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        bodyLarge: GoogleFonts.montserrat(fontSize: 24)),
  ),
);
