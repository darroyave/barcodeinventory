import 'package:flutter/material.dart';

class SideMenuTile extends StatelessWidget {
  const SideMenuTile({
    super.key,
    required this.ontap,
    required this.name, required IconData icon,
  });
  final VoidCallback ontap;
  final String name;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ontap,
      title: Text(name),
      leading: Container(
        color: Colors.white,
        height: 34,
        width: 34,
        child: Image.asset('assets/image/account.png'),
      ),
    );
  }
}
