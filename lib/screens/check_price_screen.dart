import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan2/barcode_scan2.dart';

import '../models/product.dart';
import '../service/inventory_service.dart';
import '../utils/app_constants.dart';

class CheckPriceScreen extends StatefulWidget {
  const CheckPriceScreen({super.key});

  @override
  State<CheckPriceScreen> createState() => _CheckPriceScreenState();
}

class _CheckPriceScreenState extends State<CheckPriceScreen> {
  final TextEditingController _productController = TextEditingController();
  final InventoryService _inventoryService = InventoryService();
  List<Product> products = [];
  String? _productName;
  int? _productId;

  Future<void> _scanAndSearchProduct() async {
    var result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode) {
      _productController.text = result.rawContent;
      await _searchProduct(result.rawContent);
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
        _productId = product.id;
        _productName = product.name;
        products.add(product);
      });
    } else {
      setState(() {
        _productId = 0;
        _productName = "Product doesn't exist";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Espacio en la parte superior
            Text(
              'Check Prices',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.teal, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _productController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                hintText: "Scan Product",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                labelText: 'Enter or Scan Product Code',
                prefixIcon: const Icon(Icons.qr_code_scanner),
                suffixIcon: IconButton(
                  color: Colors.teal,
                  onPressed: _scanAndSearchProduct,
                  icon: const Icon(Icons.camera_alt),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(
                        products[index].name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '\$${products[index].price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
