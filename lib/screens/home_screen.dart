import 'package:barcodeinventory/screens/add_product_screen.dart';
import 'package:barcodeinventory/screens/count_inventory_screen.dart';
import 'package:barcodeinventory/screens/barcode_generate_screen.dart';
import 'package:barcodeinventory/screens/check_price_screen.dart';
import 'package:barcodeinventory/screens/show_inventory_screen.dart';
import 'package:barcodeinventory/screens/transfer_inventory_screen.dart';
import 'package:barcodeinventory/screens/upload_image_screen.dart';
import 'package:barcodeinventory/screens/receive_inventory_screen.dart';
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
    const CheckPriceScreen(),
    const ShowInventoryScreen(),
    const ReceiveInventory(),
    const BarCodeGenerateScreen(),
    const AddProductScreen(),
    const TransferStockScreen(),
    const UploadImageScreen(),
    const CountInventoryScreen(),
  ];

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    // ignore: use_build_context_synchronously
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(56),
        //   child: CustomAppbar(
        //     title: _pageTitle,
        //   ),
        // ),
        drawer: CustomDrawer(onSelectPage: _selectPage, onLogout: _logout),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
    );
  }
}
