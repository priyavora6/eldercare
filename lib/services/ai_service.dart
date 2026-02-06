import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class AIService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================
  // FREE API KEYS - Get them for FREE!
  // ============================================

  // GEMINI - FREE (Recommended)
  // Get your free key: https://makersuite.google.com/app/apikey
  static const String GEMINI_API_KEY = 'YOUR_FREE_GEMINI_KEY';

  // HUGGING FACE - FREE
  // Get your free key: https://huggingface.co/settings/tokens
  static const String HUGGING_FACE_API_KEY = 'YOUR_FREE_HUGGING_FACE_KEY';

  // COHERE - FREE
  // Get your free key: https://dashboard.cohere.com/api-keys
  static const String COHERE_API_KEY = 'YOUR_FREE_COHERE_KEY';

  String _currentProvider = 'gemini'; // Options: 'gemini', 'huggingface', 'cohere'

  // Get user's preferred language
  Future<String> _getUserLanguage(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['preferences']?['aiChatLanguage'] ?? 'en';
      }
      return 'en';
    } catch (e) {
      print('Error getting user language: $e');
      return 'en';
    }
  }

  // Get language name
  String _getLanguageName(String langCode) {
    switch (langCode) {
      case 'hi':
        return 'Hindi';
      case 'gu':
        return 'Gujarati';
      default:
        return 'English';
    }
  }

  // Main method to send message to AI
  Future<String> sendMessage({
    required String userId,
    required String message,
    required String conversationId,
    String? conversationType,
  }) async {
    try {
      String userLanguage = await _getUserLanguage(userId);

      List<Map<String, String>> conversationHistory =
      await _getConversationHistory(userId, conversationId);

      String aiResponse;

      switch (_currentProvider) {
        case 'gemini':
          aiResponse = await _sendToGemini(
            message: message,
            language: userLanguage,
            conversationHistory: conversationHistory,
            conversationType: conversationType,
          );
          break;
        case 'huggingface':
          aiResponse = await _sendToHuggingFace(
            message: message,
            language: userLanguage,
            conversationHistory: conversationHistory,
            conversationType: conversationType,
          );
          break;
        case 'cohere':
          aiResponse = await _sendToCohere(
            message: message,
            language: userLanguage,
            conversationHistory: conversationHistory,
            conversationType: conversationType,
          );
          break;
        default:
          aiResponse = await _sendToGemini(
            message: message,
            language: userLanguage,
            conversationHistory: conversationHistory,
            conversationType: conversationType,
          );
      }

      await _saveConversation(
        userId: userId,
        conversationId: conversationId,
        userMessage: message,
        aiResponse: aiResponse,
        language: userLanguage,
        conversationType: conversationType ?? 'general',
      );

      await _logActivity(
        userId: userId,
        activityType: 'aiChat',
        activityDescription: 'AI Companion conversation',
        metadata: {
          'conversationId': conversationId,
          'conversationType': conversationType ?? 'general',
          'aiProvider': _currentProvider,
        },
      );

      return aiResponse;
    } catch (e) {
      print('Error in sendMessage: $e');
      throw Exception('Failed to get AI response: $e');
    }
  }

  // ============================================
  // OPTION 1: GOOGLE GEMINI (FREE - BEST CHOICE)
  // ============================================
  Future<String> _sendToGemini({
    required String message,
    required String language,
    required List<Map<String, String>> conversationHistory,
    String? conversationType,
  }) async {
    try {
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$GEMINI_API_KEY'
      );

      String systemInstruction = _buildSystemPrompt(
        language: language,
        conversationType: conversationType,
      );

      List<Map<String, dynamic>> contents = [];

      // Add conversation history (last 5 messages for free tier)
      int startIndex = conversationHistory.length > 5 ? conversationHistory.length - 5 : 0;
      for (int i = startIndex; i < conversationHistory.length; i++) {
        var msg = conversationHistory[i];
        contents.add({
          "role": msg['sender'] == 'user' ? "user" : "model",
          "parts": [{"text": msg['message'] ?? ''}]
        });
      }

      // Add current message with system instruction
      contents.add({
        "role": "user",
        "parts": [{"text": "$systemInstruction\n\nUser: $message"}]
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": contents,
          "generationConfig": {
            "temperature": 0.7,
            "maxOutputTokens": 800,
            "topP": 0.8,
            "topK": 10
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          String aiText = data['candidates'][0]['content']['parts'][0]['text'];
          return aiText.trim();
        }
      }

      throw Exception('Gemini API error: ${response.statusCode}');
    } catch (e) {
      print('Gemini API error: $e');
      throw Exception('Gemini error: $e');
    }
  }

  // ============================================
  // OPTION 2: HUGGING FACE (FREE)
  // ============================================
  Future<String> _sendToHuggingFace({
    required String message,
    required String language,
    required List<Map<String, String>> conversationHistory,
    String? conversationType,
  }) async {
    try {
      // Using free Mistral-7B model
      final url = Uri.parse(
          'https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.2'
      );

      String systemPrompt = _buildSystemPrompt(
        language: language,
        conversationType: conversationType,
      );

      // Build conversation context
      String fullPrompt = "$systemPrompt\n\n";

      // Add last 3 messages for context
      int startIndex = conversationHistory.length > 3 ? conversationHistory.length - 3 : 0;
      for (int i = startIndex; i < conversationHistory.length; i++) {
        var msg = conversationHistory[i];
        fullPrompt += "${msg['sender'] == 'user' ? 'User' : 'Assistant'}: ${msg['message'] ?? ''}\n";
      }

      fullPrompt += "User: $message\nAssistant:";

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $HUGGING_FACE_API_KEY',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "inputs": fullPrompt,
          "parameters": {
            "max_new_tokens": 500,
            "temperature": 0.7,
            "top_p": 0.9,
            "return_full_text": false
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          String generatedText = data[0]['generated_text'];
          return generatedText.trim();
        } else if (data is Map && data.containsKey('generated_text')) {
          return data['generated_text'].trim();
        }
      }

      throw Exception('HuggingFace API error: ${response.statusCode}');
    } catch (e) {
      print('HuggingFace API error: $e');
      throw Exception('HuggingFace error: $e');
    }
  }

  // ============================================
  // OPTION 3: COHERE (FREE)
  // ============================================
  Future<String> _sendToCohere({
    required String message,
    required String language,
    required List<Map<String, String>> conversationHistory,
    String? conversationType,
  }) async {
    try {
      final url = Uri.parse('https://api.cohere.ai/v1/chat');

      String systemPrompt = _buildSystemPrompt(
        language: language,
        conversationType: conversationType,
      );

      // Build chat history
      List<Map<String, String>> chatHistory = [];
      for (var msg in conversationHistory) {
        chatHistory.add({
          "role": msg['sender'] == 'user' ? "USER" : "CHATBOT",
          "message": msg['message'] ?? ''
        });
      }

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $COHERE_API_KEY',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "message": message,
          "chat_history": chatHistory,
          "preamble": systemPrompt,
          "model": "command",
          "temperature": 0.7,
          "max_tokens": 800,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String aiText = data['text'];
        return aiText.trim();
      }

      throw Exception('Cohere API error: ${response.statusCode}');
    } catch (e) {
      print('Cohere API error: $e');
      throw Exception('Cohere error: $e');
    }
  }

  // ============================================
  // OPTION 4: LOCAL FALLBACK (100% FREE - NO API)
  // ============================================
  String _getLocalResponse({
    required String message,
    required String language,
    String? conversationType,
  }) {
    // Simple rule-based responses for when API is unavailable
    message = message.toLowerCase();

    // English responses
    Map<String, List<String>> englishResponses = {
      'music': [
        'I can suggest some wonderful classical music. Would you like to hear some peaceful melodies?',
        'How about some soothing instrumental music? It\'s perfect for relaxation.',
      ],
      'story': [
        'Let me tell you a beautiful story about kindness and friendship...',
        'Here\'s an inspiring tale that I think you\'ll enjoy...',
      ],
      'news': [
        'Today\'s news includes many positive developments around the world.',
        'I can share some uplifting news stories with you.',
      ],
      'game': [
        'Let\'s play a fun memory game! I\'ll say three words, and you repeat them back to me.',
        'How about a simple word association game? It\'s fun and good for the mind!',
      ],
      'medicine': [
        'It\'s important to take your medicines on time. Have you taken your medicine today?',
        'Remember to follow your medicine schedule. Your health is important!',
      ],
      'health': [
        'How are you feeling today? I hope you\'re doing well!',
        'Taking care of your health is wonderful. Keep up the good work!',
      ],
      'default': [
        'I\'m here to chat with you! How can I help you today?',
        'That\'s interesting! Tell me more.',
        'I understand. How does that make you feel?',
        'Thank you for sharing that with me!',
      ],
    };

    // Hindi responses
    Map<String, List<String>> hindiResponses = {
      'music': [
        'मैं आपको कुछ अद्भुत शास्त्रीय संगीत सुझा सकता हूं। क्या आप शांत धुनें सुनना चाहेंगे?',
        'आरामदायक वाद्य संगीत कैसा रहेगा? यह विश्राम के लिए एकदम सही है।',
      ],
      'story': [
        'मैं आपको दयालुता और मित्रता के बारे में एक सुंदर कहानी सुनाता हूं...',
        'यहां एक प्रेरणादायक कहानी है जो आपको पसंद आएगी...',
      ],
      'news': [
        'आज की खबरों में दुनिया भर में कई सकारात्मक विकास शामिल हैं।',
        'मैं आपके साथ कुछ उत्साहवर्धक समाचार साझा कर सकता हूं।',
      ],
      'game': [
        'चलिए एक मजेदार याददाश्त का खेल खेलते हैं! मैं तीन शब्द कहूंगा, और आप मुझे दोहराएं।',
        'एक सरल शब्द संबंध खेल कैसा रहेगा? यह मजेदार और दिमाग के लिए अच्छा है!',
      ],
      'medicine': [
        'समय पर अपनी दवाएं लेना महत्वपूर्ण है। क्या आपने आज अपनी दवा ली है?',
        'अपनी दवा के शेड्यूल का पालन करना याद रखें। आपका स्वास्थ्य महत्वपूर्ण है!',
      ],
      'default': [
        'मैं आपसे बात करने के लिए यहां हूं! आज मैं आपकी कैसे मदद कर सकता हूं?',
        'यह दिलचस्प है! मुझे और बताएं।',
        'मैं समझता हूं। इससे आपको कैसा लगता है?',
        'इसे मेरे साथ साझा करने के लिए धन्यवाद!',
      ],
    };

    // Gujarati responses
    Map<String, List<String>> gujaratiResponses = {
      'music': [
        'હું તમને કેટલાક અદ્ભુત શાસ્ત્રીય સંગીત સૂચવી શકું છું. શું તમે શાંત ધૂન સાંભળવા માંગો છો?',
        'આરામદાયક વાદ્ય સંગીત કેવું રહેશે? તે આરામ માટે એકદમ યોગ્ય છે.',
      ],
      'story': [
        'હું તમને દયા અને મિત્રતા વિશે એક સુંદર વાર્તા કહું છું...',
        'અહીં એક પ્રેરણાદાયક વાર્તા છે જે તમને ગમશે...',
      ],
      'news': [
        'આજના સમાચારમાં વિશ્વભરમાં ઘણા સકારાત્મક વિકાસનો સમાવેશ થાય છે।',
        'હું તમારી સાથે કેટલીક ઉત્સાહવર્ધક સમાચાર વાર્તાઓ શેર કરી શકું છું.',
      ],
      'default': [
        'હું તમારી સાથે વાત કરવા માટે અહીં છું! આજે હું તમારી કેવી રીતે મદદ કરી શકું?',
        'તે રસપ્રદ છે! મને વધુ કહો.',
        'હું સમજું છું. તે તમને કેવું લાગે છે?',
        'તે મારી સાથે શેર કરવા બદલ આભાર!',
      ],
    };

    Map<String, List<String>> responses = language == 'hi'
        ? hindiResponses
        : language == 'gu'
        ? gujaratiResponses
        : englishResponses;

    // Detect conversation type from message
    String responseType = 'default';
    if (message.contains('music') || message.contains('song') || message.contains('संगीत') || message.contains('સંગીત')) {
      responseType = 'music';
    } else if (message.contains('story') || message.contains('कहानी') || message.contains('વાર્તા')) {
      responseType = 'story';
    } else if (message.contains('news') || message.contains('खबर') || message.contains('સમાચાર')) {
      responseType = 'news';
    } else if (message.contains('game') || message.contains('खेल') || message.contains('રમત')) {
      responseType = 'game';
    } else if (message.contains('medicine') || message.contains('दवा') || message.contains('દવા')) {
      responseType = 'medicine';
    } else if (message.contains('health') || message.contains('स्वास्थ्य') || message.contains('આરોગ્ય')) {
      responseType = 'health';
    } else if (conversationType != null && responses.containsKey(conversationType)) {
      responseType = conversationType;
    }

    List<String> possibleResponses = responses[responseType] ?? responses['default']!;
    return possibleResponses[DateTime.now().millisecond % possibleResponses.length];
  }

  // Build system prompt
  String _buildSystemPrompt({
    required String language,
    String? conversationType,
  }) {
    String languageName = _getLanguageName(language);

    String basePrompt = '''
You are a friendly AI companion for elderly users. Your role is to provide companionship, entertainment, and helpful information.

CRITICAL INSTRUCTIONS:
1. ALWAYS respond in $languageName language ONLY
2. Use simple, clear, and warm language
3. Be patient, kind, and respectful
4. Keep responses SHORT (2-3 sentences maximum)
5. Use a conversational, friendly tone
6. Show empathy and care
7. Avoid complex terms or jargon
''';

    switch (conversationType) {
      case 'music':
        basePrompt += '\n\nMUSIC MODE: Suggest relaxing music, describe it soothingly, share interesting facts.';
        break;
      case 'story':
        basePrompt += '\n\nSTORY MODE: Tell SHORT uplifting stories with simple descriptions and positive messages.';
        break;
      case 'news':
        basePrompt += '\n\nNEWS MODE: Share POSITIVE news in simple terms, focus on uplifting stories.';
        break;
      case 'game':
        basePrompt += '\n\nGAME MODE: Create SIMPLE memory games with clear instructions and encouragement.';
        break;
      default:
        basePrompt += '\n\nGENERAL: Engage in warm conversation, show interest, be comforting.';
    }

    return basePrompt;
  }

  // Get conversation history
  Future<List<Map<String, String>>> _getConversationHistory(
      String userId,
      String conversationId,
      ) async {
    try {
      DocumentSnapshot conversationDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('aiConversations')
          .doc(conversationId)
          .get();

      if (conversationDoc.exists) {
        Map<String, dynamic> data = conversationDoc.data() as Map<String, dynamic>;
        List<dynamic> messages = data['messages'] ?? [];

        // Return last 5 messages for free tier optimization
        List<Map<String, String>> history = [];
        int startIndex = messages.length > 5 ? messages.length - 5 : 0;

        for (int i = startIndex; i < messages.length; i++) {
          Map<String, dynamic> msg = messages[i];
          history.add({
            'sender': msg['sender'] ?? 'user',
            'message': msg['message'] ?? '',
          });
        }

        return history;
      }

      return [];
    } catch (e) {
      print('Error getting conversation history: $e');
      return [];
    }
  }

  // Save conversation
  Future<void> _saveConversation({
    required String userId,
    required String conversationId,
    required String userMessage,
    required String aiResponse,
    required String language,
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
          'language': language,
          'messages': [],
          'conversationType': conversationType,
          'startedAt': FieldValue.serverTimestamp(),
          'endedAt': null,
          'duration': 0,
        });
      }

      // Add user message
      await conversationRef.update({
        'messages': FieldValue.arrayUnion([
          {
            'messageId': DateTime.now().millisecondsSinceEpoch.toString(),
            'sender': 'user',
            'message': userMessage,
            'originalLanguage': language,
            'timestamp': FieldValue.serverTimestamp(),
          }
        ]),
      });

      // Add AI response
      await conversationRef.update({
        'messages': FieldValue.arrayUnion([
          {
            'messageId': (DateTime.now().millisecondsSinceEpoch + 1).toString(),
            'sender': 'ai',
            'message': aiResponse,
            'originalLanguage': language,
            'timestamp': FieldValue.serverTimestamp(),
          }
        ]),
      });
    } catch (e) {
      print('Error saving conversation: $e');
    }
  }

  // Log activity
  Future<void> _logActivity({
    required String userId,
    required String activityType,
    required String activityDescription,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('activityLog')
          .add({
        'activityId': DateTime.now().millisecondsSinceEpoch.toString(),
        'activityType': activityType,
        'activityDescription': activityDescription,
        'timestamp': FieldValue.serverTimestamp(),
        'metadata': metadata ?? {},
        'duration': null,
      });
    } catch (e) {
      print('Error logging activity: $e');
    }
  }

  // Change AI provider
  void setAIProvider(String provider) {
    if (['gemini', 'huggingface', 'cohere', 'local'].contains(provider)) {
      _currentProvider = provider;
    }
  }

  String getCurrentProvider() => _currentProvider;

  // End conversation
  Future<void> endConversation(String userId, String conversationId) async {
    try {
      DocumentSnapshot conversationDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('aiConversations')
          .doc(conversationId)
          .get();

      if (conversationDoc.exists) {
        Map<String, dynamic> data = conversationDoc.data() as Map<String, dynamic>;
        Timestamp? startedAt = data['startedAt'];

        if (startedAt != null) {
          int duration = DateTime.now().difference(startedAt.toDate()).inSeconds;

          await _firestore
              .collection('users')
              .doc(userId)
              .collection('aiConversations')
              .doc(conversationId)
              .update({
            'endedAt': FieldValue.serverTimestamp(),
            'duration': duration,
          });
        }
      }
    } catch (e) {
      print('Error ending conversation: $e');
    }
  }
}
