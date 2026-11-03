import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/message.dart';
import '../models/product.dart';

class ChatService {
  /// User ka message server ko bhejta hai aur bot ka Message wapas deta hai.
  /// Error aaye to bhi crash nahi karta, error wala Message deta hai.
  Future<Message> sendMessage(String text) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/chat'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'message': text}),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final products = (data['products'] as List? ?? [])
            .map((p) => Product.fromJson(p))
            .toList();

        return Message(
          text: (data['reply'] ?? '').toString(),
          isUser: false,
          products: products,
        );
      }

      return Message(
        text: 'Server error (${response.statusCode}). Dobara try karo.',
        isUser: false,
      );
    } catch (_) {
      return Message(
        text: 'Server se connect nahi ho paya. Internet ya server check karo.',
        isUser: false,
      );
    }
  }
}
