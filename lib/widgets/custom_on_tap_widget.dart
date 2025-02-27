import 'package:flutter/material.dart';

class CustomOnTapWidget extends StatelessWidget {
  final double? radius;
  final Widget child;
  final VoidCallback? onTap;
  final Color? highlightColor;
  const CustomOnTapWidget(
      {super.key,
      this.radius,
      required this.child,
      this.onTap,
      this.highlightColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onTap ?? () {},
        child: child,
      ),
    );
  }
}
