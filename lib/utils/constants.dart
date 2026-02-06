import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'ElderCare';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Your AI Companion for Elderly Care';

  // Firebase Collection Names
  static const String usersCollection = 'users';
  static const String medicinesCollection = 'medicines';
  static const String healthCheckinsCollection = 'health_checkins';
  static const String emergencyContactsCollection = 'emergency_contacts';
  static const String emergencyAlertsCollection = 'emergency_alerts';
  static const String activityLogsCollection = 'activity_logs';
  static const String chatConversationsCollection = 'chat_conversations';
  static const String chatMessagesCollection = 'chat_messages';
  static const String familyMembersCollection = 'family_members';

  // User Roles
  static const String roleElderly = 'elderly';
  static const String roleFamily = 'family';

  // AI Providers
  static const String aiProviderGemini = 'gemini';
  static const String aiProviderHuggingFace = 'huggingface';
  static const String aiProviderCohere = 'cohere';

  // Supported Languages
  static const String languageEnglish = 'en';
  static const String languageHindi = 'hi';
  static const String languageGujarati = 'gu';

  static const Map<String, String> supportedLanguages = {
    languageEnglish: 'English',
    languageHindi: 'हिंदी',
    languageGujarati: 'ગુજરાતી',
  };

  // Mood Options
  static const List<String> moodOptions = [
    'happy',
    'okay',
    'sad',
    'worried',
    'sick',
  ];

  static const Map<String, String> moodEmojis = {
    'happy': '😊',
    'okay': '😐',
    'sad': '😢',
    'worried': '😟',
    'sick': '🤒',
  };

  // Medicine Frequency
  static const String frequencyDaily = 'daily';
  static const String frequencyWeekly = 'weekly';
  static const String frequencyMonthly = 'monthly';
  static const String frequencyAsNeeded = 'as_needed';

  static const List<String> medicineFrequencies = [
    frequencyDaily,
    frequencyWeekly,
    frequencyMonthly,
    frequencyAsNeeded,
  ];

  // Relationship Types
  static const List<String> relationshipTypes = [
    'Son',
    'Daughter',
    'Spouse',
    'Sibling',
    'Friend',
    'Neighbor',
    'Caregiver',
    'Doctor',
    'Other',
  ];

  // Health Metrics Ranges
  static const double normalBPSystolicMin = 90;
  static const double normalBPSystolicMax = 140;
  static const double normalBPDiastolicMin = 60;
  static const double normalBPDiastolicMax = 90;
  static const double normalHeartRateMin = 60;
  static const double normalHeartRateMax = 100;
  static const double normalTemperatureMin = 36.1;
  static const double normalTemperatureMax = 37.2;
  static const double normalBloodSugarMin = 70;
  static const double normalBloodSugarMax = 100;

  // Time Constants
  static const int medicineReminderMinutesBefore = 5;
  static const int emergencyAlertTimeoutMinutes = 30;
  static const int sessionTimeoutMinutes = 30;
  static const int maxChatHistoryDays = 30;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double avatarSize = 80.0;

  // Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color accentColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color infoColor = Color(0xFF2196F3);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // API Endpoints (if needed)
  static const String baseUrl = 'https://api.eldercare.com';
  static const String geminiApiUrl = 'https://generativelanguage.googleapis.com';
  static const String huggingFaceApiUrl = 'https://api-inference.huggingface.co';
  static const String cohereApiUrl = 'https://api.cohere.ai';

  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int phoneNumberLength = 10;
  static const int otpLength = 6;

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection. Please check your network.';
  static const String errorTimeout = 'Request timed out. Please try again.';
  static const String errorPermissionDenied = 'Permission denied.';
  static const String errorInvalidCredentials = 'Invalid email or password.';
  static const String errorUserNotFound = 'User not found.';
  static const String errorEmailAlreadyExists = 'Email already exists.';

  // Success Messages
  static const String successLogin = 'Login successful!';
  static const String successSignup = 'Account created successfully!';
  static const String successLogout = 'Logged out successfully!';
  static const String successProfileUpdate = 'Profile updated successfully!';
  static const String successMedicineAdded = 'Medicine added successfully!';
  static const String successHealthCheckIn = 'Health check-in submitted!';
  static const String successEmergencyContactAdded = 'Emergency contact added!';

  // Shared Preferences Keys
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyLanguage = 'language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyLocationPermission = 'location_permission';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyAIProvider = 'ai_provider';

  // Notification Channel IDs
  static const String notificationChannelGeneral = 'general';
  static const String notificationChannelMedicine = 'medicine';
  static const String notificationChannelEmergency = 'emergency';
  static const String notificationChannelHealth = 'health';

  // Chat Message Types
  static const String messageTypeText = 'text';
  static const String messageTypeVoice = 'voice';
  static const String messageTypeImage = 'image';

  // Activity Types
  static const String activityHealthCheckIn = 'health_checkin';
  static const String activityMedicineTaken = 'medicine_taken';
  static const String activityMedicineMissed = 'medicine_missed';
  static const String activityEmergencyAlert = 'emergency_alert';
  static const String activityChat = 'chat';
  static const String activityLogin = 'login';
  static const String activityLogout = 'logout';
  static const String activityProfileUpdate = 'profile_update';

  // File Upload Limits
  static const int maxImageSizeMB = 5;
  static const int maxDocumentSizeMB = 10;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentFormats = ['pdf', 'doc', 'docx'];

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 1);
  static const Duration imageCacheDuration = Duration(days: 7);
}