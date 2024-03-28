import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../service/inventory_service.dart';
import '../utils/app_constants.dart';

class OutStockScreen extends StatefulWidget {
  const OutStockScreen({super.key});

  @override
  State<OutStockScreen> createState() => _OutStockScreenState();
}

class _OutStockScreenState extends State<OutStockScreen> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  String? _selectedConcept;
  String? _productName;
  int? _productId;

  final List<String> _conceptOptions = [
    'Sale',
    'Transfer',
    'Returns to suppliers',
    'Loss, theft, damage, etc.',
  ];

  final InventoryService _inventoryService = InventoryService();

  _searchProduct(String barCode) async {
    http.Response response = await _inventoryService.authorizedGet(
      "${AppConstants.urlBase}/api/product/upc/${AppConstants.branchIdDailyStop}/$barCode",
    );

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      Product? product = Product.fromJson(data);

      setState(() {
        _productName = product.name;
        _productId = product.id;
      });
    } else {
      setState(() {
        _productName = "Product does not exist";
      });
    }
  }

  Future<void> _submitExit() async {
    int quantity = int.parse("0${_quantityController.text}");

    if (quantity > 0 && (_productId ?? 0) > 0) {
      http.Response response = await _inventoryService.authorizedPost(
        '${AppConstants.urlBase}/api/inventory/output',
        <String, dynamic>{
          'product': _productId ?? 0,
          'quantity': quantity,
          'concept': _selectedConcept!,
          'store': AppConstants.branchIdDailyStop
        },
      );

      if (response.statusCode == 200) {
        _showErrorDialog('The out inventory was successfully registered.');
      } else {
        _showErrorDialog('The out inventory could not be recorded.');
      }
    } else {
      _showErrorDialog("Error!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text('OUT STOCK'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [
            Text(
              _productName ?? "",
            ),
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
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Now Press Image and scan Product",
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                labelText: 'Quantity',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                hintText: "Now Press Image and scan Product",
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              value: _selectedConcept,
              items: _conceptOptions.map((String concept) {
                return DropdownMenuItem(
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
            const SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: _submitExit,
              child: const Text(
                'Save output',
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
