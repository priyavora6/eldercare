import 'package:flutter/material.dart';

class EmergencyProvider extends ChangeNotifier {
  // Add emergency-related state management
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

// Add methods as needed for emergency features
}