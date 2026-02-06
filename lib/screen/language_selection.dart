import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class LanguageSelection extends StatefulWidget {
  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  String? _selectedLanguage;
  bool _isLoading = false;

  final List<Language> _languages = [
    Language(code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧'),
    Language(code: 'hi', name: 'Hindi', nativeName: 'हिंदी', flag: '🇮🇳'),
    Language(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳'),
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selected_language');
    if (savedLanguage != null) {
      setState(() {
        _selectedLanguage = savedLanguage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A90E2), Color(0xFF50C878)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF4A90E2).withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.language,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24),
                  // Title
                  Text(
                    'Choose Your Language',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Subtitle in multiple languages
                  Text(
                    'अपनी भाषा चुनें • તમારી ભાષા પસંદ કરો',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                ],
              ),
            ),

            // Language List
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(24),
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    return _buildLanguageCard(_languages[index]);
                  },
                ),
              ),
            ),

            // Continue Button
            if (_selectedLanguage != null)
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF50C878)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4A90E2).withOpacity(0.4),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _saveAndContinue(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      _getContinueButtonText(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(Language language) {
    final isSelected = _selectedLanguage == language.code;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = language.code;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Color(0xFF4A90E2) : Color(0xFFE0E0E0),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Color(0xFF4A90E2).withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            // Flag
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? Color(0xFF4A90E2).withOpacity(0.1)
                    : Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  language.flag,
                  style: TextStyle(fontSize: 36),
                ),
              ),
            ),
            SizedBox(width: 20),
            // Language Names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.nativeName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    language.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                ],
              ),
            ),
            // Selection Indicator
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Color(0xFF4A90E2) : Color(0xFFBDC3C7),
                  width: 2,
                ),
                color: isSelected ? Color(0xFF4A90E2) : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  String _getContinueButtonText() {
    switch (_selectedLanguage) {
      case 'hi':
        return 'जारी रखें';
      case 'gu':
        return 'ચાલુ રાખો';
      default:
        return 'CONTINUE';
    }
  }

  Future<void> _saveAndContinue() async {
    if (_selectedLanguage != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Save language preference to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selected_language', _selectedLanguage!);
        await prefs.setBool('language_selected', true);

        // Set the locale in the app BEFORE navigation
        ElderCareApp.setLocale(context, Locale(_selectedLanguage!));

        // Small delay to let the locale change propagate
        await Future.delayed(Duration(milliseconds: 300));

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text(_getSuccessMessage()),
                ],
              ),
              backgroundColor: Color(0xFF50C878),
              behavior: SnackBarBehavior.floating,
              duration: Duration(milliseconds: 800),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }

        // Navigate to login after small delay
        await Future.delayed(Duration(milliseconds: 500));

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving language preference'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _getSuccessMessage() {
    switch (_selectedLanguage) {
      case 'hi':
        return 'भाषा सहेजी गई!';
      case 'gu':
        return 'ભાષા સાચવી!';
      default:
        return 'Language saved!';
    }
  }
}

class Language {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}
