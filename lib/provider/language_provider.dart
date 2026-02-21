import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', '');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, String> _translationCache = {};

  Locale get currentLocale => _currentLocale;
  String get currentLanguageCode => _currentLocale.languageCode;

  LanguageProvider() {
    initialize();
  }

  Future<void> initialize() async {
    await _loadLanguage();
  }

  // FIX: Actually loads saved language instead of hardcoding English
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('language_code') ?? 'en';
      _currentLocale = Locale(saved, '');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  // FIX: Actually saves language to SharedPreferences
  Future<void> changeLanguage(String languageCode, {String? userId}) async {
    if (!['en', 'hi', 'gu'].contains(languageCode)) return;

    _currentLocale = Locale(languageCode, '');
    _translationCache.clear();

    // Save so it persists after app restart
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);

    if (userId != null) {
      try {
        await _firestore.collection('users').doc(userId).update({
          'preferences.language': languageCode,
        });
      } catch (e) {
        debugPrint('Error updating language in Firestore: $e');
      }
    }

    notifyListeners();
  }

  // FIX: Uses MyMemory API — free, no key, actually works
  Future<String> translate(String text) async {
    if (currentLanguageCode == 'en' || text.trim().isEmpty) return text;

    final cacheKey = '${currentLanguageCode}_$text';
    if (_translationCache.containsKey(cacheKey)) {
      return _translationCache[cacheKey]!;
    }

    try {
      final uri = Uri.parse(
        'https://api.mymemory.translated.net/get?q=${Uri.encodeComponent(text)}&langpair=en|$currentLanguageCode',
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final translated = data['responseData']['translatedText'] as String;

        if (translated.isNotEmpty && translated != text) {
          _translationCache[cacheKey] = translated;
          return translated;
        }
      }
    } catch (e) {
      debugPrint('Translation error for "$text": $e');
    }

    return text; // fallback to original
  }

  String getLanguageName(String code) {
    switch (code) {
      case 'hi': return 'हिंदी';
      case 'gu': return 'ગુજરાતી';
      default: return 'English';
    }
  }
}