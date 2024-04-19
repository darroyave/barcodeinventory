import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

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
  bool isLoading = false; // Nuevo estado para controlar la carga

  Future<void> pickImageFromGallery() async {
    setState(() {
      isLoading = true; // Activar indicador de carga al seleccionar imagen
    });
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      removeBackgroundFromBytes(bytes);
    } else {
      setState(() {
        isLoading = false; // Desactivar indicador si no se selecciona imagen
      });
    }
  }

  Future<void> pickImageFromCamera() async {
    setState(() {
      isLoading = true; // Activar indicador de carga al tomar foto
    });
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final bytes = await image.readAsBytes();
      removeBackgroundFromBytes(bytes);
    } else {
      setState(() {
        isLoading = false; // Desactivar indicador si no se toma foto
      });
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

    setState(() {
      this.imageBytes = response.statusCode == 200 ? response.bodyBytes : null;
      isLoading = false; // Desactivar indicador de carga después de procesar
    });
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
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "Now Press Image and scan Product",
              labelText: 'Scan Product',
              prefixIcon: IconButton(
                onPressed: () {
                  _productController.clear();
                  setState(() {
                    _productName = null;
                  });
                },
                icon: const Icon(Icons.clear),
              ),
              suffixIcon: IconButton(
                onPressed: () async {
                  //    _searchProduct(_productController.text);
                },
                icon: const Icon(Icons.search),
              ),
            ),
            onFieldSubmitted: (_) {
              // _searchProduct(_productController.text);
            },
          ),
          const SizedBox(height: 12.0),
          CustomButtonWidget(
            isLoading: false,
            buttonText: "Select image from gallery",
            onPressed: pickImageFromGallery,
          ),
          const SizedBox(height: 10),
          CustomButtonWidget(
            isLoading: false,
            buttonText: "Take photo",
            onPressed: pickImageFromCamera,
            buttonColor: ColorResources.colorPrint,
          ),
          isLoading
              ? Center(
                  child: Lottie.asset('assets/lottie/ai_loading.json'))
              : imageBytes != null
                  ? Image.memory(imageBytes!, height: 200)
                  : const Text('Select an image'),
        ],
      ),
    );
  }
}
