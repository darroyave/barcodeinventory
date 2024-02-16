import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../utils/app_constants.dart';

class ShowInventoryScreen extends StatefulWidget {
  const ShowInventoryScreen({super.key});

  @override
  State<ShowInventoryScreen> createState() => _ShowInventoryScreenState();
}

class _ShowInventoryScreenState extends State<ShowInventoryScreen> {
  final TextEditingController _productController = TextEditingController();

  String? _productName;
  int? _stock = 0;

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      if (barcodeScanRes != '-1') {
        _productController.text = barcodeScanRes;

        // Buscar el producto
        _searchProduct(barcodeScanRes);
      }
    });
  }

  _searchProduct(String barCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('token');

    final response = await http.get(
      Uri.parse("${AppConstants.urlBase}/api/product/upc/31/$barCode"),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      Product? product = Product.fromJson(data);

      setState(() {
        _productName = product.name;
        _stock = product.stock ?? 0;
      });
    } else {
      setState(() {
        _productName = "Producto no existe";
        _stock = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Inventory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _productController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                hintText: "Now Press Image and scan Product",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                labelText: 'Scan Product',
                suffixIcon: IconButton(
                  color: Colors.teal,
                  onPressed: () async {
                    await scanBarcodeNormal();
                  },
                  icon: const Icon(Icons.barcode_reader),
                ),
              ),
              onFieldSubmitted: (_) async {
                _searchProduct(_productController.text);
              },
            ),
            const SizedBox(height: 12.0),
            Center(
              child: Text(
                _productName ?? "",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            const SizedBox(height: 12.0),
            Center(
              child: Text(
                "Stock: $_stock",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
