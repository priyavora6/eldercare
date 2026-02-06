import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eldercare/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: l10n.home),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: l10n.medicine),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: l10n.aiChat),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: l10n.settings),
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () => _showNotifications(context, l10n),
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
            _buildWelcomeHeader(context, l10n),
            SizedBox(height: 24),
            _buildSOSButton(context, l10n),
            SizedBox(height: 24),
            _buildQuickActionsGrid(context, l10n),
            SizedBox(height: 24),
            _buildSummaryCard(context, l10n),
            SizedBox(height: 24),
            _buildFamilyActions(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/eldercare.png')),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.helloPriya, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
            Text(l10n.howAreYouFeelingToday, style: TextStyle(fontSize: 16, color: Color(0xFF7F8C8D))),
          ],
        ),
      ],
    );
  }

  Widget _buildSOSButton(BuildContext context, AppLocalizations l10n) {
    return ElevatedButton.icon(
      onPressed: () => _triggerSOS(context, l10n),
      icon: Icon(Icons.warning_amber, size: 32, color: Colors.white),
      label: Text(l10n.emergencySos, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE74C3C),
        minimumSize: Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, AppLocalizations l10n) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildActionCard(context, icon: Icons.phone, title: l10n.callFamily, color: Color(0xFF50C878), onTap: () => _callFamily(context)),
        _buildActionCard(context, icon: Icons.favorite, title: l10n.healthCheckIn, color: Color(0xFF4A90E2), onTap: () => Navigator.pushNamed(context, '/health-checkin')),
        _buildActionCard(context, icon: Icons.chat_bubble, title: l10n.aiCompanion, color: Color(0xFF9B59B6), onTap: () => Navigator.pushNamed(context, '/ai-companion')),
        _buildActionCard(context, icon: Icons.history, title: l10n.activityLog, color: Color(0xFFF39C12), onTap: () => Navigator.pushNamed(context, '/activity-log')),
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
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, AppLocalizations l10n) {
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
          Text(l10n.todaysSummary, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
          SizedBox(height: 16),
          _buildSummaryItem(icon: Icons.medication, title: l10n.medicines, value: '2 of 3 taken', color: Color(0xFF50C878), onTap: () => Navigator.pushNamed(context, '/medicine')),
          _buildSummaryItem(icon: Icons.directions_walk, title: l10n.steps, value: '1,234 steps', color: Color(0xFF4A90E2), onTap: () => Navigator.pushNamed(context, '/activity-log')),
          _buildSummaryItem(icon: Icons.bedtime, title: l10n.sleep, value: '7 hours', color: Color(0xFF9B59B6), onTap: () => Navigator.pushNamed(context, '/activity-log')),
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
            Text(title, style: TextStyle(fontSize: 16, color: Color(0xFF7F8C8D))),
            Spacer(),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
            Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF7F8C8D)),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyActions(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(child: _buildQuickButton(context, icon: Icons.contacts, label: l10n.contacts, onTap: () => Navigator.pushNamed(context, '/emergency-contacts'))),
        SizedBox(width: 16),
        Expanded(child: _buildQuickButton(context, icon: Icons.family_restroom, label: l10n.familyView, onTap: () => Navigator.pushNamed(context, '/family-login'))),
      ],
    );
  }

  Widget _buildQuickButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 24, color: Color(0xFF4A90E2)),
      label: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4A90E2))),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    );
  }

  void _triggerSOS(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.emergencySosDialogTitle),
        content: Text(l10n.emergencySosDialogContent),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(onPressed: () async {
            Navigator.pop(context);
            final Uri phoneUri = Uri(scheme: 'tel', path: emergencyNumber);
            if (await canLaunchUrl(phoneUri)) await launchUrl(phoneUri);
          }, child: Text(l10n.callNow)),
        ],
      ),
    );
  }

  void _callFamily(BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: familyNumber);
    if (await canLaunchUrl(phoneUri)) await launchUrl(phoneUri);
  }

  void _showNotifications(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.notifications),
        content: Text(l10n.noNewNotifications),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close))],
      ),
    );
  }
}
