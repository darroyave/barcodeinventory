import 'dart:convert';
import 'package:barcodeinventory/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan2/barcode_scan2.dart';

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
  String _message = ''; // Mensaje para el usuario

  Future<void> _scanAndSearchProduct() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode) {
        _productController.text = result.rawContent;
        await _searchProduct(result.rawContent);
      }
    } catch (e) {
      setState(() {
        _message = 'Error al escanear el código: ${e.toString()}';
      });
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
          products.add(product);
          _message = '';
        });
      } else {
        setState(() {
          _message = 'Error en la búsqueda: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error de conexión: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CustomAppbar(
          title: 'Check Price',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              onFieldSubmitted: (value) => _searchProduct(value),
              keyboardAppearance: Brightness.dark,
              keyboardType: TextInputType.number,
              controller: _productController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                hintText: "Scan Product",
                hintStyle: Theme.of(context).textTheme.labelLarge,
                labelText: 'Enter or Scan Product Code',
                prefixIcon: const Icon(Icons.remove),
                suffixIcon: IconButton(
                  color: Colors.teal,
                  onPressed: _scanAndSearchProduct,
                  icon: const Icon(Icons.camera_alt),
                ),
              ),
            ),
            if (_message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_message,
                    style: const TextStyle(color: Colors.red, fontSize: 16)),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.9, // Usa el 90% del ancho de la pantalla
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[index].name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${products[index].price.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              products[index].name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Acción al presionar el botón
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('More Info',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.favorite_border),
                                  onPressed: () {
                                    // Acción al presionar el ícono de favorito
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
