import 'package:flutter/material.dart';
import '../../services/ai_service.dart';
import '../models/chat_message_model.dart';

class AIChatProvider extends ChangeNotifier {
  final AIService _aiService = AIService();

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _currentProvider = 'gemini';

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String get currentProvider => _currentProvider;

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  Future<void> sendMessage({
    required String userId,
    required String message,
    required String conversationId,
    String? conversationType,
  }) async {
    // Add user message
    addMessage(ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    _isLoading = true;
    notifyListeners();

    try {
      String aiResponse = await _aiService.sendMessage(
        userId: userId,
        message: message,
        conversationId: conversationId,
        conversationType: conversationType,
      );

      // Add AI response
      addMessage(ChatMessage(
        text: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      // ADDED: Add an error message to the chat
      addMessage(ChatMessage(
        text: "I'm having trouble connecting right now. Please check your API keys and internet connection.",
        isUser: false,
        timestamp: DateTime.now(),
        isError: true, // Mark this as an error message
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setAIProvider(String provider) {
    _currentProvider = provider;
    _aiService.setAIProvider(provider);
    notifyListeners();
  }

  Future<void> endConversation(String userId, String conversationId) async {
    await _aiService.endConversation(userId, conversationId);
  }
}
