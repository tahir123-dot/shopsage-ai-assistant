class Product {
  final int id;
  final String title;
  final double price;
  final String category;
  final String thumbnail;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      category: (json['category'] ?? '').toString(),
      thumbnail: (json['thumbnail'] ?? '').toString(),
    );
  }
}
