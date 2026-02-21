import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../provider/auth_provider.dart';
import '../provider/ai_chat_provider.dart';
import '../provider/language_provider.dart';
import '../models/chat_message_model.dart';
import '../widgets/translated_text.dart';

class AICompanionChat extends StatefulWidget {
  @override
  _AICompanionChatState createState() => _AICompanionChatState();
}

class _AICompanionChatState extends State<AICompanionChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String _conversationId = Uuid().v4();
  final String _conversationType = 'general';

  late final AuthProvider _authProvider;
  String _hintText = 'Type your message';

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _translateHint();
  }

  Future<void> _translateHint() async {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final translatedHint = await langProvider.translate('Type your message');
    if (mounted) {
      setState(() {
        _hintText = translatedHint;
      });
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    if (_authProvider.currentUserId == null) return;

    Provider.of<AIChatProvider>(context, listen: false).sendMessage(
      userId: _authProvider.currentUserId!,
      message: _messageController.text.trim(),
      conversationId: _conversationId,
      conversationType: _conversationType,
    );

    _messageController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TranslatedText('AI Companion'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (provider) {
              Provider.of<AIChatProvider>(context, listen: false).setAIProvider(provider);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'gemini', child: Text('Gemini')),
              const PopupMenuItem(value: 'huggingface', child: Text('Hugging Face')),
              const PopupMenuItem(value: 'cohere', child: Text('Cohere')),
            ],
          ),
        ],
      ),
      body: Consumer<AIChatProvider>(
        builder: (context, chatProvider, child) {
          _scrollToBottom();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
              _buildInputArea(chatProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInputArea(AIChatProvider chatProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: _hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              enabled: !chatProvider.isLoading,
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: chatProvider.isLoading ? null : _sendMessage,
            child: chatProvider.isLoading
                ? const SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    // ADDED: Special styling for error messages
    final bool isError = message.isError;
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isError
              ? Colors.red[100]
              : message.isUser
                  ? Colors.blue
                  : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isError
                ? Colors.red[900]
                : message.isUser
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_authProvider.currentUserId != null) {
      Provider.of<AIChatProvider>(context, listen: false).endConversation(
        _authProvider.currentUserId!,
        _conversationId,
      );
    }

    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
