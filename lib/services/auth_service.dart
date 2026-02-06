import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel> getUserData(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return UserModel.fromFirestore(doc.data() as Map<String, dynamic>);
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
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;

    if (user != null) {
      String? profileImageUrl;
      if (profileImage != null) {
        profileImageUrl = await _uploadProfileImage(user.uid, profileImage);
      }

      UserModel newUser = UserModel(
        accountInfo: AccountInfo(
          userId: user.uid,
          email: email,
          userType: userType,
        ),
        personalInfo: PersonalInfo(
          fullName: fullName,
          dateOfBirth: dateOfBirth,
          gender: gender,
          profileImageUrl: profileImageUrl,
        ),
        contactInfo: ContactInfo(phoneNumber: phoneNumber, address: {}),
        healthInfo: HealthInfo(bloodGroup: bloodGroup, allergies: [], medicalHistory: 'N/A'),
        familyLink: userType == 'Family'
            ? FamilyLink(
                linkedElderlyId: linkedElderlyId,
                relationshipType: relationshipType,
              )
            : null,
      );

      await _firestore.collection('users').doc(user.uid).set(newUser.toFirestore());
      return newUser;
    }
    throw Exception('Sign up failed');
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

  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return await getUserData(userCredential.user!.uid);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<String> _uploadProfileImage(String userId, File image) async {
    Reference ref = _storage.ref().child('profile_images').child(userId);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
