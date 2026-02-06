import 'package:flutter/material.dart';

class VideoCall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C3E50), // Dark background for video call
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Video Call with Priya', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          // Remote video stream (placeholder)
          Center(
            child: Container(
              color: Colors.black,
              child: Center(
                  child: Icon(Icons.videocam, color: Colors.white, size: 100)),
            ),
          ),
          // Local video stream (placeholder)
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(child: Icon(Icons.person, color: Colors.white, size: 50)),
            ),
          ),
          // Call controls
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCallControlButton(
                  icon: Icons.mic_off,
                  color: Colors.white,
                  onPressed: () {},
                ),
                _buildCallControlButton(
                  icon: Icons.call_end,
                  color: Colors.red,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                _buildCallControlButton(
                  icon: Icons.videocam_off,
                  color: Colors.white,
                  onPressed: () {},
                ),
                _buildCallControlButton(
                  icon: Icons.volume_up,
                  color: Colors.white,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: color,
      child: Icon(icon, color: color == Colors.white ? Colors.black : Colors.white),
      elevation: 2,
      heroTag: null, // Avoid hero tag conflicts
    );
  }
}
