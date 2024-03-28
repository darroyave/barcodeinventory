import 'package:barcodeinventory/screens/count_inventory_screen.dart';
import 'package:barcodeinventory/screens/inventory_entry_screen.dart';
import 'package:barcodeinventory/screens/show_inventory_screen.dart';
import 'package:barcodeinventory/screens/transfer_stock_screen.dart';
import 'package:flutter/material.dart';

import 'screens/add_product_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/out_stock_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Inventory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/showinventory': (context) => const ShowInventoryScreen(),
        '/addproduct': (context) => const AddProductScreen(),
        '/entryinventory': (context) => const InventoryEntryScreen(),
        '/transferinventory': (context) => const TransferStockScreen(),
        '/outinventory': (context) => const OutStockScreen(),
        '/countinventory': (context) => const CountInventoryScreen(),
      },
    );
  }
}
