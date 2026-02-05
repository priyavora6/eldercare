import 'package:flutter/material.dart';
import 'dart:math';

class AICompanionChat extends StatefulWidget {
  @override
  _AICompanionChatState createState() => _AICompanionChatState();
}

class _AICompanionChatState extends State<AICompanionChat> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isListening = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(ChatMessage(
      text: 'Hello! I\'m your AI companion. How can I help you today?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF4A90E2),
        title: Row(
          children: [
            Icon(Icons.smart_toy, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'AI Companion',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Quick Action Chips
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickActionChip(
                    icon: Icons.music_note,
                    label: 'Play Music',
                    onTap: () => _sendQuickMessage('Play some relaxing music for me'),
                  ),
                  SizedBox(width: 8),
                  _buildQuickActionChip(
                    icon: Icons.menu_book,
                    label: 'Tell Story',
                    onTap: () => _sendQuickMessage('Tell me an interesting story'),
                  ),
                  SizedBox(width: 8),
                  _buildQuickActionChip(
                    icon: Icons.newspaper,
                    label: 'Read News',
                    onTap: () => _sendQuickMessage('What\'s in the news today?'),
                  ),
                  SizedBox(width: 8),
                  _buildQuickActionChip(
                    icon: Icons.games,
                    label: 'Memory Game',
                    onTap: () => _sendQuickMessage('Let\'s play a memory game'),
                  ),
                ],
              ),
            ),
          ),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Input Area
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Voice Button
                Container(
                  width: 60,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isListening = !_isListening;
                      });
                      if (_isListening) {
                        _startVoiceRecording();
                      } else {
                        _stopVoiceRecording();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _isListening ? Color(0xFFE74C3C) : Color(0xFF4A90E2),
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(0),
                    ),
                    child: Icon(
                      _isListening ? Icons.stop : Icons.mic,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // Text Input
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(fontSize: 16, color: Color(0xFF2C3E50)),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Color(0xFFBDC3C7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        filled: true,
                        fillColor: Color(0xFFF5F7FA),
                      ),
                      onSubmitted: (text) {
                        if (text.isNotEmpty) {
                          _sendMessage(text);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // Send Button
                Container(
                  width: 60,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        _sendMessage(_messageController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF50C878),
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(0),
                    ),
                    child: Icon(
                      Icons.send,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xFF4A90E2).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFF4A90E2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Color(0xFF4A90E2)),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A90E2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints:
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          gradient: message.isUser
              ? LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF50C878)],
          )
              : null,
          color: message.isUser ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 16,
                color: message.isUser ? Colors.white : Color(0xFF2C3E50),
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 12,
                color: message.isUser
                    ? Colors.white.withOpacity(0.7)
                    : Color(0xFF7F8C8D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });
    _messageController.clear();

    // Scroll to bottom
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulate AI response
    Future.delayed(Duration(seconds: 1), () {
      _generateAIResponse(text);
    });
  }

  void _sendQuickMessage(String text) {
    _sendMessage(text);
  }

  void _generateAIResponse(String userMessage) {
    String response = _getContextualResponse(userMessage.toLowerCase());

    setState(() {
      _messages.add(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });

    // Scroll to bottom
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _getContextualResponse(String message) {
    if (message.contains('music') || message.contains('song')) {
      return '🎵 Playing relaxing classical music for you. Would you like me to play something specific?';
    } else if (message.contains('story')) {
      return '📖 Once upon a time, there was a wise elder who loved to share stories with the younger generation. Would you like to hear a specific type of story?';
    } else if (message.contains('news')) {
      return '📰 Here are today\'s top headlines:\n\n• Weather: Sunny, 72°F\n• Local Event: Community gathering at park\n• Health Tip: Remember to drink water!\n\nWould you like more details?';
    } else if (message.contains('game') || message.contains('play')) {
      return '🎮 Let\'s play a memory game! I\'ll say 3 words, try to remember them:\n\nApple, Tree, Blue\n\nCan you repeat them back?';
    } else if (message.contains('help')) {
      return 'I can help you with:\n• Playing music\n• Telling stories\n• Reading news\n• Playing memory games\n• Chatting anytime!\n\nWhat would you like?';
    } else if (message.contains('medicine') || message.contains('pill')) {
      return '💊 I can remind you about your medicines. Would you like to check your medicine schedule?';
    } else if (message.contains('family') || message.contains('call')) {
      return '📞 Would you like me to help you call a family member? I can connect you quickly!';
    } else {
      final responses = [
        'That\'s interesting! Tell me more.',
        'I understand. How can I help you with that?',
        'I\'m here to listen. What else would you like to talk about?',
        'That sounds nice! Anything else on your mind?',
      ];
      return responses[Random().nextInt(responses.length)];
    }
  }

  void _startVoiceRecording() {
    // Voice recording started
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.mic, color: Colors.white),
            SizedBox(width: 12),
            Text('Listening... Speak now'),
          ],
        ),
        backgroundColor: Color(0xFFE74C3C),
        duration: Duration(seconds: 10),
      ),
    );
  }

  void _stopVoiceRecording() {
    // Voice recording stopped
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    _sendMessage('This is a voice message (simulated)');
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}