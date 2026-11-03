import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/chat_service.dart';
import '../widgets/chat_drawer.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_top_bar.dart';
import '../widgets/message_bubble.dart';
import '../widgets/suggestion_list.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/welcome_view.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();

  final List<Message> _messages = [];
  bool _isLoading = false;

  static const List<String> _suggestions = [
    'Mujhe koi achha phone dikhao',
    'Laptops dikhao',
    'Kaun si categories hain?',
    'Sasti shoes dikhao',
  ];

  Future<void> _send(String raw) async {
    final String text = raw.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _isLoading = true;
    });
    _messageController.clear();
    _scrollToBottom();

    final reply = await _chatService.sendMessage(text);

    if (!mounted) return;
    setState(() {
      _messages.add(reply);
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _newChat() => setState(() => _messages.clear());

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = _messages.isEmpty && !_isLoading;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawer: ChatDrawer(onNewChat: _newChat),
      body: Column(
        children: [
          ChatTopBar(
            showTitle: _messages.isNotEmpty,
            onBack: () => Navigator.maybePop(context),
            onMenu: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          Expanded(
            child: isEmpty
                ? const WelcomeView()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return const TypingIndicator();
                      }
                      return MessageBubble(message: _messages[index]);
                    },
                  ),
          ),
          if (isEmpty) SuggestionList(suggestions: _suggestions, onTap: _send),
          ChatInputBar(
            controller: _messageController,
            isLoading: _isLoading,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}
