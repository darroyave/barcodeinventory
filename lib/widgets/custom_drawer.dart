import 'package:barcodeinventory/widgets/custom_header_widget.dart';
import 'package:barcodeinventory/widgets/images.dart';
import 'package:barcodeinventory/widgets/side_menu_tile.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onSelectPage;
  final Function(BuildContext) onLogout;

  const CustomDrawer(
      {super.key, required this.onSelectPage, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const CustomHeaderWidget(
            headerImage: Images.account,
            title: 'Manager',
          ),
          SideMenuTile(
            ontap: () => onSelectPage(0),
            name: 'SHOW INVENTORY',
            icon: Icons.inventory, // Asumiendo que el tipo esperado es IconData
          ),
          SideMenuTile(
            ontap: () => onSelectPage(1),
            name: 'ENTRY INVENTORY',
            icon: Icons.input,
          ),
          SideMenuTile(
            ontap: () => onSelectPage(2),
            name: 'BARCODE GENERATOR',
            icon: Icons.qr_code_scanner,
          ),
          const Divider(),
          SideMenuTile(
            ontap: () => onSelectPage(3),
            name: 'ADD PRODUCT',
            icon: Icons.add_circle_outline,
          ),
          SideMenuTile(
            ontap: () => onSelectPage(4),
            name: 'CHECK PRICE',
            icon: Icons.attach_money,
          ),
          const Divider(),
          SideMenuTile(
            ontap: () => onSelectPage(5),
            name: 'TRANSFER STOCK',
            icon: Icons.swap_horiz,
          ),
          SideMenuTile(
            ontap: () => onSelectPage(6),
            name: 'AI IMAGE',
            icon: Icons.image,
          ),
          const Divider(),
          // CustomCategoryButtonWidget(
          //  icon: Icon(Ico),
          //   buttonText: "Log Out",
          //   onTap: () => onLogout(context),
          //   textStyle: GoogleFonts.notoSans(
          //     color: Colors.redAccent,
          //     fontSize: 16,
          //   ),
          //   showDivider: true,
          // ),
        ],
      ),
    );
  }
}
