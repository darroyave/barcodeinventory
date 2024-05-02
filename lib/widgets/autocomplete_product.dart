import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../service/inventory_service.dart';

class AutoCompleteProduct extends StatefulWidget {
  const AutoCompleteProduct({super.key});

  @override
  State<AutoCompleteProduct> createState() => _AutoCompleteProductState();
}

class _AutoCompleteProductState extends State<AutoCompleteProduct> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _suggestions = [];

  final InventoryService _inventoryService = InventoryService();

  List<Product> parseProducts(String responseBody) {
    final parsed =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  void _fetchSuggestions(String query) async {
    final response = await _inventoryService
        .authorizedGet('/api/product/autocomplete?name=$query');
    if (response.statusCode == 200) {
      var tempProducts = parseProducts(response.body);

      setState(() {
        _suggestions = tempProducts;
      });
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: _fetchSuggestions,
          decoration: const InputDecoration(
            labelText: 'Search',
            hintText: 'Type something...',
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_suggestions[index].name),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
