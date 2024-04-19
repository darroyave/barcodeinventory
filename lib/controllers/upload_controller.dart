import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/product.dart';
import '../service/inventory_service.dart';
import '../utils/app_constants.dart';

class UploadController extends GetxController implements GetxService {
  final productController = TextEditingController();

  final InventoryService _inventoryService = InventoryService();
  final ImagePicker _picker = ImagePicker();

  String _productName = "";
  String get productName => _productName;

  bool _isLoadingCamera = false;
  bool get isLoadingCamera => _isLoadingCamera;

  bool _isLoadingGallery = false;
  bool get isLoadingGallery => _isLoadingGallery;

  Uint8List? imageBytes;

  void searchProduct(barCode) async {
    http.Response response = await _inventoryService.authorizedGet(
      "${AppConstants.urlBase}/api/product/upc/${AppConstants.branchIdDailyStop}/$barCode",
    );

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      Product? product = Product.fromJson(data);

      _productName = product.name;
      update();
    } else {
      _productName = "Product does not exist";
      update();
    }
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _isLoadingGallery = true;
      update();

      final bytes = await image.readAsBytes();
      await removeBackgroundFromBytes(bytes);

      _isLoadingGallery = false;
      update();
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _isLoadingCamera = true;
      update();

      final bytes = await image.readAsBytes();
      await removeBackgroundFromBytes(bytes);

      _isLoadingCamera = false;
      update();
    }
  }

  Future<void> removeBackgroundFromBytes(Uint8List imageBytes) async {
    var uri = Uri.parse(AppConstants.urlRemoveBg);
    var response = await http.post(
      uri,
      headers: {
        'X-Api-Key': AppConstants.tokenRemoveBg,
        'Content-Type': 'application/json',
      },
      body: json
          .encode({'image_file_b64': base64Encode(imageBytes), 'size': 'auto'}),
    );

    if (response.statusCode == 200) {
      this.imageBytes = response.bodyBytes;
      update();
    } else {
      if (kDebugMode) {
        print('Error al eliminar el fondo: ${response.body}');
      }
    }
  }
}
