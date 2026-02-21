
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Aliased
import 'package:eldercare/services/auth_service.dart';
import 'package:eldercare/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;
  String? get currentUserId => _currentUser?.accountInfo.userId;
  String? get userType => _currentUser?.accountInfo.userType;

  AuthProvider() {
    _initAuth();
  }

  void _initAuth() {
    _authService.authStateChanges.listen((firebase_auth.User? user) async {
      if (user != null) {
        // If a user is logged in, fetch their data.
        _currentUser = await _authService.getUserData(user.uid);
        notifyListeners();
      } else {
        // If no user is logged in, clear the current user data.
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  // Sign up a new user with their email and other details.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String userType,
    required DateTime dateOfBirth,
    required String gender,
    File? profileImage,
    String? linkedElderlyId,
    String? relationshipType,
    String? bloodGroup,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        userType: userType,
        dateOfBirth: dateOfBirth,
        gender: gender,
        profileImage: profileImage,
        linkedElderlyId: linkedElderlyId,
        relationshipType: relationshipType,
        bloodGroup: bloodGroup,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update the current user's profile information.
  Future<bool> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? bloodGroup,
    Map<String, dynamic>? address,
    File? profileImage,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await _authService.updateUserProfile(
        userId: _currentUser!.accountInfo.userId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        bloodGroup: bloodGroup,
        address: address,
        profileImage: profileImage,
      );

      // After updating, refresh the user data to reflect the changes.
      await refreshUserData();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Log in an existing user.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.loginWithEmail(
        email: email,
        password: password,
      );
      // Save credentials for biometric login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('biometric_email', email);
      await prefs.setString('biometric_password', password);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Biometric Login
  Future<bool> biometricLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('biometric_email');
    final password = prefs.getString('biometric_password');

    if (email != null && password != null) {
      return await login(email: email, password: password);
    }
    return false;
  }

  // Sync Google User
  Future<void> syncGoogleUser(firebase_auth.User user) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _authService.findOrCreateUser(user);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Log out the current user.
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    // Clear biometric credentials on logout
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('biometric_email');
    await prefs.remove('biometric_password');
    notifyListeners();
  }

  // Refresh the current user's data from Firestore.
  Future<void> refreshUserData() async {
    if (_currentUser != null) {
      _currentUser = await _authService.getUserData(_currentUser!.accountInfo.userId);
      notifyListeners();
    }
  }
}
