import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../service/inventory_service.dart';
import '../utils/app_constants.dart';
import '../utils/color_resources.dart';
import '../widgets/custom_button_widget.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final TextEditingController _productController = TextEditingController();

  final InventoryService _inventoryService = InventoryService();

  String? _productName;

  Uint8List? imageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      removeBackgroundFromBytes(bytes);
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final bytes = await image.readAsBytes();
      removeBackgroundFromBytes(bytes);
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
      setState(() {
        this.imageBytes = response.bodyBytes;
      });
    } else {
      if (kDebugMode) {
        print('Error al eliminar el fondo: ${response.body}');
      }
    }
  }

  _searchProduct(String barCode) async {
    http.Response response = await _inventoryService.authorizedGet(
      "${AppConstants.urlBase}/api/product/upc/${AppConstants.branchIdDailyStop}/$barCode",
    );

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      Product? product = Product.fromJson(data);

      setState(() {
        _productName = product.name;
      });
    } else {
      setState(() {
        _productName = "Product does not exist";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload image product'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          TextFormField(
            controller: _productController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.teal),
              ),
              hintText: "Now Press Image and scan Product",
              hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              labelText: 'Scan Product',
              prefixIcon: IconButton(
                color: Colors.teal,
                onPressed: () async {
                  _productController.text = "";
                  _productName = "";
                },
                icon: const Icon(Icons.clear),
              ),
              suffixIcon: IconButton(
                color: Colors.teal,
                onPressed: () async {},
                icon: const Icon(Icons.search),
              ),
            ),
            onFieldSubmitted: (_) async {
              _searchProduct(_productController.text);
            },
          ),
          const SizedBox(height: 12.0),
          CustomButtonWidget(
            isLoading: false,
            buttonText: "Select image from gallery",
            onPressed: pickImageFromCamera,
          ),
          const SizedBox(height: 10),
          CustomButtonWidget(
            isLoading: false,
            buttonText: "Take photo",
            onPressed: pickImageFromCamera,
            buttonColor: ColorResources.colorPrint,
          ),
          imageBytes != null
              ? Image.memory(
                  imageBytes!,
                  height: 200,
                )
              : const Text('Select an image'),
        ],
      ),
    );
  }
}
