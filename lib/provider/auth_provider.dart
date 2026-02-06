import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eldercare/services/auth_service.dart';
import 'package:eldercare/models/user_model.dart';

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
    _authService.authStateChanges.listen((User? user) async {
      if (user != null) {
        _currentUser = await _authService.getUserData(user.uid);
        notifyListeners();
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  // Sign up with image
  Future<bool> signUpWithImage({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String userType,
    required DateTime dateOfBirth,
    required String gender,
    File? profileImage, // NEW
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
        profileImage: profileImage, // Pass image
        linkedElderlyId: linkedElderlyId,
        relationshipType: relationshipType,
        bloodGroup: bloodGroup,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update profile
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

      await refreshUserData();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

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

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> refreshUserData() async {
    if (_currentUser != null) {
      _currentUser = await _authService.getUserData(_currentUser!.accountInfo.userId);
      notifyListeners();
    }
  }
}
