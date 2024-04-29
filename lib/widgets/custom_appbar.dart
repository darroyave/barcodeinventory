import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppbar extends StatefulWidget {
  final String title; // Agregamos una variable para el título
  const CustomAppbar(
      {super.key,
      required this.title}); // Modificamos el constructor para aceptar el título

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.title,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 20)), // Usamos el título desde el widget
        centerTitle: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        bottomOpacity: 0.5,
        //  shadowColor: Colors.redAccent,
        toolbarOpacity: 0.9,
        elevation: 100,
        //    foregroundColor: Colors.red,
        leadingWidth: 30,
        primary: true,
        scrolledUnderElevation: 100,
        titleSpacing: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.green,
        ),
        toolbarTextStyle: const TextStyle(
          color: Colors.white,
        ),
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        notificationPredicate: (ScrollNotification notification) {
          return notification is ScrollUpdateNotification &&
              notification.scrollDelta! < 0;
        },
        iconTheme: const IconThemeData(
          size: 25,
        ),
        forceMaterialTransparency: false,
        bottom: PreferredSize(
          preferredSize: const Size(0, 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "DASHBOARD CONTROL",
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        actionsIconTheme: const IconThemeData(
          color: Colors.white24,
        ));
  }
}
