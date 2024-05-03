import 'package:barcodeinventory/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'controllers/theme_controller.dart';
import 'screens/add_product_screen.dart';
import 'screens/barcode_generate_screen.dart';
import 'screens/check_price_screen.dart';
import 'screens/count_inventory_screen.dart';
import 'screens/home_screen.dart';
import 'screens/receive_inventory_screen.dart';
import 'screens/login_screen.dart';
import 'screens/out_stock_screen.dart';
import 'screens/show_inventory_screen.dart';
import 'screens/transfer_inventory_screen.dart';
import 'screens/upload_image_screen.dart';
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
          theme: appTheme,
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const HomeScreen(),
            '/showinventory': (context) => const ShowInventoryScreen(),
            '/entryinventory': (context) => const ReceiveInventory(),
            '/countinventory': (context) => const CountInventoryScreen(),
            '/checkprice': (context) => const CheckPriceScreen(),
            '/addproduct': (context) => const AddProductScreen(),
            '/transferinventory': (context) => const TransferStockScreen(),
            '/outinventory': (context) => const OutStockScreen(),
            '/barcodegenerator': (context) => const BarCodeGenerateScreen(),
            '/uploadImage': (context) => const UploadImageScreen(),
          },
        );
      },
    );
  }
}
