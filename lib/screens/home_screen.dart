import 'package:barcodeinventory/screens/add_product_screen.dart';
import 'package:barcodeinventory/widgets/custom_appbar.dart';
import 'package:barcodeinventory/screens/barcode_generate_screen.dart';
import 'package:barcodeinventory/screens/check_price_screen.dart';
import 'package:barcodeinventory/screens/show_inventory_screen.dart';
import 'package:barcodeinventory/screens/transfer_stock_screen.dart';
import 'package:barcodeinventory/screens/upload_image_screen.dart';
import 'package:barcodeinventory/screens/inventory_entry_screen.dart';
import 'package:barcodeinventory/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const ShowInventoryScreen(),
    const InventoryEntryScreen(),
    const BarCodeGenerateScreen(),
    const AddProductScreen(),
    const CheckPriceScreen(),
    const TransferStockScreen(),
    const UploadImageScreen(),
  ];

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer after selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppbar(title: 'Dailystop'),
      ),
      drawer: CustomDrawer(onSelectPage: _selectPage, onLogout: _logout),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
