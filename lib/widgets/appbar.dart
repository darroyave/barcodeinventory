import 'package:dailystopstock/utils/custom_color.g.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final Widget title;
  @override
  const CustomAppbar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white, size: 30),
      titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          fontFamily: 'roboto',
          color: Colors.white),
      title: title,
      centerTitle: true,
      backgroundColor: secondary,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: tertiary,
        ),
      ),
    );
  }
}
