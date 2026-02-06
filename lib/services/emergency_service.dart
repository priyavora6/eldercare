import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emergency_contact_model.dart';
import '../models/emergency_alert_model.dart';
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
      final contact = EmergencyContact(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        name: name,
        phoneNumber: phoneNumber,
        relationship: relationship,
        isPrimary: isPrimary,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('emergency_contacts')
          .doc(contact.id)
          .set(contact.toJson());
    } catch (e) {
      throw Exception('Failed to add emergency contact: $e');
    }
  }

  // Get all emergency contacts
  Stream<List<EmergencyContact>> getEmergencyContacts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('emergency_contacts')
        .orderBy('isPrimary', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) =>
        EmergencyContact.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  // Update emergency contact
  Future<void> updateEmergencyContact({
    required String userId,
    required String contactId,
    String? name,
    String? phoneNumber,
    String? relationship,
    bool? isPrimary,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (relationship != null) updates['relationship'] = relationship;
      if (isPrimary != null) updates['isPrimary'] = isPrimary;
      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('emergency_contacts')
          .doc(contactId)
          .update(updates);
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
          .collection('emergency_contacts')
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
      // Create alert record
      final alert = EmergencyAlert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        userName: userName,
        latitude: latitude,
        longitude: longitude,
        message: message ?? 'Emergency alert triggered!',
        timestamp: DateTime.now(),
        isResolved: false,
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('emergency_alerts')
          .doc(alert.id)
          .set(alert.toJson());

      // Get all emergency contacts
      final contactsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('emergency_contacts')
          .get();

      // Send notifications to all emergency contacts
      for (var doc in contactsSnapshot.docs) {
        final contact =
        EmergencyContact.fromJson(doc.data() as Map<String, dynamic>);

        // Send SMS/notification to emergency contact
        await _notificationService.sendEmergencyNotification(
          contactPhone: contact.phoneNumber,
          userName: userName,
          latitude: latitude,
          longitude: longitude,
          message: alert.message,
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
  Future<void> resolveEmergencyAlert(String userId, String alertId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('emergency_alerts')
          .doc(alertId)
          .update({
        'isResolved': true,
        'resolvedAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('users').doc(userId).update({
        'inEmergency': false,
      });
    } catch (e) {
      throw Exception('Failed to resolve emergency alert: $e');
    }
  }

  // Get emergency alerts
  Stream<List<EmergencyAlert>> getEmergencyAlerts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('emergency_alerts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) =>
        EmergencyAlert.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
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