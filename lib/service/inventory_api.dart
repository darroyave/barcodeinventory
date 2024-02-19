import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../utils/app_constants.dart';

class InventoryApi {
  final http.Client _client;

  InventoryApi(this._client);

  Future<Product> getProduct(String barCode) async {
    final uri = Uri.parse(
        '${AppConstants.urlBase}/api/product/upc/${AppConstants.branchIdDailyStop}/$barCode');

    try {
      final http.Response response = await _client.get(uri);
      final String utfResponseBody = utf8.decode(response.bodyBytes);
      final dynamic responseBody = jsonDecode(utfResponseBody);

      if (response.statusCode == 200) {
        return _parseResponseForProduct(responseBody);
      } else {
        _handleError(responseBody, response.statusCode);
      }
    } catch (e) {
      throw Exception('Unable to Fetch Product $e');
    }
    throw Exception('Unable to Fetch Product');
  }

  Product _parseResponseForProduct(dynamic responseBody) {
    return Product.fromJson(responseBody);
  }

  void _handleError(dynamic responseBody, int statusCode) {
    if (statusCode >= 400 && statusCode < 500) {
      throw http.ClientException(
          '${responseBody['reason']} : ${responseBody['status']}');
    } else if (statusCode >= 500 && statusCode < 600) {
      throw Exception('Server error occurred: $statusCode');
    } else {
      throw Exception('Failed to fetch product: $statusCode');
    }
  }
}
