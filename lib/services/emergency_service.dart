import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact_model.dart';
import 'notification_service.dart';

class EmergencyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  // Add emergency contact
  Future<void> addEmergencyContact({
    required String userId,
    required String name,
    required String phoneNumber,
    required String relationship,
    bool isPrimary = false,
  }) async {
    try {
      final contact = Contact(
        name: name,
        phone: phoneNumber,
        relationship: relationship,
        isPrimary: isPrimary,
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .add(contact.toFirestore());
    } catch (e) {
      throw Exception('Failed to add emergency contact: $e');
    }
  }

  // Get all emergency contacts
  Stream<List<Contact>> getEmergencyContacts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Contact.fromFirestore(doc))
            .toList());
  }

  // Update emergency contact
  Future<void> updateEmergencyContact({
    required String userId,
    required Contact contact,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .doc(contact.id)
          .update(contact.toFirestore());
    } catch (e) {
      throw Exception('Failed to update emergency contact: $e');
    }
  }

  // Delete emergency contact
  Future<void> deleteEmergencyContact(String userId, String contactId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .doc(contactId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete emergency contact: $e');
    }
  }

  // Trigger emergency alert
  Future<void> triggerEmergencyAlert({
    required String userId,
    required String userName,
    required double latitude,
    required double longitude,
    String? message,
  }) async {
    try {
      // Get all emergency contacts
      final contactsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .get();

      // Send notifications to all emergency contacts
      for (var doc in contactsSnapshot.docs) {
        final contact = Contact.fromFirestore(doc);

        // Send SMS/notification to emergency contact
        await _notificationService.sendEmergencyNotification(
          contactPhone: contact.phone,
          userName: userName,
          latitude: latitude,
          longitude: longitude,
          message: message ?? 'Emergency alert triggered!',
        );
      }

      // Update user's emergency status
      await _firestore.collection('users').doc(userId).update({
        'inEmergency': true,
        'lastEmergencyAlert': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to trigger emergency alert: $e');
    }
  }

  // Resolve emergency alert
  Future<void> resolveEmergencyAlert(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'inEmergency': false,
      });
    } catch (e) {
      throw Exception('Failed to resolve emergency alert: $e');
    }
  }

  // Check if user is in emergency
  Future<bool> isUserInEmergency(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.data()?['inEmergency'] ?? false;
    } catch (e) {
      return false;
    }
  }
}
