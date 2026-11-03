import 'package:flutter/material.dart';

/// Jo features abhi sirf UI hain unke liye chhota sa message
void showSoon(BuildContext context, String what) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('$what abhi sirf UI hai'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
}
