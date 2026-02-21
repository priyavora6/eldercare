import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/language_provider.dart';

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({Key? key}) : super(key: key);

  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  String _selectedLanguage = 'en';
  bool _isLoading = false;

  // ── Same colors as Login ──────────────────────────────
  static const primaryColor = Color(0xFF2E8B8B);
  static const backgroundColor = Color(0xFFF4F9F9);
  static const textDark = Color(0xFF1F2937);
  static const textLight = Color(0xFF6B7280);

  final List<Language> _languages = [
    Language(code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧'),
    Language(code: 'hi', name: 'Hindi', nativeName: 'हिंदी', flag: '🇮🇳'),
    Language(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentLanguage();
    });
  }

  void _loadCurrentLanguage() {
    try {
      final provider = Provider.of<LanguageProvider>(context, listen: false);
      setState(() {
        _selectedLanguage = provider.currentLanguageCode ?? 'en';
      });
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Logo circle — teal gradient
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2E8B8B), Color(0xFF50C878)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.language_rounded,
                      size: 55,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Choose Your Language',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'अपनी भाषा चुनें • તમારી ભાષા પસંદ કરો',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: textLight,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // ── Language List ──────────────────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    return _buildLanguageCard(_languages[index]);
                  },
                ),
              ),
            ),

            // ── Continue Button ────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: primaryColor.withOpacity(0.4),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : Text(
                    _getContinueButtonText(),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
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
      onTap: () => setState(() => _selectedLanguage = language.code),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withOpacity(0.05)
              : const Color(0xFFFAFBFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : const Color(0xFFEDF0F3),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? primaryColor.withOpacity(0.1)
                  : Colors.black.withOpacity(0.02),
              blurRadius: isSelected ? 12 : 6,
              offset: Offset(0, isSelected ? 4 : 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Flag container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor.withOpacity(0.1)
                    : const Color(0xFFF5F7F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  language.flag,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(width: 18),
            // Language name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.nativeName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? primaryColor : textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    language.name,
                    style: const TextStyle(
                      fontSize: 13,
                      color: textLight,
                    ),
                  ),
                ],
              ),
            ),
            // Check circle
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? primaryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? primaryColor : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  String _getContinueButtonText() {
    switch (_selectedLanguage) {
      case 'hi': return 'जारी रखें';
      case 'gu': return 'ચાલુ રાખો';
      default: return 'CONTINUE';
    }
  }

  Future<void> _saveAndContinue() async {
    setState(() => _isLoading = true);
    try {
      final provider = Provider.of<LanguageProvider>(context, listen: false);
      await provider.changeLanguage(_selectedLanguage);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('language_selected', true);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getSuccessMessage()),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      debugPrint('ERROR saving language: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getSuccessMessage() {
    switch (_selectedLanguage) {
      case 'hi': return 'भाषा सहेजी गई!';
      case 'gu': return 'ભાષા સાચવી!';
      default: return 'Language saved!';
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