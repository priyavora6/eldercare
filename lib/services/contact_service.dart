import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact_model.dart';

class ContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a stream of contacts for a specific user
  Stream<List<Contact>> getContacts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Contact.fromFirestore(doc)).toList();
    });
  }

  // Add a new contact
  Future<void> addContact(String userId, Contact contact) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .add(contact.toFirestore());
  }

  // Update an existing contact
  Future<void> updateContact(String userId, Contact contact) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .doc(contact.id)
        .update(contact.toFirestore());
  }

  // Delete a contact
  Future<void> deleteContact(String userId, String contactId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .doc(contactId)
        .delete();
  }
}
