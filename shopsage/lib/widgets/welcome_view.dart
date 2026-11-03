import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import 'orb.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(height: 24),
          Text(
            'Hello, $userName\nHow Can I Help You?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              height: 1.25,
              color: kInk,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Search, compare and shop smarter with AI.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.5, color: kMuted),
          ),
          SizedBox(height: 20),
          Orb(),
        ],
      ),
    );
  }
}
