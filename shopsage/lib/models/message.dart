import 'product.dart';

class Message {
  final String text;
  final bool isUser;
  final List<Product> products;
  final DateTime time;

  Message({
    required this.text,
    required this.isUser,
    this.products = const [],
    DateTime? time,
  }) : time = time ?? DateTime.now();
}
