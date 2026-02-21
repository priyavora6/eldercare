import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eldercare/provider/language_provider.dart';
import 'package:eldercare/widgets/translated_text.dart';

class FamilyDashboard extends StatefulWidget {
  @override
  _FamilyDashboardState createState() => _FamilyDashboardState();
}

class _FamilyDashboardState extends State<FamilyDashboard> {
  String _title = 'Family Dashboard';
  String _body = 'Family Dashboard Screen';

  @override
  void initState() {
    super.initState();
    _translateAll();
  }

  Future<void> _translateAll() async {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final translatedTitle = await langProvider.translate('Family Dashboard');
    final translatedBody = await langProvider.translate('Family Dashboard Screen');
    if (mounted) {
      setState(() {
        _title = translatedTitle;
        _body = translatedBody;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: Text(_body),
      ),
    );
  }
}
