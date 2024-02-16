import 'dart:convert';

import 'package:barcodeinventory/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool isEBTChecked = false;
  bool isTaxChecked = false;

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
      }
    });
  }

  Future<void> _submitEntry() async {
    double price = double.parse("0${_priceController.text}");
    double cost = double.parse("0${_costController.text}");
    String name = _nameController.text;
    String barcodeResult = _productController.text;

    if (barcodeResult.isNotEmpty && price > 0) {
      final response = await http.post(
        Uri.parse('${AppConstants.urlBase}/api/temp/update'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'price': price,
          'upc': barcodeResult,
          'tax': isTaxChecked ? 7.0 : 0.0,
          'ebt': isEBTChecked,
          'cost': cost,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isTaxChecked = false;
          isEBTChecked = false;
          _productController.text = "";
          _priceController.text = "";
          _costController.text = "";
          _nameController.text = "";
        });

        var responseData = json.decode(response.body);
        String price = responseData['Price'].toString();

        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Alert'),
              content: Text(price),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
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
                suffixIcon: IconButton(
                  color: Colors.teal,
                  onPressed: () async {
                    await scanBarcodeNormal();
                  },
                  icon: const Icon(Icons.barcode_reader),
                ),
              ),
              onFieldSubmitted: (_) async {},
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                labelText: 'Price',
                hintText: "Price",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                labelText: 'Cost',
                hintText: "Cost",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                labelText: 'Name',
                hintText: "Name",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12.0),
            ListTile(
              title: const Text('EBT'),
              leading: Checkbox(
                value: isEBTChecked,
                onChanged: (value) {
                  setState(() {
                    isEBTChecked = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 12.0),
            ListTile(
              title: const Text('Tax'),
              leading: Checkbox(
                value: isTaxChecked,
                onChanged: (value) {
                  setState(() {
                    isTaxChecked = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 25.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
              ),
              onPressed: _submitEntry,
              child: Text(
                'Save',
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
