
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for a short duration to show the splash screen.
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Always navigate to the language selection page after the splash screen.
    Navigator.pushReplacementNamed(context, '/language-selection');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color has been removed to restore the original appearance.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/eldercare.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),
            const Text(
              'ElderCare AI',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                // The color is now inherited from the default theme.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
