import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String? id;
  final String name;
  final String phone;
  final String relationship;
  final bool isPrimary;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.relationship,
    this.isPrimary = false,
  });

  // Factory constructor to create a Contact from a Firestore document
  factory Contact.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Contact(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      relationship: data['relationship'] ?? '',
      isPrimary: data['isPrimary'] ?? false,
    );
  }

  // Method to convert a Contact to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'relationship': relationship,
      'isPrimary': isPrimary,
    };
  }
}
