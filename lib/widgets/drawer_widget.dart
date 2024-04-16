import 'package:flutter/material.dart';

import 'custom_category_button_widget.dart';
import 'images.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'DailyStop',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Show Inventory'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/showinventory');
            },
          ),
          ListTile(
            title: const Text('Show Price'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/checkprice');
            },
          ),
          ListTile(
            title: const Text('Add Product'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/addproduct');
            },
          ),
          ListTile(
            title: const Text('Inventory Entry'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/entryinventory');
            },
          ),
          ListTile(
            title: const Text('Transfer Inventory'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/transferinventory');
            },
          ),
          ListTile(
            title: const Text('Out Inventory'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/outinventory');
            },
          ),
          ListTile(
            title: const Text('Count Inventory'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/countinventory');
            },
          ),
          ListTile(
            title: const Text('Barcode Generator'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/barcodegenerator');
            },
          ),
          CustomCategoryButtonWidget(
            icon: Images.logout,
            buttonText: "Log Out",
            onTap: () {},
            showDivider: true,
          ),
        ],
      ),
    );
  }
}
