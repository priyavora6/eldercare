import 'package:eldercare/l10n/app_localizations.dart' show AppLocalizations;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../provider/auth_provider.dart';
import '../provider/ai_chat_provider.dart';
import '../provider/language_provider.dart';
import '../models/chat_message_model.dart';
import 'package:eldercare/l10n/app_localizations.dart';

class AICompanionChat extends StatefulWidget {
  @override
  _AICompanionChatState createState() => _AICompanionChatState();
}

class _AICompanionChatState extends State<AICompanionChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _conversationId = Uuid().v4();
  String _conversationType = 'general';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final chatProvider = Provider.of<AIChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aiCompanion),
        actions: [
          PopupMenuButton<String>(
            onSelected: (provider) {
              chatProvider.setAIProvider(provider);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'gemini', child: Text('Gemini')),
              PopupMenuItem(value: 'huggingface', child: Text('Hugging Face')),
              PopupMenuItem(value: 'cohere', child: Text('Cohere')),
            ],
          ),
        ],
      ),
      body: Column(
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
          _buildInputArea(context, authProvider, chatProvider, l10n),
        ],
      ),
    );
  }

  Widget _buildInputArea(
      BuildContext context,
      AuthProvider authProvider,
      AIChatProvider chatProvider,
      AppLocalizations l10n,
      ) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: l10n.typeYourMessage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              enabled: !chatProvider.isLoading,
            ),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: chatProvider.isLoading
                ? null
                : () => _sendMessage(authProvider, chatProvider),
            child: chatProvider.isLoading
                ? CircularProgressIndicator()
                : Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _sendMessage(AuthProvider authProvider, AIChatProvider chatProvider) {
    if (_messageController.text.isEmpty) return;
    if (authProvider.currentUserId == null) return;

    chatProvider.sendMessage(
      userId: authProvider.currentUserId!,
      message: _messageController.text,
      conversationId: _conversationId,
      conversationType: _conversationType,
    );

    _messageController.clear();
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final chatProvider = Provider.of<AIChatProvider>(context, listen: false);

    if (authProvider.currentUserId != null) {
      chatProvider.endConversation(
        authProvider.currentUserId!,
        _conversationId,
      );
    }

    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
