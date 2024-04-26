import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../service/inventory_service.dart';
import '../utils/app_constants.dart';

class TransferStockScreen extends StatefulWidget {
  const TransferStockScreen({super.key});

  @override
  State<TransferStockScreen> createState() => _TransferStockScreenState();
}

class _TransferStockScreenState extends State<TransferStockScreen> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String? _selectedFromWarehouse;
  String? _selectedToWarehouse;

  String? _productName;
  int? _productId;

  final List<String> _warehouseOptions = [
    'STORE ZHILIS RESTAURANT',
    'STORE PAWTUCKET',
    'STORE CHARLES',
    'STORE WHIPLE',
    'STORE BROADWAY',
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

  Future<void> _submitTransfer() async {
    int quantity = int.parse("0${_quantityController.text}");

    if (quantity > 0 && (_productId ?? 0) > 0) {
      http.Response response = await _inventoryService.authorizedPost(
        '${AppConstants.urlBase}/api/inventorytransfer/data',
        <String, dynamic>{
          'product': _productId ?? 0,
          'quantity': quantity,
          'fromWarehouse': _selectedFromWarehouse,
          'toWarehouse': _selectedToWarehouse,
          'store': AppConstants.branchIdDailyStop
        },
      );

      if (response.statusCode == 200) {
        _showErrorDialog('The transfer was successfully registered.');
      } else {
        _showErrorDialog('The inventory transfer could not be recorded.');
      }
    } else {
      _showErrorDialog("Error!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: <Widget>[
            const Text('TRANSFER STOCK'),
            const SizedBox(height: 8),
            Text(_productName ?? ""),
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
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
              ),
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField(
              decoration: const InputDecoration(),
              value: _selectedFromWarehouse,
              items: _warehouseOptions.map((String warehouse) {
                return DropdownMenuItem(
                  value: warehouse,
                  child: Text(warehouse),
                );
              }).toList(),
              hint: const Text('From Wharehouse'),
              onChanged: (String? value) {
                setState(() {
                  _selectedFromWarehouse = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField(
              decoration: const InputDecoration(),
              value: _selectedToWarehouse,
              items: _warehouseOptions.map((String warehouse) {
                return DropdownMenuItem(
                  value: warehouse,
                  child: Text(warehouse),
                );
              }).toList(),
              hint: const Text('Towards Warehouse'),
              onChanged: (String? value) {
                setState(() {
                  _selectedToWarehouse = value;
                });
              },
            ),
            const SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: _submitTransfer,
              child: const Text(
                'Register transfer',
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
