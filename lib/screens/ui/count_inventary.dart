import 'dart:convert';

import 'package:dailystopstock/models/category.dart';
import 'package:dailystopstock/models/product.dart';
import 'package:dailystopstock/models/product_data.dart';
import 'package:dailystopstock/utils/app_constants.dart';
import 'package:dailystopstock/utils/custom_color.g.dart';
import 'package:dailystopstock/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConteoInventarioPage extends StatefulWidget {
  const ConteoInventarioPage({super.key});

  @override
  State<ConteoInventarioPage> createState() => _ConteoInventarioPageState();
}

class _ConteoInventarioPageState extends State<ConteoInventarioPage> {
  List<Category> _categories = [];
  ProductData _productData = ProductData(pageSize: 0, results: []);
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(
      Uri.parse(
          '${AppConstants.urlBase}${AppConstants.category}/${AppConstants.branchIdDemo}'),
      headers: <String, String>{
        'Authorization': 'Bearer ${AppConstants.tokenDemo}',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Category> categories =
          data.map((item) => Category.fromJson(item)).toList();
      setState(() {
        _categories = categories;
      });
    }
  }

  Future<void> _fetchProductsByCategory(int categoryId) async {
    final response = await http.get(
      Uri.parse(
          '${AppConstants.urlBase}/api/product/branch/${AppConstants.branchIdDemo}/$categoryId'),
      headers: <String, String>{
        'Authorization': 'Bearer ${AppConstants.tokenDemo}',
      },
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      ProductData productData = ProductData.fromJson(data);
      setState(() {
        _productData = productData;
      });
    }
  }

  Future<void> _submitCount() async {
    List<Map<String, dynamic>> countData =
        _productData.results.map((Product product) {
      return {
        'productId': product.id,
        'quantity': 1,
      };
    }).toList();

    final response = await http.post(
      Uri.parse('${AppConstants.urlBase}/api/inventorycount/data'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConstants.tokenDemo}',
      },
      body: jsonEncode(<String, dynamic>{
        'products': countData,
        'store': AppConstants.branchIdDemo
      }),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Inventory count'),
            content: const Text('The count was successfully sent.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
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
            title: const Text('Error sending inventory count'),
            content: const Text('The inventory count could not be sent.'),
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
      backgroundColor: neutral,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppbar(
          title: Text('Inventory Count'),
        ),
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
                _selectedCategory = value!;
                _productData = ProductData(pageSize: 0, results: []);
                _fetchProductsByCategory(_selectedCategory!.id);
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
              itemCount: _productData.results.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(_productData.results[index].name),
                    trailing: SizedBox(
                      width: 100.0,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Quantity'),
                        onChanged: (value) {},
                      ),
                    ),
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
                // Enviar los datos de conteo de inventario al backend
                _submitCount();
              },
              child: const Text('Send count'),
            ),
          ),
        ],
      ),
    );
  }
}
