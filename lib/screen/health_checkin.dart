import 'package:flutter/material.dart';
import 'package:eldercare/l10n/app_localizations.dart';

class HealthCheckIn extends StatefulWidget {
  @override
  _HealthCheckInState createState() => _HealthCheckInState();
}

class _HealthCheckInState extends State<HealthCheckIn> {
  String? _selectedMood;
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> _moods = [
      {'emoji': '😊', 'label': l10n.great, 'color': Color(0xFF50C878)},
      {'emoji': '🙂', 'label': l10n.good, 'color': Color(0xFF4A90E2)},
      {'emoji': '😐', 'label': l10n.okay, 'color': Color(0xFFF39C12)},
      {'emoji': '😔', 'label': l10n.sad, 'color': Color(0xFFE67E22)},
      {'emoji': '😣', 'label': l10n.unwell, 'color': Color(0xFFE74C3C)},
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF4A90E2),
        title: Text(l10n.healthCheckIn, style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Card
            Container(
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
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A90E2), Color(0xFF50C878)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.favorite, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    l10n.howAreYouFeelingToday,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    l10n.selectYourMood,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Mood Selection
            Text(
              l10n.yourMood,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: _moods.length,
              itemBuilder: (context, index) {
                final mood = _moods[index];
                final isSelected = _selectedMood == mood['label'];

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedMood = mood['label'];
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? mood['color'].withOpacity(0.2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? mood['color'] : Color(0xFFE0E0E0),
                        width: isSelected ? 3 : 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          mood['emoji'],
                          style: TextStyle(fontSize: 48),
                        ),
                        SizedBox(height: 8),
                        Text(
                          mood['label'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 32),

            // Voice Recording Section
            Text(
              l10n.voiceCheck,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            SizedBox(height: 8),
            Text(
              l10n.recordYourVoice,
              style: TextStyle(fontSize: 16, color: Color(0xFF7F8C8D)),
            ),
            SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(32),
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
                  Container(
                    width: 100,
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isRecording = !_isRecording;
                        });
                        if (_isRecording) {
                          _startRecording();
                        } else {
                          _stopRecording();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        _isRecording ? Color(0xFFE74C3C) : Color(0xFF50C878),
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(0),
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _isRecording ? l10n.recording : l10n.tapToRecord,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _isRecording
                        ? l10n.speakClearly
                        : l10n.iAmFeelingGoodToday,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Submit Button
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF50C878)],
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
                onPressed: _selectedMood != null ? () => _submitCheckIn(l10n) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.submitCheckIn,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startRecording() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.mic, color: Colors.white),
            SizedBox(width: 12),
            Text(l10n.recordingYourVoice),
          ],
        ),
        backgroundColor: Color(0xFFE74C3C),
        duration: Duration(seconds: 10),
      ),
    );
  }

  void _stopRecording() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.voiceRecordingSaved),
        backgroundColor: Color(0xFF50C878),
      ),
    );
  }

  void _submitCheckIn(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF50C878), size: 32),
            SizedBox(width: 12),
            Text(l10n.checkInComplete),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.yourHealthCheckInHasBeenRecorded,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              l10n.mood(_selectedMood!),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            SizedBox(height: 8),
            Text(
              l10n.yourFamilyHasBeenNotified,
              style: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D)),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4A90E2),
            ),
            child: Text(l10n.done, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
