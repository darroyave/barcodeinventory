import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppbar extends StatefulWidget {
  final String title; // Variable para el título
  const CustomAppbar({super.key, required this.title});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.green, // transparente para ver el gradiente
      ),
    );
  }
}
