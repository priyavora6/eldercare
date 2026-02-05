import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eldercare/main.dart';
import 'package:eldercare/splash_screen.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ElderCareApp());

    // Verify that the splash screen is shown first.
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
