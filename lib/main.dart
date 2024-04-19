import 'package:barcodeinventory/screens/barcode_generate_screen.dart';
import 'package:barcodeinventory/screens/check_price_screen.dart';
import 'package:barcodeinventory/screens/count_inventory_screen.dart';
import 'package:barcodeinventory/screens/inventory_entry_screen.dart';
import 'package:barcodeinventory/screens/show_inventory_screen.dart';
import 'package:barcodeinventory/screens/transfer_stock_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'controllers/theme_controller.dart';
import 'screens/add_item.dart';
import 'screens/add_product_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/out_stock_screen.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';
import 'utils/get_di.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.bluetooth.request();
  await Permission.bluetoothConnect.request();
  await Permission.bluetoothScan.request();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          title: 'Barcode Inventory',
          debugShowCheckedModeBanner: false,
          theme: themeController.darkTheme ? dark : light,
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
            '/checkprice': (context) => const CheckPriceScreen(),
            '/barcodegenerator': (context) => const BarCodeGenerateScreen(),
            '/additem': (context) => const AddItem(),
          },
        );
      },
    );
  }
}
