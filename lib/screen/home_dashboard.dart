import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/translated_text.dart';

class HomeDashboard extends StatefulWidget {
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeScreen(),
      Container(), // Placeholder for nav
      Container(), // Placeholder for nav
      Container(), // Placeholder for nav
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/medicine');
          if (index == 2) Navigator.pushNamed(context, '/ai-companion');
          if (index == 3) Navigator.pushNamed(context, '/settings');
          // Don't change the selected index for external pages
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF4A90E2),
        unselectedItemColor: Color(0xFF7F8C8D),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: 'Medicine'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'AI Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String emergencyNumber = '911';
  final String familyNumber = '+919876543210';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: TranslatedText('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () => _showNotifications(context),
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWelcomeHeader(context),
            SizedBox(height: 24),
            _buildSOSButton(context),
            SizedBox(height: 24),
            _buildQuickActionsGrid(context),
            SizedBox(height: 24),
            _buildSummaryCard(context),
            SizedBox(height: 24),
            _buildFamilyActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/eldercare.png')),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TranslatedText('Hello, Priya!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
            TranslatedText('How are you feeling today?', style: TextStyle(fontSize: 16, color: Color(0xFF7F8C8D))),
          ],
        ),
      ],
    );
  }

  Widget _buildSOSButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _triggerSOS(context),
      icon: Icon(Icons.warning_amber, size: 32, color: Colors.white),
      label: TranslatedText('Emergency SOS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE74C3C),
        minimumSize: Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildActionCard(context, icon: Icons.phone, title: 'Call Family', color: Color(0xFF50C878), onTap: () => _callFamily(context)),
        _buildActionCard(context, icon: Icons.favorite, title: 'Health Check-in', color: Color(0xFF4A90E2), onTap: () => Navigator.pushNamed(context, '/health-checkin')),
        _buildActionCard(context, icon: Icons.chat_bubble, title: 'AI Companion', color: Color(0xFF9B59B6), onTap: () => Navigator.pushNamed(context, '/ai-companion')),
        _buildActionCard(context, icon: Icons.history, title: 'Activity Log', color: Color(0xFFF39C12), onTap: () => Navigator.pushNamed(context, '/activity-log')),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, {required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 40, color: color),
            ),
            SizedBox(height: 12),
            TranslatedText(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText('Today\'s Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
          SizedBox(height: 16),
          _buildSummaryItem(icon: Icons.medication, title: 'Medicines', value: '2 of 3 taken', color: Color(0xFF50C878), onTap: () => Navigator.pushNamed(context, '/medicine')),
          _buildSummaryItem(icon: Icons.directions_walk, title: 'Steps', value: '1,234 steps', color: Color(0xFF4A90E2), onTap: () => Navigator.pushNamed(context, '/activity-log')),
          _buildSummaryItem(icon: Icons.bedtime, title: 'Sleep', value: '7 hours', color: Color(0xFF9B59B6), onTap: () => Navigator.pushNamed(context, '/activity-log')),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({required IconData icon, required String title, required String value, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(width: 12),
            TranslatedText(title, style: TextStyle(fontSize: 16, color: Color(0xFF7F8C8D))),
            Spacer(),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
            Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF7F8C8D)),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyActions(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildQuickButton(context, icon: Icons.contacts, label: 'Contacts', onTap: () => Navigator.pushNamed(context, '/emergency-contacts'))),
        SizedBox(width: 16),
        Expanded(child: _buildQuickButton(context, icon: Icons.family_restroom, label: 'Family View', onTap: () => Navigator.pushNamed(context, '/family-login'))),
      ],
    );
  }

  Widget _buildQuickButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 24, color: Color(0xFF4A90E2)),
      label: TranslatedText(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4A90E2))),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    );
  }

  void _triggerSOS(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: TranslatedText('Emergency SOS'),
        content: TranslatedText('Are you sure you want to trigger an SOS? This will call emergency services and notify your primary contacts.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: TranslatedText('Cancel')),
          ElevatedButton(onPressed: () async {
            Navigator.pop(context);
            final Uri phoneUri = Uri(scheme: 'tel', path: emergencyNumber);
            if (await canLaunchUrl(phoneUri)) await launchUrl(phoneUri);
          }, child: TranslatedText('Call Now')),
        ],
      ),
    );
  }

  void _callFamily(BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: familyNumber);
    if (await canLaunchUrl(phoneUri)) await launchUrl(phoneUri);
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: TranslatedText('Notifications'),
        content: TranslatedText('No new notifications'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: TranslatedText('Close'))],
      ),
    );
  }
}
