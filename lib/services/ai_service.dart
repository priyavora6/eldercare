import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class AIService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Securely load API keys from .env file
  final String _geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String _huggingFaceToken = dotenv.env['HUGGINGFACE_API_KEY'] ?? '';
  final String _cohereApiKey = dotenv.env['COHERE_API_KEY'] ?? '';

  String _currentProvider = 'gemini'; // Default provider

  AIService() {
    _validateApiKeys();
  }

  void _validateApiKeys() {
    if (_geminiApiKey.isEmpty) {
      debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      debugPrint('!!! GEMINI API KEY IS MISSING!');
      debugPrint('!!! 1. Make sure you have a .env file in the project root.');
      debugPrint('!!! 2. Make sure it contains: GEMINI_API_KEY=YOUR_KEY');
      debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    }
  }

  void setAIProvider(String provider) {
    if (['gemini', 'huggingface', 'cohere'].contains(provider)) {
      _currentProvider = provider;
    }
  }

  Future<String> sendMessage({
    required String userId,
    required String message,
    required String conversationId,
    String? conversationType,
  }) async {
    try {
      String aiResponse;

      switch (_currentProvider) {
        case 'gemini':
          aiResponse = await _sendToGemini(message);
          break;
        case 'huggingface':
          aiResponse = await _sendToHuggingFace(message);
          break;
        case 'cohere':
          aiResponse = await _sendToCohere(message);
          break;
        default:
          throw Exception('Invalid AI provider selected: $_currentProvider');
      }

      await _saveConversation(
        userId: userId,
        conversationId: conversationId,
        userMessage: message,
        aiResponse: aiResponse,
        conversationType: conversationType ?? 'general',
      );

      return aiResponse;
    } catch (e) {
      debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      debugPrint('!!! FAILED TO GET AI RESPONSE from $_currentProvider');
      debugPrint('!!! ERROR: $e');
      debugPrint('!!! This could be due to:');
      debugPrint('!!! 1. An invalid or revoked API key.');
      debugPrint('!!! 2. A missing internet connection on the device/emulator.');
      debugPrint('!!! 3. The API service being temporarily down.');
      debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      // Re-throw the exception to be caught by the provider
      throw Exception('Failed to get AI response.');
    }
  }

  Future<String> _sendToGemini(String message) async {
    if (_geminiApiKey.isEmpty) throw Exception('Gemini API Key is missing.');
    final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_geminiApiKey';
    final enrichedMessage =
        '''You are a caring AI companion for an elderly person. Be friendly, patient, and helpful. Keep responses simple, short, and clear. Respond in a warm, caring manner. User message: $message''';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {'parts': [{'text': enrichedMessage}]}
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'].trim();
    } else {
      throw Exception('Gemini API Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<String> _sendToHuggingFace(String message) async {
    if (_huggingFaceToken.isEmpty) throw Exception('HuggingFace API Key is missing.');
    final url = 'https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.2';
    final prompt = '''<s>[INST] You are a caring AI companion for an elderly person. Be friendly, patient, and helpful. User: $message [/INST] ''';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_huggingFaceToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'inputs': prompt,
        'parameters': {'return_full_text': false, 'max_new_tokens': 250}
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[0]['generated_text'].trim();
    } else {
      throw Exception('HuggingFace API Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<String> _sendToCohere(String message) async {
    if (_cohereApiKey.isEmpty) throw Exception('Cohere API Key is missing.');
    final url = 'https://api.cohere.ai/v1/chat';
    final preamble = 'You are a caring AI companion for an elderly person. Be friendly, patient, and helpful. Keep responses simple, short, and clear.';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $_cohereApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': message,
        'preamble': preamble,
        'model': 'command-light',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['text'].trim();
    } else {
      throw Exception('Cohere API Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> _saveConversation({
    required String userId,
    required String conversationId,
    required String userMessage,
    required String aiResponse,
    required String conversationType,
  }) async {
    try {
      final conversationRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('aiConversations')
          .doc(conversationId);

      final conversationSnapshot = await conversationRef.get();

      if (!conversationSnapshot.exists) {
        await conversationRef.set({
          'conversationId': conversationId,
          'conversationType': conversationType,
          'startedAt': FieldValue.serverTimestamp(),
          'endedAt': null,
        });
      }

      await conversationRef.collection('messages').add({
        'sender': 'user',
        'text': userMessage,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await conversationRef.collection('messages').add({
        'sender': 'ai',
        'text': aiResponse,
        'timestamp': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      debugPrint('Error saving conversation: $e');
    }
  }

  Future<void> endConversation(String userId, String conversationId) async {
    try {
      final conversationRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('aiConversations')
          .doc(conversationId);

      DocumentSnapshot conversationDoc = await conversationRef.get();

      if (conversationDoc.exists) {
        Map<String, dynamic> data = conversationDoc.data() as Map<String, dynamic>;
        Timestamp? startedAt = data['startedAt'];

        if (startedAt != null) {
          int duration = DateTime.now().difference(startedAt.toDate()).inSeconds;

          await conversationRef.update({
            'endedAt': FieldValue.serverTimestamp(),
            'duration': duration,
          });
        }
      }
    } catch (e) {
      debugPrint('Error ending conversation: $e');
    }
  }
}
