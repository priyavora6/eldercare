import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final AccountInfo accountInfo;
  final PersonalInfo personalInfo;
  final ContactInfo contactInfo;
  final HealthInfo healthInfo;
  final FamilyLink? familyLink; // Nullable for Elderly users

  UserModel({
    required this.accountInfo,
    required this.personalInfo,
    required this.contactInfo,
    required this.healthInfo,
    this.familyLink,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      accountInfo: AccountInfo.fromMap(data['account_info'] ?? {}),
      personalInfo: PersonalInfo.fromMap(data['personal_info'] ?? {}),
      contactInfo: ContactInfo.fromMap(data['contact_info'] ?? {}),
      healthInfo: HealthInfo.fromMap(data['health_info'] ?? {}),
      familyLink: data['family_link'] != null
          ? FamilyLink.fromMap(data['family_link'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'account_info': accountInfo.toMap(),
      'personal_info': personalInfo.toMap(),
      'contact_info': contactInfo.toMap(),
      'health_info': healthInfo.toMap(),
      if (familyLink != null) 'family_link': familyLink!.toMap(),
    };
  }
}

class AccountInfo {
  final String userId;
  final String email;
  final String userType; // 'Elderly' or 'Family'

  AccountInfo({
    required this.userId,
    required this.email,
    required this.userType,
  });

  factory AccountInfo.fromMap(Map<String, dynamic> map) {
    return AccountInfo(
      userId: map['user_id'] ?? '',
      email: map['email'] ?? '',
      userType: map['user_type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'email': email,
      'user_type': userType,
    };
  }
}

class PersonalInfo {
  final String fullName;
  final DateTime dateOfBirth;
  final String gender;
  final String? profileImageUrl;

  PersonalInfo({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    this.profileImageUrl,
  });

  factory PersonalInfo.fromMap(Map<String, dynamic> map) {
    return PersonalInfo(
      fullName: map['full_name'] ?? '',
      dateOfBirth: (map['date_of_birth'] as Timestamp).toDate(),
      gender: map['gender'] ?? '',
      profileImageUrl: map['profile_image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'date_of_birth': Timestamp.fromDate(dateOfBirth),
      'gender': gender,
      'profile_image_url': profileImageUrl,
    };
  }
}

class ContactInfo {
  final String phoneNumber;
  final Map<String, dynamic> address;

  ContactInfo({required this.phoneNumber, required this.address});

  factory ContactInfo.fromMap(Map<String, dynamic> map) {
    return ContactInfo(
      phoneNumber: map['phone_number'] ?? '',
      address: Map<String, dynamic>.from(map['address'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phone_number': phoneNumber,
      'address': address,
    };
  }
}

class HealthInfo {
  final String? bloodGroup;
  final List<String> allergies;
  final String medicalHistory;

  HealthInfo({
    this.bloodGroup,
    required this.allergies,
    required this.medicalHistory,
  });

  factory HealthInfo.fromMap(Map<String, dynamic> map) {
    return HealthInfo(
      bloodGroup: map['blood_group'],
      allergies: List<String>.from(map['allergies'] ?? []),
      medicalHistory: map['medical_history'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blood_group': bloodGroup,
      'allergies': allergies,
      'medical_history': medicalHistory,
    };
  }
}

class FamilyLink {
  final String? linkedElderlyId;
  final String? relationshipType;

  FamilyLink({this.linkedElderlyId, this.relationshipType});

  factory FamilyLink.fromMap(Map<String, dynamic> map) {
    return FamilyLink(
      linkedElderlyId: map['linked_elderly_id'],
      relationshipType: map['relationship_type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'linked_elderly_id': linkedElderlyId,
      'relationship_type': relationshipType,
    };
  }
}
