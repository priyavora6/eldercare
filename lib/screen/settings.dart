import 'package:flutter/material.dart';
import 'package:eldercare/widgets/translated_text.dart';
import 'notifications_settings.dart';
import 'voice_settings.dart';
import 'language_settings.dart';
import 'about_us.dart';
import 'how_it_works.dart';
import 'faq.dart';
import 'privacy_policy.dart';
import 'terms_and_conditions.dart';
import 'developer.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: TranslatedText('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionTitle('Preferences'),
          _buildSettingsTile(Icons.notifications, 'Notifications', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsSettingsScreen()));
          }),
          _buildSettingsTile(Icons.volume_up, 'Voice', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => VoiceSettingsScreen()));
          }),
          _buildSettingsTile(Icons.language, 'Language', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSettingsScreen()));
          }),
          Divider(color: Color(0xFFE0E0E0), height: 1),

          _buildSectionTitle('About the App'),
          _buildSettingsTile(Icons.info, 'App Version', () {
            showAboutDialog(
              context: context,
              applicationName: 'ElderCare AI',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2024 ElderCare AI',
            );
          }),
          _buildSettingsTile(Icons.people, 'About Us', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsScreen()));
          }),
          _buildSettingsTile(Icons.help, 'How It Works', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HowItWorksScreen()));
          }),
          _buildSettingsTile(Icons.question_answer, 'FAQ', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FAQScreen()));
          }),
          _buildSettingsTile(Icons.code, 'Developer', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DeveloperScreen()));
          }),
          Divider(color: Color(0xFFE0E0E0), height: 1),

          _buildSectionTitle('Legal'),
          _buildSettingsTile(Icons.privacy_tip, 'Privacy Policy', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
          }),
          _buildSettingsTile(Icons.gavel, 'Terms & Conditions', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndConditionsScreen()));
          }),
          Divider(color: Color(0xFFE0E0E0), height: 1),

          SizedBox(height: 20),
          _buildLogoutButton(context),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: TranslatedText(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4A90E2),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF2C3E50)),
      title: TranslatedText(title, style: TextStyle(fontSize: 16, color: Color(0xFF2C3E50))),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF7F8C8D)),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          // Handle logout
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE74C3C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 8),
            TranslatedText(
              'Logout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
