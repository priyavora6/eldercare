import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eldercare/l10n/app_localizations.dart';

class ActivityLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<Activity> _activities = [
      Activity(
        icon: Icons.medication,
        title: l10n.tookMedicine,
        subtitle: l10n.aspirin100mg,
        time: '08:00 AM',
        color: Color(0xFF50C878),
      ),
      Activity(
        icon: Icons.directions_walk,
        title: l10n.morningWalk,
        subtitle: '1,234 steps',
        time: '09:30 AM',
        color: Color(0xFF4A90E2),
      ),
      Activity(
        icon: Icons.favorite,
        title: l10n.healthCheckIn,
        subtitle: l10n.feelingGreat,
        time: '10:00 AM',
        color: Color(0xFF50C878),
      ),
      Activity(
        icon: Icons.medication,
        title: l10n.tookMedicine,
        subtitle: l10n.metformin500mg,
        time: '12:00 PM',
        color: Color(0xFF50C878),
      ),
      Activity(
        icon: Icons.chat,
        title: l10n.aiCompanionChat,
        subtitle: l10n.listenedToMusic,
        time: '02:30 PM',
        color: Color(0xFF9B59B6),
      ),
      Activity(
        icon: Icons.restaurant,
        title: l10n.lunch,
        subtitle: l10n.ateAHealthyMeal,
        time: '01:00 PM',
        color: Color(0xFFE67E22),
      ),
      Activity(
        icon: Icons.call,
        title: l10n.videoCallWithFamily,
        subtitle: l10n.talkedFor30Minutes,
        time: '04:00 PM',
        color: Color(0xFF3498DB),
      ),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF4A90E2),
        title: Text(l10n.activityLog, style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(icon: Icon(Icons.calendar_today, color: Colors.white), onPressed: () => _showDatePicker(context, l10n)),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(l10n),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _activities.length,
              itemBuilder: (context, index) => _buildActivityItem(_activities[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(AppLocalizations l10n) {
    return Container(
      margin: EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(icon: Icons.directions_walk, value: '1,234', label: l10n.steps, color: Color(0xFF4A90E2)),
              _buildSummaryItem(icon: Icons.medication, value: '2/3', label: l10n.medicines, color: Color(0xFF50C878)),
              _buildSummaryItem(icon: Icons.bedtime, value: '7h', label: l10n.sleep, color: Color(0xFF9B59B6)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({required IconData icon, required String value, required String label, required Color color}) {
    return Column(
      children: [
        Icon(icon, size: 36, color: color),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
        Text(label, style: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D))),
      ],
    );
  }

  Widget _buildActivityItem(Activity activity) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: activity.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(activity.icon, size: 28, color: activity.color),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                SizedBox(height: 4),
                Text(activity.subtitle, style: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D))),
              ],
            ),
          ),
          Text(activity.time, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF7F8C8D))),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context, AppLocalizations l10n) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
    if (picked != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.viewingActivitiesFor(DateFormat('MMM dd, yyyy').format(picked))), backgroundColor: Color(0xFF4A90E2)));
    }
  }
}

class Activity {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  Activity({required this.icon, required this.title, required this.subtitle, required this.time, required this.color});
}
