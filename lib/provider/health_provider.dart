import 'package:flutter/material.dart';

class HealthProvider extends ChangeNotifier {
  // Add health-related state management
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

// Add methods as needed for health check-ins
}