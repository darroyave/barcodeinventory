import 'dart:convert';

import 'package:barcodeinventory/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../service/inventory_service.dart';

class InventoryEntryScreen extends StatefulWidget {
  const InventoryEntryScreen({super.key});

  @override
  State<InventoryEntryScreen> createState() => _InventoryEntryScreenState();
}

class _InventoryEntryScreenState extends State<InventoryEntryScreen> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final InventoryService _inventoryService = InventoryService();

  String? _selectedConcept;
  String? _productName;
  int? _productId;

  final List<String> _conceptOptions = [
    'Receive',
  ];

  Future<void> _submitEntry() async {
    int quantity = int.tryParse(_quantityController.text) ?? 0;

    String concept = _selectedConcept!;

    http.Response response = await _inventoryService.authorizedPost(
      '${AppConstants.urlBase}/api/inventory/entry',
      <String, dynamic>{
        'product': _productId ?? 0,
        'quantity': quantity,
        'concept': concept,
        'store': AppConstants.branchIdDailyStop
      },
    );

    if (response.statusCode == 200) {
      _showErrorDialog('The entry was successfully registered.');
    } else {
      _showErrorDialog('The inventory entry could not be recorded.');
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
      });
    } else {
      setState(() {
        _productId = 0;
        _productName = "Producto no existe";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
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
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                labelText: 'Quantity',
                hintText: "insert quantity Products",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
              ),
              value: _selectedConcept,
              items: _conceptOptions.map((String concept) {
                return DropdownMenuItem(
                  alignment: Alignment.topCenter,
                  value: concept,
                  child: Text(concept),
                );
              }).toList(),
              hint: const Text('Concept'),
              onChanged: (String? value) {
                setState(() {
                  _selectedConcept = value;
                });
              },
            ),
            const SizedBox(height: 25.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
              ),
              onPressed: _submitEntry,
              child: Text(
                'Register Inventory',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
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
