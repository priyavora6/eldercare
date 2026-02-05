import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_screen.dart';
import 'login.dart';
import 'signup.dart';
import 'onboarding.dart';
import 'home_dashboard.dart';
import 'ai_companion_chat.dart';
import 'medicine_tracker.dart';
import 'health_checkin.dart';
import 'emergency_contacts.dart';
import 'activity_log.dart';
import 'profile.dart';
import 'settings.dart';
import 'family_login.dart';
import 'family_dashboard.dart';
import 'health_reports.dart';
import 'activity_timeline.dart';
import 'video_call.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ElderCareApp());
}

class ElderCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElderCare AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF4A90E2),
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
        fontFamily: 'System',
        colorScheme: ColorScheme.light(
          primary: Color(0xFF4A90E2),
          secondary: Color(0xFF50C878),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4A90E2),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/home': (context) => HomeDashboard(),
        '/ai-companion': (context) => AICompanionChat(),
        '/medicine': (context) => MedicineTracker(),
        '/health-checkin': (context) => HealthCheckIn(),
        '/emergency-contacts': (context) => EmergencyContacts(),
        '/activity-log': (context) => ActivityLog(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
        '/family-login': (context) => FamilyLogin(),
        '/family-dashboard': (context) => FamilyDashboard(),
        '/health-reports': (context) => HealthReports(),
        '/activity-timeline': (context) => ActivityTimeline(),
        '/video-call': (context) => VideoCall(),
      },
    );
  }
}
