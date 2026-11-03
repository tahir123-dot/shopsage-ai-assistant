import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../utils/snackbar.dart';

class ChatDrawer extends StatelessWidget {
  final VoidCallback onNewChat;
  const ChatDrawer({super.key, required this.onNewChat});

  Widget _item(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: kInk, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, color: kInk)),
      onTap: () => showSoon(context, title),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfile(),
            _buildNewChatButton(context),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 6),
              child: Text(
                'RECENT',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1,
                  color: kMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _item(
              context,
              Icons.chat_bubble_outline_rounded,
              'Best phones under \$500',
            ),
            _item(
              context,
              Icons.chat_bubble_outline_rounded,
              'Laptop for coding',
            ),
            _item(context, Icons.chat_bubble_outline_rounded, 'Gift ideas'),
            const Spacer(),
            const Divider(height: 1),
            _item(context, Icons.settings_outlined, 'Settings'),
            _item(context, Icons.help_outline_rounded, 'Help & feedback'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              gradient: kGradient,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              userName[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kInk,
                  ),
                ),
                Text(
                  'Free plan',
                  style: TextStyle(fontSize: 12, color: kMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewChatButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: kLavender,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.pop(context);
            onNewChat();
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.add_rounded, color: kAccentDark),
                SizedBox(width: 10),
                Text(
                  'New chat',
                  style: TextStyle(
                    color: kAccentDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
