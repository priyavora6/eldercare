import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:eldercare/provider/auth_provider.dart';
import 'package:eldercare/provider/ai_chat_provider.dart';
import 'package:eldercare/provider/language_provider.dart';
import 'package:eldercare/services/translation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'splash_screen.dart';
import 'screen/login.dart';
import 'screen/signup.dart';
import 'screen/onboarding.dart';
import 'screen/home_dashboard.dart';
import 'screen/ai_companion_chat.dart';
import 'screen/medicine_tracker.dart';
import 'screen/health_checkin.dart';
import 'screen/emergency_contacts.dart';
import 'screen/activity_log.dart';
import 'screen/profile.dart';
import 'screen/settings.dart';
import 'screen/family_login.dart';
import 'screen/family_dashboard.dart';
import 'screen/health_reports.dart';
import 'screen/activity_timeline.dart';
import 'screen/video_call.dart';
import 'screen/language_selection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await dotenv.load(fileName: ".env");

  await TranslationService().initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ElderCareApp());
}

class ElderCareApp extends StatelessWidget {
  const ElderCareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AIChatProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'ElderCare AI',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: const Color(0xFF4A90E2),
              scaffoldBackgroundColor: const Color(0xFFF5F7FA),
              fontFamily: 'System',
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF4A90E2),
                secondary: Color(0xFF50C878),
              ),
              appBarTheme: const AppBarTheme(
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
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('hi', ''), // Hindi
              Locale('gu', ''), // Gujarati
            ],
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              '/language-selection': (context) => LanguageSelection(),
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
        },
      ),
    );
  }
}
