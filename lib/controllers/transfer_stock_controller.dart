import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/product_data.dart';
import '../models/warehouse_model.dart';
import '../service/inventory_service.dart';
import '../utils/app_constants.dart';

class TransferStockController extends ChangeNotifier {
  final searchController = TextEditingController();
  final productController = TextEditingController();

  WarehouseModel? selectedFromWarehouse;
  WarehouseModel? selectedToWarehouse;

  List<Product> suggestions = [];
  List<WarehouseModel> warehouses = [];
  List<ProductData> countData = [];

  final inventoryService = InventoryService();

  Future<void> searchProduct(String barCode) async {
    http.Response response = await inventoryService.authorizedGet(
      "${AppConstants.urlBase}/api/product/upc/${AppConstants.branchIdDailyStop}/$barCode",
    );

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      Product? product = Product.fromJson(data);

      countData.add(ProductData(
        id: product.id,
        name: product.name,
        stock: 0,
      ));
      notifyListeners();
    }
  }

  Future<String?> getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  Future<void> submitTransfer(context) async {
    if (countData.isNotEmpty &&
        selectedFromWarehouse != null &&
        selectedToWarehouse != null) {
      http.Response response = await inventoryService.authorizedPost(
        '${AppConstants.urlBase}/api/inventorytransfer',
        <String, dynamic>{
          'fromWarehouseId': selectedFromWarehouse?.id,
          'ToWarehouseId': selectedToWarehouse?.id,
          'BranchId': AppConstants.branchIdDailyStop,
          'PhoneNumber': await getPhone(),
          'Items': countData
              .map((prod) => {
                    'ProductId': prod.id,
                    'Cost': 0.0,
                    'Quantity': prod.stock,
                  })
              .toList()
        },
      );

      if (response.statusCode == 200) {
        showErrorDialog(context, 'The transfer was successfully registered.');

        countData.clear();
        notifyListeners();
      } else {
        showErrorDialog(
            context, 'The inventory transfer could not be recorded.');
      }
    } else {
      showErrorDialog(context, "Error!!");
    }
  }

  List<WarehouseModel> parseWarehouses(String responseBody) {
    final parsed =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

    return parsed
        .map<WarehouseModel>((json) => WarehouseModel.fromJson(json))
        .toList();
  }

  Future<void> loadWarehouses() async {
    http.Response response = await inventoryService.authorizedGet(
      "${AppConstants.urlBase}/api/warehouse/all/branch/${AppConstants.branchIdDailyStop}",
    );
    if (response.statusCode == 200) {
      warehouses = parseWarehouses(response.body);
      notifyListeners();
    }
  }

  List<Product> parseProducts(String responseBody) {
    final parsed =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  Future<void> fetchSuggestions(String query) async {
    if (query.isNotEmpty && query.length > 3) {
      final response = await inventoryService.authorizedGet(
          '${AppConstants.urlBase}/api/product/autocomplete?name=$query');
      if (response.statusCode == 200) {
        suggestions = parseProducts(response.body);
        notifyListeners();
      } else {
        throw Exception('Failed to load suggestions');
      }
    }
  }

  Future<void> showErrorDialog(context, String message) async {
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

  void openAutocompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Search Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                onChanged: fetchSuggestions,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  hintText: 'Type something...',
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(suggestions[index].name),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
