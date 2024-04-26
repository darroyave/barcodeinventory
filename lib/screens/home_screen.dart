import 'package:barcodeinventory/screens/add_product_screen.dart';
import 'package:barcodeinventory/screens/barcode_generate_screen.dart';
import 'package:barcodeinventory/screens/check_price_screen.dart';
import 'package:barcodeinventory/screens/show_inventory_screen.dart';
import 'package:barcodeinventory/screens/transfer_stock_screen.dart';
import 'package:barcodeinventory/screens/upload_image_screen.dart';
import 'package:barcodeinventory/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_category_button_widget.dart';
import 'inventory_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  int _selectedIndex = 0; // Controlar el índice de la vista seleccionada

  final List<Widget> _pages = [
    const ShowInventoryScreen(),
    const InventoryEntryScreen(),
    const BarCodeGenerateScreen(),
    const AddProductScreen(),
    const CheckPriceScreen(),
    const TransferStockScreen(),
    const UploadImageScreen(),
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Cierra el drawer automáticamente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text('DailyStop Control'),
        actions: const <Widget>[],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text("User Name"),
              accountEmail: Text("user@dailystop.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn1.iconfinder.com/data/icons/bokbokstars-121-classic-stock-icons-1/512/person-man.png"),
                backgroundColor: Colors.white,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Show Inventory'),
              onTap: () => _selectPage(0),
            ),
            ListTile(
              leading: const Icon(Icons.input),
              title: const Text('Inventory Entry'),
              onTap: () => _selectPage(1),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('Barcode Generator'),
              onTap: () => _selectPage(2),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_shopping_cart),
              title: const Text('Add Products'),
              onTap: () => _selectPage(3),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Check Price'),
              onTap: () => _selectPage(4),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.sync_alt),
              title: const Text('Transfer Stock'),
              onTap: () => _selectPage(5),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Upload Image'),
              onTap: () => _selectPage(6),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Upload Image'),
              onTap: () => _selectPage(6),
            ),
            CustomCategoryButtonWidget(
              icon: Images.logout,
              buttonText: "Log Out",
              onTap: () => _logout(context),
              showDivider: true,
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
