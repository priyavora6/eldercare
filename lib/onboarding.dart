import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.favorite,
      title: 'Welcome to ElderCare AI',
      description: 'Your smart companion for health, safety, and wellbeing',
    ),
    OnboardingPage(
      icon: Icons.warning_amber,
      title: 'Emergency SOS',
      description: 'One-tap emergency button to alert family and ambulance instantly',
    ),
    OnboardingPage(
      icon: Icons.medication,
      title: 'Medicine Reminders',
      description: 'Never miss your medication with voice-based reminders',
    ),
    OnboardingPage(
      icon: Icons.chat_bubble,
      title: 'AI Companion',
      description: 'Chat, listen to music, and play memory games anytime',
    ),
    OnboardingPage(
      icon: Icons.family_restroom,
      title: 'Family Connection',
      description: 'Your family can monitor your health and stay connected',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text(
                      'SKIP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 32 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Color(0xFF4A90E2)
                        : Color(0xFFBDC3C7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),

            // Navigation Buttons
            Padding(
              padding: EdgeInsets.all(24),
              child: _currentPage == _pages.length - 1
                  ? _buildGradientButton(
                text: 'GET STARTED',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    OutlinedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF4A90E2),
                        padding: EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        side: BorderSide(
                            color: Color(0xFF4A90E2), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'PREVIOUS',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'NEXT',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF50C878)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 48),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          SizedBox(height: 24),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF7F8C8D),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF50C878)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}