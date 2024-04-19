import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/product_controller.dart';
import '../controllers/theme_controller.dart';

Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  // Repository

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));

  Get.lazyPut(() => ProductController());
}
