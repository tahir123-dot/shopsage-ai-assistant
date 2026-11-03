import 'package:flutter/material.dart';
import '../core/theme.dart';

class ChatTopBar extends StatelessWidget {
  final bool showTitle;
  final VoidCallback onBack;
  final VoidCallback onMenu;

  const ChatTopBar({
    super.key,
    required this.showTitle,
    required this.onBack,
    required this.onMenu,
  });

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: kSurface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 19, color: kInk),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            _circleButton(Icons.arrow_back_ios_new_rounded, onBack),
            Expanded(
              child: Center(
                child: AnimatedOpacity(
                  opacity: showTitle ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: const Text(
                    'Shopping Assistant',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kInk,
                    ),
                  ),
                ),
              ),
            ),
            _circleButton(Icons.menu_rounded, onMenu),
          ],
        ),
      ),
    );
  }
}
