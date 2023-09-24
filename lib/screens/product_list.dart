import 'dart:convert';

import 'package:dailystopstock/models/product_data.dart';
import 'package:dailystopstock/utils/app_constants.dart';
import 'package:dailystopstock/utils/custom_color.g.dart';
import 'package:dailystopstock/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ProductListPage extends StatefulWidget {
  final int categoryId;
  const ProductListPage({
    required this.categoryId,
    super.key,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  ProductData _productData = ProductData(pageSize: 0, results: []);

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response = await http.get(
      Uri.parse(
          "${AppConstants.urlBase}/api/product/branch/${AppConstants.branchIdDemo}/${widget.categoryId}"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppbar(
          title: Text('Product List'),
        ),
      ),
      body: ListView.builder(
        itemCount: _productData.results.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.all(10),
            elevation: 1,
            child: ListTile(
              leading: const Icon(Icons.production_quantity_limits),
              title: Text(_productData.results[index].name),
            ),
          );
        },
      ),
    );
  }
}
