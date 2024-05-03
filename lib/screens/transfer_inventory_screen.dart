import 'dart:convert';
import 'package:barcodeinventory/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../models/product_data.dart';
import '../models/warehouse_model.dart';
import '../service/inventory_service.dart';
import '../utils/app_constants.dart';

class TransferStockScreen extends StatefulWidget {
  const TransferStockScreen({super.key});

  @override
  State<TransferStockScreen> createState() => _TransferStockScreenState();
}

class _TransferStockScreenState extends State<TransferStockScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _suggestions = [];

  final TextEditingController _productController = TextEditingController();
  WarehouseModel? _selectedFromWarehouse;
  WarehouseModel? _selectedToWarehouse;

  List<WarehouseModel> _warehouses = [];

  List<ProductData> countData = [];

  final InventoryService _inventoryService = InventoryService();

  _searchProduct(String barCode) async {
    http.Response response = await _inventoryService.authorizedGet(
      "${AppConstants.urlBase}/api/product/upc/${AppConstants.branchIdDailyStop}/$barCode",
    );

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      Product? product = Product.fromJson(data);

      setState(() {
        countData
            .add(ProductData(id: product.id, name: product.name, stock: 0));
      });
    } else {
      setState(() {});
    }
  }

  Future<String?> getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  Future<void> _submitTransfer() async {
    if (countData.isNotEmpty &&
        _selectedFromWarehouse != null &&
        _selectedToWarehouse != null) {
      http.Response response = await _inventoryService.authorizedPost(
        '${AppConstants.urlBase}/api/inventorytransfer',
        <String, dynamic>{
          'fromWarehouseId': _selectedFromWarehouse?.id,
          'ToWarehouseId': _selectedToWarehouse?.id,
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
        _showErrorDialog('The transfer was successfully registered.');

        countData.clear();
      } else {
        _showErrorDialog('The inventory transfer could not be recorded.');
      }
    } else {
      _showErrorDialog("Error!!");
    }
  }

  List<WarehouseModel> parseWarehouses(String responseBody) {
    final parsed =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

    return parsed
        .map<WarehouseModel>((json) => WarehouseModel.fromJson(json))
        .toList();
  }

  loadWarehouses() async {
    http.Response response = await _inventoryService.authorizedGet(
      "${AppConstants.urlBase}/api/warehouse/all/branch/${AppConstants.branchIdDailyStop}",
    );
    if (response.statusCode == 200) {
      var tempWarehouses = parseWarehouses(response.body);

      setState(() {
        _warehouses = tempWarehouses;
      });
    }
  }

  @override
  void initState() {
    loadWarehouses();

    super.initState();
  }

  void _openAutocompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Search Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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

  List<Product> parseProducts(String responseBody) {
    final parsed =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  void _fetchSuggestions(String query) async {
    if (query.isNotEmpty && query.length > 3) {
      final response = await _inventoryService.authorizedGet(
          '${AppConstants.urlBase}/api/product/autocomplete?name=$query');
      if (response.statusCode == 200) {
        var tempProducts = parseProducts(response.body);

        setState(() {
          _suggestions = tempProducts;
        });
      } else {
        throw Exception('Failed to load suggestions');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppbar(
          title: 'Transfer Inventory',
          scaffoldKey: scaffoldKey,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: ListView(
          children: <Widget>[
            DropdownButtonFormField(
              decoration: const InputDecoration(),
              value: _selectedFromWarehouse,
              items: _warehouses.map((WarehouseModel warehouse) {
                return DropdownMenuItem(
                  value: warehouse,
                  child: Text(warehouse.name),
                );
              }).toList(),
              hint: const Text('From Wharehouse'),
              onChanged: (WarehouseModel? value) {
                setState(() {
                  _selectedFromWarehouse = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField(
              decoration: const InputDecoration(),
              value: _selectedToWarehouse,
              items: _warehouses.map((WarehouseModel warehouse) {
                return DropdownMenuItem(
                  value: warehouse,
                  child: Text(warehouse.name),
                );
              }).toList(),
              hint: const Text('To Warehouse'),
              onChanged: (WarehouseModel? value) {
                setState(() {
                  _selectedToWarehouse = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _productController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.teal),
                      ),
                      hintText: "Now Press Image and scan Product",
                      hintStyle:
                          const TextStyle(fontSize: 16, color: Colors.grey),
                      labelText: 'Scan Product',
                      prefixIcon: IconButton(
                        color: Colors.teal,
                        onPressed: () async {
                          _productController.text = "";
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      suffixIcon: IconButton(
                        color: Colors.teal,
                        onPressed: () async {
                          _searchProduct(_productController.text);
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ),
                    onFieldSubmitted: (_) async {
                      _searchProduct(_productController.text);
                    },
                  ),
                ),
                IconButton(
                  color: Colors.teal,
                  onPressed: () {
                    _openAutocompleteDialog(context);
                  },
                  icon: const Icon(Icons.arrow_circle_up_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: countData.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Visibility(
                    // ignore: unnecessary_null_comparison
                    visible: countData[index] != null,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            Expanded(
                              child: Text(
                                countData[index].name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: 150.0,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Quantity',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 12.0,
                                  ),
                                ),
                                onChanged: (value) {
                                  countData[index].stock =
                                      int.tryParse(value) ?? 0;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: _submitTransfer,
              child: const Text(
                'Transfer Stock',
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
