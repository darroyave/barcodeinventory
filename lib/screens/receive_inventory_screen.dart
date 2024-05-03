import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan2/barcode_scan2.dart';

import '../models/product.dart';
import '../service/inventory_service.dart';
import '../utils/app_constants.dart';
import '../widgets/custom_appbar.dart';

class ReceiveInventory extends StatefulWidget {
  const ReceiveInventory({super.key});

  @override
  State<ReceiveInventory> createState() => _ReceiveInventoryState();
}

class _ReceiveInventoryState extends State<ReceiveInventory> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final InventoryService _inventoryService = InventoryService();
  String? _selectedConcept;
  Product? _selectedProduct;
  final List<String> _conceptOptions = ['Receive'];

  Future<void> _scanAndSearchProduct() async {
    var result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode) {
      _searchProduct(result.rawContent);
      _productController.text = result.rawContent;
    }
  }

  Future<void> _searchProduct(String barCode) async {
    http.Response response = await _inventoryService.authorizedGet(
      "${AppConstants.urlBase}/api/product/upc/${AppConstants.branchIdDailyStop}/$barCode",
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      setState(() {
        _selectedProduct = Product.fromJson(data);
      });
    } else {
      setState(() {
        _selectedProduct = null;
      });
      _showErrorDialog('Product not found');
    }
  }

  Future<void> _submitEntry() async {
    if (_selectedProduct == null ||
        _selectedConcept == null ||
        _quantityController.text.isEmpty) {
      _showErrorDialog('Please fill all fields correctly');
      return;
    }
    int quantity = int.parse(_quantityController.text);

    http.Response response = await _inventoryService.authorizedPost(
      '${AppConstants.urlBase}/api/inventory/entry',
      <String, dynamic>{
        'product': _selectedProduct!.id,
        'quantity': quantity,
        'concept': _selectedConcept,
        'store': AppConstants.branchIdDailyStop
      },
    );

    if (response.statusCode == 200) {
      _showErrorDialog('The entry was successfully registered.');
    } else {
      _showErrorDialog('Failed to register the inventory entry.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppbar(
          title: 'Receive Inventory',
          scaffoldKey: scaffoldKey,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: _productController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Scan Product',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _scanAndSearchProduct,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedProduct != null) ...[
              Text(
                'Product: ${_selectedProduct!.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
            ],
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedConcept,
              items:
                  _conceptOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedConcept = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Concept',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitEntry,
              child: const Text('Register Inventory'),
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
          title: const Text('Notice'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
