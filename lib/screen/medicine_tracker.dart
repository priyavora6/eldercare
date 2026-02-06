import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eldercare/l10n/app_localizations.dart';

class MedicineTracker extends StatefulWidget {
  @override
  _MedicineTrackerState createState() => _MedicineTrackerState();
}

class _MedicineTrackerState extends State<MedicineTracker> {
  final List<Medicine> _medicines = [
    Medicine(
      name: 'Aspirin',
      dosage: '100mg',
      time: '08:00 AM',
      taken: true,
      icon: Icons.medication,
    ),
    Medicine(
      name: 'Metformin',
      dosage: '500mg',
      time: '12:00 PM',
      taken: true,
      icon: Icons.medication,
    ),
    Medicine(
      name: 'Atorvastatin',
      dosage: '20mg',
      time: '08:00 PM',
      taken: false,
      icon: Icons.medication,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    int takenCount = _medicines.where((m) => m.taken).length;
    int totalCount = _medicines.length;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF4A90E2),
        title: Text(l10n.medicineTracker, style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.white),
            onPressed: () => _showMedicineHistory(context, l10n),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(takenCount, totalCount, l10n),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                l10n.todaysSchedule,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _medicines.length,
              itemBuilder: (context, index) {
                return _buildMedicineItem(_medicines[index], index, l10n);
              },
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _scanPrescription(context, l10n),
            backgroundColor: Color(0xFF50C878),
            heroTag: 'scan',
            child: Icon(Icons.camera_alt, size: 28, color: Colors.white),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _addMedicine(context, l10n),
            backgroundColor: Color(0xFF4A90E2),
            heroTag: 'add',
            child: Icon(Icons.add, size: 32, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(int taken, int total, AppLocalizations l10n) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            l10n.adherenceRate,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                icon: Icons.check_circle,
                value: '$taken',
                label: l10n.taken,
                color: Color(0xFF50C878),
              ),
              _buildSummaryItem(
                icon: Icons.pending_actions,
                value: '${total - taken}',
                label: l10n.missed,
                color: Color(0xFFE74C3C),
              ),
              _buildSummaryItem(
                icon: Icons.medical_services,
                value: '$total',
                label: l10n.total,
                color: Color(0xFF4A90E2),
              ),
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
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF7F8C8D),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineItem(Medicine medicine, int index, AppLocalizations l10n) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (medicine.taken ? Color(0xFF50C878) : Color(0xFF4A90E2)).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(medicine.icon, size: 28, color: medicine.taken ? Color(0xFF50C878) : Color(0xFF4A90E2)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${medicine.dosage} • ${medicine.time}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ],
            ),
          ),
          if (!medicine.taken)
            TextButton(
              onPressed: () {
                setState(() {
                  _medicines[index].taken = true;
                });
              },
              child: Text(l10n.take, style: TextStyle(color: Color(0xFF50C878), fontWeight: FontWeight.bold, fontSize: 16)),
            )
          else
            Icon(Icons.check_circle_outline, color: Color(0xFF50C878), size: 28),
        ],
      ),
    );
  }

  void _scanPrescription(BuildContext context, AppLocalizations l10n) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.camera_alt, color: Color(0xFF4A90E2)),
            SizedBox(width: 12),
            Text(l10n.scanPrescription),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.document_scanner, size: 80, color: Color(0xFF4A90E2)),
            SizedBox(height: 16),
            Text(
              l10n.scanPrescriptionHelperText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              final ImagePicker _picker = ImagePicker();
              try {
                final XFile? image =
                await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.prescriptionScannedSuccessfully),
                      backgroundColor: Color(0xFF50C878),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.cameraPermissionRequired),
                    backgroundColor: Color(0xFFE74C3C),
                  ),
                );
              }
            },
            icon: Icon(Icons.camera),
            label: Text(l10n.scanNow, style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4A90E2)),
          ),
        ],
      ),
    );
  }

  void _addMedicine(BuildContext context, AppLocalizations l10n) {
    final _nameController = TextEditingController();
    final _dosageController = TextEditingController();
    final _timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addMedicine),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.medicineName,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medication),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _dosageController,
                decoration: InputDecoration(
                  labelText: l10n.dosage,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medical_services),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: l10n.time,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _dosageController.text.isNotEmpty &&
                  _timeController.text.isNotEmpty) {
                setState(() {
                  _medicines.add(Medicine(
                    name: _nameController.text,
                    dosage: _dosageController.text,
                    time: _timeController.text,
                    taken: false,
                    icon: Icons.medication,
                  ));
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.medicineAddedSuccessfully),
                    backgroundColor: Color(0xFF50C878),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4A90E2)),
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _showMedicineHistory(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.medicineHistory),
        content: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildHistoryItem(l10n.yesterday, l10n.medicinesTaken(3, 3), true),
              _buildHistoryItem(l10n.daysAgo(2), l10n.medicinesTaken(2, 3), false),
              _buildHistoryItem(l10n.daysAgo(3), l10n.medicinesTaken(3, 3), true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String date, String status, bool complete) {
    return ListTile(
      leading: Icon(
        complete ? Icons.check_circle : Icons.warning,
        color: complete ? Color(0xFF50C878) : Color(0xFFF39C12),
      ),
      title: Text(date),
      subtitle: Text(status),
    );
  }
}

class Medicine {
  final String name;
  final String dosage;
  final String time;
  bool taken;
  final IconData icon;

  Medicine({
    required this.name,
    required this.dosage,
    required this.time,
    required this.taken,
    required this.icon,
  });
}
