import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = Locale('en', '');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Locale get currentLocale => _currentLocale;
  String get currentLanguageCode => _currentLocale.languageCode;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language');
    if (languageCode != null) {
      _currentLocale = Locale(languageCode, '');
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode, {String? userId}) async {
    _currentLocale = Locale(languageCode, '');

    // Save to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);

    // Save to Firestore if user is logged in
    if (userId != null) {
      try {
        await _firestore.collection('users').doc(userId).update({
          'preferences.language': languageCode,
          'preferences.aiChatLanguage': languageCode,
          'preferences.voiceLanguage': languageCode,
        });
      } catch (e) {
        print('Error updating language in Firestore: $e');
      }
    }

    notifyListeners();
  }

  String getLanguageName(String code) {
    switch (code) {
      case 'hi':
        return 'हिंदी';
      case 'gu':
        return 'ગુજરાતી';
      default:
        return 'English';
    }
  }
}