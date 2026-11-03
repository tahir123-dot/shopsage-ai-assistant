import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../utils/snackbar.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final bool isLoading;
  final ValueChanged<String> onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  String _model = 'Assistant';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 10, 10, 10),
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: widget.controller,
                minLines: 1,
                maxLines: 4,
                style: const TextStyle(fontSize: 15, color: kInk),
                decoration: const InputDecoration(
                  hintText: 'How can I help you today?',
                  hintStyle: TextStyle(fontSize: 14.5, color: kMuted),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPlusButton(),
                  const Spacer(),
                  _buildModelDropdown(),
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: () => showSoon(context, 'Mic'),
                    icon: const Icon(
                      Icons.mic_none_rounded,
                      size: 22,
                      color: kInk,
                    ),
                  ),
                  _buildSendButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlusButton() {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0.5,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => showSoon(context, 'Attach'),
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(Icons.add_rounded, size: 22, color: kInk),
        ),
      ),
    );
  }

  Widget _buildModelDropdown() {
    return PopupMenuButton<String>(
      onSelected: (v) => setState(() => _model = v),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (_) => [
        'Assistant',
        'Fast',
        'Smart',
      ].map((m) => PopupMenuItem(value: m, child: Text(m))).toList(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _model,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: kInk,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: kMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final bool hasText = widget.controller.text.trim().isNotEmpty;
        return GestureDetector(
          onTap: () {
            if (hasText) {
              widget.onSend(widget.controller.text);
            } else {
              showSoon(context, 'Voice mode');
            }
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: widget.isLoading ? null : kGradient,
              color: widget.isLoading ? const Color(0xFFD1D5DB) : null,
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasText ? Icons.arrow_upward_rounded : Icons.graphic_eq_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),
        );
      },
    );
  }
}
