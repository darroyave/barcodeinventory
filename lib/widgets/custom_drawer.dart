import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onSelectPage;
  final Function(BuildContext) onLogout;

  const CustomDrawer(
      {super.key, required this.onSelectPage, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
           
                SideMenuTile(
                  ontap: () {
                    onSelectPage(0);
                  },
                  name: 'Check Price',
                  icon: Icons.book, // Using Ionicons
                ),
                SideMenuTile(
                  ontap: () => onSelectPage(1),
                  name: 'Show Inventory',
                  icon: Icons.abc_outlined,
                ),
                SideMenuTile(
                  ontap: () => onSelectPage(2),
                  name: 'Receive Inventory',
                  icon: Icons.list,
                ),
                SideMenuTile(
                  ontap: () => onSelectPage(3),
                  name: 'Barcode Generator',
                  icon: Icons.qr_code,
                ),
                const Divider(
                  height: 1,
                  color: Colors.green,
                ),
                SideMenuTile(
                  ontap: () => onSelectPage(4),
                  name: 'Add Product',
                  icon: Icons.add_a_photo,
                ),
                SideMenuTile(
                  ontap: () => onSelectPage(5),
                  name: 'Transfer Products',
                  icon: Icons.doorbell_sharp,
                ),
                const Divider(),
                SideMenuTile(
                  ontap: () => onSelectPage(6),
                  name: 'AI Image',
                  icon: Icons.swap_calls,
                ),
                SideMenuTile(
                  ontap: () => onSelectPage(7),
                  name: 'Count Inventory',
                  icon: Icons.countertops,
                ),
                const Divider(),
        
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Log Out',
                      style: TextStyle(color: Colors.redAccent)),
                  onTap: () => onLogout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SideMenuTile extends StatelessWidget {
  const SideMenuTile({
    super.key,
    required this.ontap,
    required this.name,
    required this.icon,
  });
  final VoidCallback ontap;
  final String name;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleTextStyle: Theme.of(context).textTheme.bodyLarge,
      onTap: ontap,
      title: Text(name),
      leading: Icon(icon),
    );
  }
}
