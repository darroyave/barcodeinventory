import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  _searchProduct(String barCode) async {
    http.Response response = await _inventoryService.authorizedGet(
      "${AppConstants.urlBase}/api/product/upc/${AppConstants.branchIdDailyStop}/$barCode",
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      Product? product = Product.fromJson(data);
      debugPrint(product.price.toString());

      setState(() {
        _productId = product.id;
        _productName = product.name;

        products.add(Product(
          id: product.id,
          name: product.name,
          stock: 0,
          price: product.price,
        ));
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text('CHECK PRICES'),
              ),
            ),
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
                  onPressed: () async {
                    _searchProduct(_productController.text);
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
              onFieldSubmitted: (value) {
                // Add a line break after scanning
                _productController.text += '\n';
                // Then perform your search
                _searchProduct(_productController.text);
              },
            ),
            const SizedBox(height: 12.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      products[index].name,
                      style: const TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    subtitle: SizedBox(
                      width: 100.0,
                      child: Text(
                        '\$${products[index].price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 24, color: Colors.red),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
