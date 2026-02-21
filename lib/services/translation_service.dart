import 'package:translator/translator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  final translator = GoogleTranslator();

  String _currentLanguage = 'en'; // Default language

  // Language codes
  static const String ENGLISH = 'en';
  static const String HINDI = 'hi';
  static const String GUJARATI = 'gu';

  // Get current language
  String get currentLanguage => _currentLanguage;

  // Initialize and load saved language
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('app_language') ?? 'en';
  }

  // Change language
  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', languageCode);
  }

  // Translate any text to current language
  Future<String> translate(String text) async {
    if (_currentLanguage == 'en') {
      return text; // No translation needed for English
    }

    try {
      final translation = await translator.translate(
        text,
        from: 'en',
        to: _currentLanguage,
      );
      return translation.text;
    } catch (e) {
      print('Translation error: $e');
      return text; // Return original text if translation fails
    }
  }

  // Translate from any language to English (for AI processing)
  Future<String> translateToEnglish(String text) async {
    if (_currentLanguage == 'en') {
      return text;
    }

    try {
      final translation = await translator.translate(
        text,
        from: _currentLanguage,
        to: 'en',
      );
      return translation.text;
    } catch (e) {
      print('Translation error: $e');
      return text;
    }
  }

  // Translate from English to specific language
  Future<String> translateTo(String text, String targetLanguage) async {
    if (targetLanguage == 'en') {
      return text;
    }

    try {
      final translation = await translator.translate(
        text,
        from: 'en',
        to: targetLanguage,
      );
      return translation.text;
    } catch (e) {
      print('Translation error: $e');
      return text;
    }
  }

  // Auto-detect language and translate to current language
  Future<String> autoTranslate(String text) async {
    try {
      final translation = await translator.translate(
        text,
        to: _currentLanguage,
      );
      return translation.text;
    } catch (e) {
      print('Auto-translation error: $e');
      return text;
    }
  }

  // Detect language of text
  Future<String> detectLanguage(String text) async {
    try {
      final detected = await translator.translate(text, to: 'en');
      return detected.sourceLanguage.code;
    } catch (e) {
      print('Language detection error: $e');
      return 'en';
    }
  }

  // Get language name
  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी';
      case 'gu':
        return 'ગુજરાતી';
      default:
        return 'English';
    }
  }

  // Get language emoji
  String getLanguageEmoji(String code) {
    switch (code) {
      case 'en':
        return '🇬🇧';
      case 'hi':
        return '🇮🇳';
      case 'gu':
        return '🇮🇳';
      default:
        return '🇬🇧';
    }
  }

  // Translate multiple texts at once (batch)
  Future<List<String>> translateBatch(List<String> texts) async {
    List<String> translated = [];

    for (String text in texts) {
      translated.add(await translate(text));
    }

    return translated;
  }
}

// Extension for easy translation on String
extension TranslateString on String {
  Future<String> tr() async {
    return await TranslationService().translate(this);
  }

  Future<String> trTo(String lang) async {
    return await TranslationService().translateTo(this, lang);
  }
}