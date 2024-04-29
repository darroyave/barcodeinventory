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
          const CustomAccountDrawer(),
          Expanded(
            child: ListView(
              children: [
                SideMenuTile(
                  ontap: () => onSelectPage(0),
                  name: 'Show Inventory',
                  icon: Icons.book, // Using Ionicons
                ),
                SideMenuTile(
                  ontap: () => onSelectPage(1),
                  name: 'Entry Inventory',
                  icon: Icons.abc_outlined,
                ),
                SideMenuTile(
                  ontap: () => onSelectPage(2),
                  name: 'Barcode Generator',
                  icon: Icons.qr_code,
                ),
                const Divider(),
                SideMenuTile(
                  ontap: () => onSelectPage(3),
                  name: 'Add Product',
                  icon: Icons.add_a_photo,
                ),
                SideMenuTile(
                  ontap: () => onSelectPage(4),
                  name: 'Check Price',
                  icon: Icons.doorbell_sharp,
                ),
                const Divider(),
                SideMenuTile(
                  ontap: () => onSelectPage(5),
                  name: 'Transfer Stock',
                  icon: Icons.swap_calls,
                ),
                SideMenuTile(
                  ontap: () => onSelectPage(6),
                  name: 'AI Image',
                  icon: Icons.filter,
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

class CustomAccountDrawer extends StatelessWidget {
  const CustomAccountDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const UserAccountsDrawerHeader(
      accountName: Text('Manager '),
      accountEmail: Text('zameer@dailystop.com'),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(
            'https://img.freepik.com/premium-vector/business-global-economy_24877-41082.jpg'),
        backgroundColor: Colors.white,
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
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
      onTap: ontap,
      title: Text(name),
      leading: Icon(icon),
    );
  }
}
