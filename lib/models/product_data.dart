import 'product.dart';

class ProductData {
  final int pageSize;
  final List<Product> results;

  ProductData({required this.pageSize, required this.results});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      pageSize: json['pageSize'],
      results: json['results']
          .map<Product>((item) => Product.fromJson(item))
          .toList(),
    );
  }
}
