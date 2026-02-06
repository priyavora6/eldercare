import 'package:eldercare/provider/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eldercare/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ElderCareApp());
}

class ElderCareApp extends StatefulWidget {
  @override
  _ElderCareAppState createState() => _ElderCareAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _ElderCareAppState? state = context.findAncestorStateOfType<_ElderCareAppState>();
    state?.setLocale(newLocale);
  }
}

class _ElderCareAppState extends State<ElderCareApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('selected_language');
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode, '');
      });
    }
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
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
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: [
          Locale('en', ''),
          Locale('hi', ''),
          Locale('gu', ''),
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
      ),
    );
  }
}
