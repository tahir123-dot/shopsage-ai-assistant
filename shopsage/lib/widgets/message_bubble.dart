import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/message.dart';
import '../utils/text_utils.dart';
import 'bot_avatar.dart';
import 'product_card.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;
    final double maxBubble = MediaQuery.of(context).size.width * 0.72;

    final bubble = Container(
      constraints: BoxConstraints(maxWidth: maxBubble),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isUser ? kLavender : kSurface,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isUser ? 18 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              children: parseRichText(
                message.text,
                const TextStyle(fontSize: 14.5, height: 1.4, color: kInk),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatTime(message.time),
            style: const TextStyle(fontSize: 10, color: kMuted),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[const BotAvatar(), const SizedBox(width: 8)],
              bubble,
            ],
          ),
          if (message.products.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 285,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 38, right: 8, bottom: 14),
                itemCount: message.products.length,
                itemBuilder: (_, i) =>
                    ProductCard(product: message.products[i]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
