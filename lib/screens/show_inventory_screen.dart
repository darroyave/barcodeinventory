import 'dart:convert';
import 'package:barcodeinventory/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan2/barcode_scan2.dart';

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

  Future<void> _scanAndSearchProduct() async {
    var result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode) {
      _productController.text = result.rawContent;
      await _searchProduct(result.rawContent);
    }
  }

  Future<void> _searchProduct(String barCode) async {
    try {
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
        // Verifica el stock y muestra la alerta si es necesario
        if (_stock! < 1) {
          _showLowStockAlert();
        }
      } else {
        throw Exception('Failed to load product data');
      }
    } catch (e) {
      setState(() {
        _productName = "Product does not exist";
        _stock = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppbar(
          title: 'Show Inventory',
          scaffoldKey: scaffoldKey,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 20.0),
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
                  onPressed: () {
                    _productController.clear();
                    setState(() {
                      _productName = null;
                      _stock = 0;
                    });
                  },
                  icon: const Icon(Icons.cleaning_services),
                ),
                suffixIcon: IconButton(
                  color: Colors.teal,
                  onPressed: _scanAndSearchProduct,
                  icon: const Icon(Icons.camera_alt),
                ),
              ),
              onFieldSubmitted: (value) => _searchProduct(value),
            ),
            const SizedBox(height: 12.0),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                padding: const EdgeInsets.all(20), //

                decoration: BoxDecoration(
                  color: Colors.white, // Color de fondo del contenedor
                  border: Border.all(
                    color: Colors.green, // Color del borde
                    width: 1, // Grosor del borde
                  ),
                  borderRadius: BorderRadius.circular(
                      5), // Redondea las esquinas del borde
                ),
                child: Center(
                  child: Text(
                    _productName ??
                        "Enter a barcode to search", // Texto a mostrar
                    textAlign: TextAlign.center, // Alineación del texto
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo del contenedor
                border: Border.all(
                  color: Colors.orange, // Color del borde
                  width: 3, // Grosor del borde
                ),
                borderRadius:
                    BorderRadius.circular(5), // Redondea las esquinas del borde
              ),
              child: Center(
                child: Text(
                  "Stock: $_stock",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLowStockAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Low Stock Alert'),
          content: const Text('This product is currently out of stock.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo de alerta
              },
            ),
          ],
        );
      },
    );
  }
}
