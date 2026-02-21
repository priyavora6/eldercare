import 'package:flutter/material.dart';
import 'package:eldercare/widgets/translated_text.dart';

class HealthReports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: TranslatedText('Health Reports'),
      ),
      body: Center(
        child: TranslatedText('Health Reports Screen'),
      ),
    );
  }
}
