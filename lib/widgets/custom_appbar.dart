import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppbar extends StatefulWidget {
  final String title; // Variable para el título
  final GlobalKey<ScaffoldState> scaffoldKey; // Añadir esto

  const CustomAppbar(
      {super.key, required this.title, required this.scaffoldKey});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            widget.scaffoldKey.currentState
                ?.openDrawer(); // Usar la clave pasada
          },
        ),
      ],
      title: Text(widget.title),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.white,
      ),
    );
  }
}
