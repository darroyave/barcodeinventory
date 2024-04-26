import 'package:barcodeinventory/screens/add_product_screen.dart';
import 'package:barcodeinventory/screens/barcode_generate_screen.dart';
import 'package:barcodeinventory/screens/check_price_screen.dart';
import 'package:barcodeinventory/screens/count_inventory_screen.dart';
import 'package:barcodeinventory/screens/show_inventory_screen.dart';
import 'package:barcodeinventory/screens/transfer_stock_screen.dart';
import 'package:barcodeinventory/screens/upload_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    const CountInventoryScreen(),
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Show  Inventory'),
              onTap: () => _selectPage(0),
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Inventory Entry'),
              onTap: () => _selectPage(1),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('Barcode Generator'),
              onTap: () =>
                  _selectPage(2), // Updated to index 2 to match the list size
            ),
            ListTile(
              leading: const Icon(Icons.money_off),
              title: const Text('Add Products'),
              onTap: () =>
                  _selectPage(3), // Updated to index 2 to match the list size
            ),
            ListTile(
              leading: const Icon(Icons.money_off),
              title: const Text('Check Price'),
              onTap: () =>
                  _selectPage(4), // Updated to index 2 to match the list size
            ),
            ListTile(
              leading: const Icon(Icons.money_off),
              title: const Text('Trasnfer '),
              onTap: () =>
                  _selectPage(5), // Updated to index 2 to match the list size
            ),
            ListTile(
              leading: const Icon(Icons.transfer_within_a_station_outlined),
              title: const Text('Trasnfer Stock'),
              onTap: () =>
                  _selectPage(6), // Updated to index 2 to match the list size
            ),
            ListTile(
              leading: const Icon(Icons.transfer_within_a_station_outlined),
              title: const Text('Upload Image'),
              onTap: () =>
                  _selectPage(7), // Updated to index 2 to match the list size
            ),
            ListTile(
              leading: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(context),
              ),
              title: const Text('Logout'),
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
