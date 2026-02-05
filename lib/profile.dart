
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Handle edit profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            SizedBox(height: 24),
            _buildSectionTitle('User Details'),
            SizedBox(height: 12),
            _buildDetailsCard(),
            SizedBox(height: 24),
            _buildSectionTitle('Medical History'),
            SizedBox(height: 12),
            _buildMedicalHistoryCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/eldercare.png'), // Placeholder
          ),
          SizedBox(height: 12),
          Text(
            'Priya',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          Text(
            'priya@example.com',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF7F8C8D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2C3E50),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(Icons.person, 'Age', '72'),
          _buildDetailRow(Icons.cake, 'Birthday', 'January 1, 1952'),
          _buildDetailRow(Icons.phone, 'Phone', '+91 1234567890'),
          _buildDetailRow(Icons.home, 'Address', '123 Main St, Anytown, India'),
        ],
      ),
    );
  }

  Widget _buildMedicalHistoryCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(Icons.bloodtype, 'Blood Type', 'O+'),
          _buildDetailRow(Icons.warning, 'Allergies', 'Peanuts, Penicillin'),
          _buildDetailRow(Icons.medical_services, 'Chronic Conditions', 'Hypertension, Diabetes'),
          _buildDetailRow(Icons.healing, 'Surgeries', 'Appendectomy (2005)'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF4A90E2), size: 24),
          SizedBox(width: 16),
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
          Spacer(),
          Text(value, style: TextStyle(fontSize: 16, color: Color(0xFF7F8C8D))),
        ],
      ),
    );
  }
}
