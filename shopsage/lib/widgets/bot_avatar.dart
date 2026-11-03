import 'package:flutter/material.dart';
import '../core/theme.dart';

class BotAvatar extends StatelessWidget {
  const BotAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        gradient: kGradient,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.auto_awesome, size: 15, color: Colors.white),
    );
  }
}
