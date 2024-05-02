class Product {
  final int id;
  final String name;
  final double price;
  final int? stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'] != null ? double.parse(json['price'].toString()) : 0,
      stock: json['stock'] != null ? int.parse(json['stock'].toString()) : 0,
    );
  }
}
