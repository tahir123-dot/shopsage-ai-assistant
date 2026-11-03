import 'package:flutter/material.dart';
import 'package:shopsage/screen/chat_screen.dart';
import 'core/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping Assistant',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: kAccent,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ChatScreen(),
    );
  }
}
