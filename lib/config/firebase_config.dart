import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: _getFirebaseOptions(),
    );
  }

  // Get Firebase options based on platform
  static FirebaseOptions _getFirebaseOptions() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidOptions;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _iosOptions;
    } else if (kIsWeb) {
      return _webOptions;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Android Firebase configuration
  static const FirebaseOptions _androidOptions = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    // Optional: Add these if you're using Realtime Database or Firebase ML
    // databaseURL: 'YOUR_DATABASE_URL',
    // iosBundleId: 'YOUR_IOS_BUNDLE_ID',
  );

  // iOS Firebase configuration
  static const FirebaseOptions _iosOptions = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosBundleId: 'YOUR_IOS_BUNDLE_ID',
    // Optional: Add these if you're using specific iOS features
    // iosClientId: 'YOUR_IOS_CLIENT_ID',
    // androidClientId: 'YOUR_ANDROID_CLIENT_ID',
  );

  // Web Firebase configuration
  static const FirebaseOptions _webOptions = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    authDomain: 'YOUR_AUTH_DOMAIN',
    // Optional: Add these if you're using specific web features
    // measurementId: 'YOUR_MEASUREMENT_ID',
  );

/*
   * IMPORTANT SETUP INSTRUCTIONS:
   *
   * 1. Create a Firebase project at https://console.firebase.google.com
   *
   * 2. For Android:
   *    - Add an Android app to your Firebase project
   *    - Download google-services.json
   *    - Place it in android/app/
   *    - Update the values in _androidOptions above
   *
   * 3. For iOS:
   *    - Add an iOS app to your Firebase project
   *    - Download GoogleService-Info.plist
   *    - Place it in ios/Runner/
   *    - Update the values in _iosOptions above
   *
   * 4. For Web:
   *    - Add a Web app to your Firebase project
   *    - Copy the Firebase SDK configuration
   *    - Update the values in _webOptions above
   *
   * 5. Enable required Firebase services in the console:
   *    - Authentication (Email/Password, Phone)
   *    - Firestore Database
   *    - Cloud Storage
   *    - Cloud Messaging (for notifications)
   *
   * 6. Set up Firestore security rules:
   *    ```
   *    rules_version = '2';
   *    service cloud.firestore {
   *      match /databases/{database}/documents {
   *        match /users/{userId} {
   *          allow read, write: if request.auth != null && request.auth.uid == userId;
   *
   *          match /{subcollection=**} {
   *            allow read, write: if request.auth != null && request.auth.uid == userId;
   *          }
   *        }
   *
   *        match /family_access_codes/{code} {
   *          allow read, write: if request.auth != null;
   *        }
   *      }
   *    }
   *    ```
   *
   * 7. Set up Cloud Storage security rules:
   *    ```
   *    rules_version = '2';
   *    service firebase.storage {
   *      match /b/{bucket}/o {
   *        match /users/{userId}/{allPaths=**} {
   *          allow read, write: if request.auth != null && request.auth.uid == userId;
   *        }
   *      }
   *    }
   *    ```
   */
}

// Firebase collection names (centralized for easy maintenance)
class FirebaseCollections {
  static const String users = 'users';
  static const String medicines = 'medicines';
  static const String healthCheckIns = 'health_checkins';
  static const String emergencyContacts = 'emergency_contacts';
  static const String emergencyAlerts = 'emergency_alerts';
  static const String activityLogs = 'activity_logs';
  static const String chatConversations = 'chat_conversations';
  static const String chatMessages = 'chat_messages';
  static const String familyMembers = 'family_members';
  static const String linkedElderly = 'linked_elderly';
  static const String familyAccessCodes = 'family_access_codes';
  static const String notifications = 'notifications';
  static const String locationHistory = 'location_history';
}

// Firebase field names (to prevent typos)
class FirebaseFields {
  // User fields
  static const String email = 'email';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String role = 'role';
  static const String photoUrl = 'photoUrl';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';

  // Common fields
  static const String id = 'id';
  static const String userId = 'userId';
  static const String timestamp = 'timestamp';
  static const String isActive = 'isActive';

  // Medicine fields
  static const String medicineName = 'medicineName';
  static const String dosage = 'dosage';
  static const String frequency = 'frequency';
  static const String reminderTimes = 'reminderTimes';

  // Health check-in fields
  static const String bloodPressureSystolic = 'bloodPressureSystolic';
  static const String bloodPressureDiastolic = 'bloodPressureDiastolic';
  static const String heartRate = 'heartRate';
  static const String temperature = 'temperature';
  static const String bloodSugar = 'bloodSugar';
  static const String mood = 'mood';

  // Emergency fields
  static const String inEmergency = 'inEmergency';
  static const String isResolved = 'isResolved';
  static const String isPrimary = 'isPrimary';

  // Location fields
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String location = 'location';
}