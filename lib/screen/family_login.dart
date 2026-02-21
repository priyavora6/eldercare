import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eldercare/provider/language_provider.dart';
import 'package:eldercare/widgets/translated_text.dart';

class FamilyLogin extends StatefulWidget {
  @override
  _FamilyLoginState createState() => _FamilyLoginState();
}

class _FamilyLoginState extends State<FamilyLogin> {
  String _title = 'Family Login';
  String _body = 'Family Login Screen';

  @override
  void initState() {
    super.initState();
    _translateAll();
  }

  Future<void> _translateAll() async {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final translatedTitle = await langProvider.translate('Family Login');
    final translatedBody = await langProvider.translate('Family Login Screen');
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
