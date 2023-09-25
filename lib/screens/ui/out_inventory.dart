import 'dart:convert';

import 'package:dailystopstock/models/product.dart';
import 'package:dailystopstock/utils/app_constants.dart';
import 'package:dailystopstock/utils/custom_color.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class SalidaInventarioPage extends StatefulWidget {
  const SalidaInventarioPage({super.key});

  @override
  State<SalidaInventarioPage> createState() => _SalidaInventarioPageState();
}

class _SalidaInventarioPageState extends State<SalidaInventarioPage> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  String? _selectedConcept;
  String? _productName;
  int? _productId;

  final List<String> _conceptOptions = [
    'Sale',
    'Transfer',
    'Returns to suppliers',
    'Loss, theft, damage, obsolescence, etc.',
  ];

  Future<void> _submitExit() async {
    int quantity = int.parse(_quantityController.text);

    // Enviar la salida de inventario al backend
    final response = await http.post(
      Uri.parse('${AppConstants.urlBase}/api/inventory/output'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConstants.tokenDemo}',
      },
      body: jsonEncode(<String, dynamic>{
        'product': _productId ?? 0,
        'quantity': quantity,
        'concept': _selectedConcept!,
        'store': AppConstants.branchIdDemo
      }),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Inventory Output'),
            content: const Text('The exit was successfully registered.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _productController.clear();
                  _quantityController.clear();
                  setState(() {
                    _selectedConcept = null;
                    _productId = null;
                    _productName = "";
                  });
                },
              ),
            ],
          );
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error when recording the inventory output'),
            content: const Text('The inventory output could not be recorded.'),
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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
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
    final response = await http.get(
      Uri.parse("${AppConstants.urlBase}/api/product/upc/$barCode"),
      headers: <String, String>{
        'Authorization': 'Bearer ${AppConstants.tokenDemo}',
      },
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      Product? product = Product.fromJson(data);

      setState(() {
        _productId = product.id;
        _productName = product.name;
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Text('Inventory Out'),
            TextFormField(
              controller: _productController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                hintText: "Now Press Image and scan Product",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                labelText: 'Product',
                suffixIcon: IconButton(
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
            Text(
              _productName ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                hintText: "Now Press Image and scan Product",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                labelText: 'Quantity',
              ),
            ),
            const SizedBox(height: 50.0),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                hintText: "Now Press Image and scan Product",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
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
            const SizedBox(height: 40.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: tertiary,
                backgroundColor: tertiary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _submitExit,
              child: Text(
                'Record output',
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
}
