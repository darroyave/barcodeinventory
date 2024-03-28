import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../service/inventory_service.dart';
import '../utils/app_constants.dart';

class ShowInventoryScreen extends StatefulWidget {
  const ShowInventoryScreen({super.key});

  @override
  State<ShowInventoryScreen> createState() => _ShowInventoryScreenState();
}

class _ShowInventoryScreenState extends State<ShowInventoryScreen> {
  final TextEditingController _productController = TextEditingController();

  final InventoryService _inventoryService = InventoryService();

  String? _productName;
  int? _stock = 0;

  _searchProduct(String barCode) async {
    http.Response response = await _inventoryService.authorizedGet(
      "${AppConstants.urlBase}/api/product/upc/${AppConstants.branchIdDailyStop}/$barCode",
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
        _productName = "Product does not exist";
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
            Center(
              child: Text(
                _productName ?? "",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
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
