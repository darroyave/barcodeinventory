import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/product_data.dart';
import '../service/inventory_service.dart';
import '../utils/app_constants.dart';

class CountInventoryScreen extends StatefulWidget {
  const CountInventoryScreen({super.key});

  @override
  State<CountInventoryScreen> createState() => _CountInventoryScreenState();
}

class _CountInventoryScreenState extends State<CountInventoryScreen> {
  final TextEditingController _productController = TextEditingController();

  final InventoryService _inventoryService = InventoryService();

  List<ProductData> countData = [];

  String? _productName;
  int? _productId;

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

        countData
            .add(ProductData(id: product.id, name: product.name, stock: 0));
      });
    } else {
      setState(() {
        _productId = 0;
        _productName = "Producto no existe";
      });
    }
  }

  Future<void> _submitCount() async {
    http.Response response = await _inventoryService.authorizedPost(
      '${AppConstants.urlBase}/api/inventorycount/data',
      <String, dynamic>{
        'products': countData,
        'store': AppConstants.branchIdDailyStop,
      },
    );

    if (response.statusCode == 200) {
      _showErrorDialog('The entry was successfully registered.');
    } else {
      _showErrorDialog('The inventory entry could not be recorded.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
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
              onFieldSubmitted: (_) async {
                _searchProduct(_productController.text);
              },
            ),
            const SizedBox(height: 12.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: countData.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(countData[index].name),
                    trailing: SizedBox(
                      width: 100.0,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Quantity'),
                        onChanged: (value) {
                          countData[index].stock = int.parse(value);
                        },
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

  Future<void> _showErrorDialog(String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inventory Transfer'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
