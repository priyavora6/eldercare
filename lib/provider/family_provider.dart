import 'package:flutter/material.dart';

class FamilyProvider extends ChangeNotifier {
  // Add family dashboard state management
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

// Add methods as needed for family features
}