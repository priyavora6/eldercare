import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eldercare/main.dart';
import 'package:eldercare/services/translation_service.dart';
import 'package:eldercare/splash_screen.dart';
import 'package:eldercare/screen/language_selection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Mock Firebase initialization
// A more robust mock using MethodChannel is recommended for complex apps.
Future<void> setupFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // This is expected if Firebase is already initialized during tests.
  }
}

void main() {
  // Set up a mock for SharedPreferences before each test
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App starts with SplashScreen, then navigates to LanguageSelection', (WidgetTester tester) async {
    // Initialize Firebase and other services, similar to main.dart
    await setupFirebase();
    await dotenv.load(fileName: ".env");
    await TranslationService().initialize();

    // Build our app and trigger a frame.
    // The ElderCareApp widget now handles its own providers.
    await tester.pumpWidget(const ElderCareApp());

    // Verify that the app starts with the splash screen
    expect(find.byType(SplashScreen), findsOneWidget);

    // Wait for the splash screen's timer to finish
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify that we have navigated to the language selection screen
    expect(find.byType(LanguageSelection), findsOneWidget);
  });
}
