import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel> getUserData(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return UserModel.fromFirestore(doc.data() as Map<String, dynamic>);
  }

  Future<UserModel> findOrCreateUser(firebase_auth.User user) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc.data()!);
    } else {
      final newUser = UserModel(
        accountInfo: AccountInfo(
          userId: user.uid,
          email: user.email ?? '',
          userType: 'Elderly', // Default to Elderly for Google Sign-In
        ),
        personalInfo: PersonalInfo(
          fullName: user.displayName ?? 'User',
          dateOfBirth: DateTime.now(), // Placeholder, consider asking for this
          gender: 'Other', // Placeholder
          profileImageUrl: user.photoURL,
        ),
        contactInfo: ContactInfo(phoneNumber: user.phoneNumber ?? '', address: {}),
        healthInfo: HealthInfo(allergies: [], medicalHistory: 'N/A'),
      );
      await _firestore.collection('users').doc(user.uid).set(newUser.toFirestore());
      return newUser;
    }
  }

  Future<UserModel> signUpWithEmail({
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
    firebase_auth.UserCredential userCredential =
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    firebase_auth.User? user = userCredential.user;

    if (user != null) {
      String? profileImageUrl;
      if (profileImage != null) {
        profileImageUrl = await _uploadProfileImage(user.uid, profileImage);
      }

      UserModel newUser = UserModel(
        accountInfo: AccountInfo(userId: user.uid, email: email, userType: userType),
        personalInfo: PersonalInfo(
          fullName: fullName,
          dateOfBirth: dateOfBirth,
          gender: gender,
          profileImageUrl: profileImageUrl,
        ),
        contactInfo: ContactInfo(phoneNumber: phoneNumber, address: {}),
        healthInfo: HealthInfo(bloodGroup: bloodGroup, allergies: [], medicalHistory: 'N/A'),
        familyLink: userType == 'Family'
            ? FamilyLink(linkedElderlyId: linkedElderlyId, relationshipType: relationshipType)
            : null,
      );

      await _firestore.collection('users').doc(user.uid).set(newUser.toFirestore());
      return newUser;
    }
    throw Exception('Sign up failed');
  }

  Future<UserModel> loginWithEmail({required String email, required String password}) async {
    firebase_auth.UserCredential userCredential =
    await _auth.signInWithEmailAndPassword(email: email, password: password);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_email', email);
    await prefs.setString('saved_password', password);

    return await getUserData(userCredential.user!.uid);
  }

  Future<UserModel?> biometricLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('saved_email');
      final savedPassword = prefs.getString('saved_password');
      if (savedEmail == null || savedPassword == null) return null;
      return await loginWithEmail(email: savedEmail, password: savedPassword);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? bloodGroup,
    Map<String, dynamic>? address,
    File? profileImage,
  }) async {
    String? profileImageUrl;
    if (profileImage != null) {
      profileImageUrl = await _uploadProfileImage(userId, profileImage);
    }

    Map<String, dynamic> dataToUpdate = {};
    if (fullName != null) dataToUpdate['personal_info.full_name'] = fullName;
    if (phoneNumber != null) dataToUpdate['contact_info.phone_number'] = phoneNumber;
    if (bloodGroup != null) dataToUpdate['health_info.blood_group'] = bloodGroup;
    if (address != null) dataToUpdate['contact_info.address'] = address;
    if (profileImageUrl != null) dataToUpdate['personal_info.profile_image_url'] = profileImageUrl;

    if (dataToUpdate.isNotEmpty) {
      await _firestore.collection('users').doc(userId).update(dataToUpdate);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_email');
    await prefs.remove('saved_password');
  }

  Future<String> _uploadProfileImage(String userId, File image) async {
    Reference ref = _storage.ref().child('profile_images').child(userId);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
