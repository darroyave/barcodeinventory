import 'dart:convert';

import 'package:dailystopstock/models/category.dart';
import 'package:dailystopstock/models/product.dart';
import 'package:dailystopstock/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class CodigoBarrasPage extends StatefulWidget {
  const CodigoBarrasPage({super.key});

  @override
  State<CodigoBarrasPage> createState() => _CodigoBarrasPageState();
}

class _CodigoBarrasPageState extends State<CodigoBarrasPage> {
  List<Category> _categories = [];
  List<Product> _products = [];
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final response =
        await http.get(Uri.parse('${AppConstants.urlBase}/api/categories'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Category> categories =
          data.map((item) => Category.fromJson(item)).toList();
      setState(() {
        _categories = categories;
      });
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error when obtaining categories'),
            content:
                const Text('The list of categories could not be obtained.'),
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

  Future<void> _fetchProductsByCategory(int categoryId) async {
    final response = await http
        .get(Uri.parse('${AppConstants.urlBase}/$categoryId/products'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Product> products =
          data.map((item) => Product.fromJson(item)).toList();
      setState(() {
        _products = products;
      });
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error in obtaining products'),
            content: const Text('The list of products could not be obtained.'),
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

  void _generateBarcodes() {
    // Lógica para generar los códigos de barras
    if (_selectedCategory != null) {
      List<String> productNames =
          _products.map((Product product) => product.name).toList();
      // Generar los códigos de barras para los productos seleccionados
      List<String> barcodes = generateBarcodes(productNames);

      // Mostrar los códigos de barras generados
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Bar Codes Generated'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < barcodes.length; i++)
                  Text('${i + 1}. ${barcodes[i]}'),
              ],
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Generation'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DropdownButtonFormField<Category>(
            value: _selectedCategory,
            items: _categories.map((Category category) {
              return DropdownMenuItem<Category>(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
            hint: const Text('Select a category'),
            onChanged: (Category? value) {
              setState(() {
                _selectedCategory = value;
                _products = [];
                if (_selectedCategory != null) {
                  _fetchProductsByCategory(_selectedCategory!.id);
                }
              });
            },
          ),
          const SizedBox(height: 12.0),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Products',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_products[index].name),
                  leading: Checkbox(
                    value: false,
                    onChanged: (bool? value) {},
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Generar códigos de barras
                _generateBarcodes();
              },
              child: const Text('Generate Bar Codes'),
            ),
          ),
        ],
      ),
    );
  }

  List<String> generateBarcodes(List<String> productNames) {
    // Lógica para generar los códigos de barras (aquí se muestra un ejemplo)
    List<String> barcodes = [];
    for (String productName in productNames) {
      String barcode =
          '1234567890'; // Código de barras generado para el producto (aquí se puede aplicar la lógica real)
      barcodes.add(barcode);
    }
    return barcodes;
  }
}
