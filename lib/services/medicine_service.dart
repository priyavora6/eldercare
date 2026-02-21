import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/medicine_model.dart';

class MedicineService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================
  // ADD MEDICINE
  // ============================================
  Future<String> addMedicine({
    required String userId,
    required String medicineName,
    required String dosage,
    required String frequency,
    required List<String> scheduleTime,
    required DateTime startDate,
    DateTime? endDate,
    String? prescriptionImageUrl,
    String? notes,
  }) async {
    try {
      DocumentReference medicineRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .doc();

      String medicineId = medicineRef.id;

      await medicineRef.set({
        'medicineId': medicineId,
        'medicineName': medicineName,
        'dosage': dosage,
        'frequency': frequency,
        'scheduleTime': scheduleTime,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': endDate != null ? Timestamp.fromDate(endDate) : null,
        'prescriptionImageUrl': prescriptionImageUrl ?? '',
        'notes': notes ?? '',
        'isActive': true,
        'isTaken': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _logActivity(
        userId: userId,
        activityType: 'medicineAdded',
        activityDescription: 'Added medicine: $medicineName',
        metadata: {'medicineId': medicineId},
      );

      return medicineId;
    } catch (e) {
      debugPrint('Error adding medicine: $e');
      throw Exception('Failed to add medicine');
    }
  }

  // ============================================
  // GET USER MEDICINES
  // ============================================
  Future<List<MedicineModel>> getUserMedicines(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        return MedicineModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint('Error getting medicines: $e');
      throw Exception('Failed to get medicines');
    }
  }

  // ============================================
  // GET ACTIVE MEDICINES
  // ============================================
  Future<List<MedicineModel>> getActiveMedicines(String userId) async {
    try {
      final now = DateTime.now();
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .where('isActive', isEqualTo: true)
          .get();

      List<MedicineModel> medicines = [];
      for (var doc in snapshot.docs) {
        final medicine = MedicineModel.fromJson(doc.data() as Map<String, dynamic>);
        if (medicine.endDate == null || medicine.endDate!.isAfter(now)) {
          medicines.add(medicine);
        }
      }
      return medicines;
    } catch (e) {
      debugPrint('Error getting active medicines: $e');
      throw Exception('Failed to get active medicines');
    }
  }

  // ============================================
  // GET MEDICINE BY ID
  // ============================================
  Future<MedicineModel?> getMedicineById({
    required String userId,
    required String medicineId,
  }) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .doc(medicineId)
          .get();

      if (doc.exists) {
        return MedicineModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting medicine by ID: $e');
      return null;
    }
  }

  // ============================================
  // UPDATE MEDICINE
  // ============================================
  Future<void> updateMedicine({
    required String userId,
    required String medicineId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .doc(medicineId)
          .update(updates);

      await _logActivity(
        userId: userId,
        activityType: 'medicineUpdated',
        activityDescription: 'Updated medicine',
        metadata: {'medicineId': medicineId},
      );
    } catch (e) {
      debugPrint('Error updating medicine: $e');
      throw Exception('Failed to update medicine');
    }
  }

  // ============================================
  // DELETE MEDICINE (Soft delete)
  // ============================================
  Future<void> deleteMedicine(String userId, String medicineId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .doc(medicineId)
          .update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _logActivity(
        userId: userId,
        activityType: 'medicineDeleted',
        activityDescription: 'Deleted medicine',
        metadata: {'medicineId': medicineId},
      );
    } catch (e) {
      debugPrint('Error deleting medicine: $e');
      throw Exception('Failed to delete medicine');
    }
  }

  // ============================================
  // GET TODAY'S MEDICINES — FIX: marks isTaken correctly
  // ============================================
  Future<List<MedicineModel>> getTodaysMedicines(String userId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Step 1: Get all active medicines
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .where('isActive', isEqualTo: true)
          .get();

      // Step 2: Get today's taken log
      final logSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicineLog')
          .where('status', isEqualTo: 'taken')
          .where('scheduledTime',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('scheduledTime',
          isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      // Step 3: Build set of taken medicine IDs today
      final takenIds = logSnapshot.docs
          .map((doc) => (doc.data())['medicineId'] as String)
          .toSet();

      // Step 4: Build medicine list and mark isTaken
      final List<MedicineModel> todaysMedicines = [];
      for (var doc in snapshot.docs) {
        final medicine = MedicineModel.fromJson(doc.data() as Map<String, dynamic>);
        if (_shouldTakeMedicineToday(medicine, now)) {
          medicine.isTaken = takenIds.contains(medicine.medicineId);
          todaysMedicines.add(medicine);
        }
      }

      // Sort: not taken first, taken last
      todaysMedicines.sort((a, b) {
        if (a.isTaken == b.isTaken) return 0;
        return (a.isTaken == true) ? 1 : -1;
      });

      return todaysMedicines;
    } catch (e) {
      debugPrint('Error getting today\'s medicines: $e');
      throw Exception('Failed to get today\'s medicines');
    }
  }

  bool _shouldTakeMedicineToday(MedicineModel medicine, DateTime today) {
    if (medicine.endDate != null && medicine.endDate!.isBefore(today)) {
      return false;
    }
    switch (medicine.frequency.toLowerCase()) {
      case 'daily': return true;
      case 'weekly': return true;
      case 'asneeded': return false;
      default: return true;
    }
  }

  // ============================================
  // LOG MEDICINE TAKEN
  // ============================================
  Future<void> logMedicineTaken({
    required String userId,
    required String medicineId,
    required String medicineName,
    required DateTime scheduledTime,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicineLog')
          .add({
        'medicineId': medicineId,
        'medicineName': medicineName,
        'scheduledTime': Timestamp.fromDate(scheduledTime),
        'takenAt': FieldValue.serverTimestamp(),
        'status': 'taken',
        'notificationSent': true,
        'familyAlertSent': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _logActivity(
        userId: userId,
        activityType: 'medicineTaken',
        activityDescription: 'Took medicine: $medicineName',
        metadata: {'medicineId': medicineId},
      );
    } catch (e) {
      debugPrint('Error logging medicine taken: $e');
      throw Exception('Failed to log medicine taken');
    }
  }

  // ============================================
  // LOG MEDICINE SKIPPED
  // ============================================
  Future<void> logMedicineSkipped({
    required String userId,
    required String medicineId,
    required String medicineName,
    required DateTime scheduledTime,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicineLog')
          .add({
        'medicineId': medicineId,
        'medicineName': medicineName,
        'scheduledTime': Timestamp.fromDate(scheduledTime),
        'takenAt': null,
        'status': 'skipped',
        'notificationSent': true,
        'familyAlertSent': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _notifyFamilyMedicineMissed(userId, medicineName);
      await _logActivity(
        userId: userId,
        activityType: 'medicineSkipped',
        activityDescription: 'Skipped medicine: $medicineName',
        metadata: {'medicineId': medicineId},
      );
    } catch (e) {
      debugPrint('Error logging medicine skipped: $e');
      throw Exception('Failed to log medicine skipped');
    }
  }

  // ============================================
  // LOG MEDICINE MISSED
  // ============================================
  Future<void> logMedicineMissed({
    required String userId,
    required String medicineId,
    required String medicineName,
    required DateTime scheduledTime,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicineLog')
          .add({
        'medicineId': medicineId,
        'medicineName': medicineName,
        'scheduledTime': Timestamp.fromDate(scheduledTime),
        'takenAt': null,
        'status': 'missed',
        'notificationSent': true,
        'familyAlertSent': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _notifyFamilyMedicineMissed(userId, medicineName);
    } catch (e) {
      debugPrint('Error logging medicine missed: $e');
      throw Exception('Failed to log medicine missed');
    }
  }

  // ============================================
  // GET MEDICINE LOG (History)
  // ============================================
  Future<List<Map<String, dynamic>>> getMedicineLog({
    required String userId,
    int? limit,
  }) async {
    try {
      Query query = _firestore
          .collection('users')
          .doc(userId)
          .collection('medicineLog')
          .orderBy('createdAt', descending: true);

      if (limit != null) query = query.limit(limit);

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint('Error getting medicine log: $e');
      throw Exception('Failed to get medicine log');
    }
  }

  // ============================================
  // GET MEDICINE ADHERENCE (Percentage)
  // ============================================
  Future<double> getMedicineAdherence({
    required String userId,
    int days = 7,
  }) async {
    try {
      final startDate = DateTime.now().subtract(Duration(days: days));
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicineLog')
          .where('scheduledTime',
          isGreaterThan: Timestamp.fromDate(startDate))
          .get();

      if (snapshot.docs.isEmpty) return 100.0;

      final total = snapshot.docs.length;
      final taken = snapshot.docs
          .where((doc) => (doc.data())['status'] == 'taken')
          .length;

      return (taken / total) * 100;
    } catch (e) {
      debugPrint('Error calculating adherence: $e');
      return 0.0;
    }
  }

  // ============================================
  // GET MISSED MEDICINES COUNT
  // ============================================
  Future<int> getMissedMedicinesCount({
    required String userId,
    int days = 7,
  }) async {
    try {
      final startDate = DateTime.now().subtract(Duration(days: days));
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicineLog')
          .where('scheduledTime',
          isGreaterThan: Timestamp.fromDate(startDate))
          .where('status', isEqualTo: 'missed')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      debugPrint('Error getting missed medicines count: $e');
      return 0;
    }
  }

  // ============================================
  // NOTIFY FAMILY - MEDICINE MISSED
  // ============================================
  Future<void> _notifyFamilyMedicineMissed(
      String userId, String medicineName) async {
    try {
      final userDoc =
      await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return;

      final userData = userDoc.data() as Map<String, dynamic>;
      final familyMembers = List<String>.from(
          userData['familyLinks']?['linkedFamilyMembers'] ?? []);

      for (String familyId in familyMembers) {
        await _firestore.collection('notifications').add({
          'recipientId': familyId,
          'senderId': userId,
          'type': 'medicine',
          'title': 'Medicine Missed Alert',
          'body': 'Your loved one missed their medicine: $medicineName',
          'priority': 'high',
          'sentAt': FieldValue.serverTimestamp(),
          'isRead': false,
          'metadata': {'userId': userId, 'medicineName': medicineName},
        });
      }
    } catch (e) {
      debugPrint('Error notifying family: $e');
    }
  }

  // ============================================
  // LOG ACTIVITY
  // ============================================
  Future<void> _logActivity({
    required String userId,
    required String activityType,
    required String activityDescription,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('activityLog')
          .add({
        'activityType': activityType,
        'activityDescription': activityDescription,
        'timestamp': FieldValue.serverTimestamp(),
        'metadata': metadata ?? {},
        'duration': null,
      });
    } catch (e) {
      debugPrint('Error logging activity: $e');
    }
  }

  // ============================================
  // STREAM MEDICINES (Real-time updates)
  // ============================================
  Stream<List<MedicineModel>> streamUserMedicines(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('medicines')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MedicineModel.fromJson(doc.data()))
        .toList());
  }

  // ============================================
  // SEARCH MEDICINES
  // ============================================
  Future<List<MedicineModel>> searchMedicines({
    required String userId,
    required String query,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) =>
          MedicineModel.fromJson(doc.data() as Map<String, dynamic>))
          .where((m) =>
          m.medicineName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint('Error searching medicines: $e');
      throw Exception('Failed to search medicines');
    }
  }
}