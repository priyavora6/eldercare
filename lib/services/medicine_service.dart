import 'package:cloud_firestore/cloud_firestore.dart';
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

      Map<String, dynamic> medicineData = {
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
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await medicineRef.set(medicineData);

      // Log activity
      await _logActivity(
        userId: userId,
        activityType: 'medicineAdded',
        activityDescription: 'Added medicine: $medicineName',
        metadata: {'medicineId': medicineId},
      );

      return medicineId;
    } catch (e) {
      print('Error adding medicine: $e');
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
          .orderBy('createdAt', descending: true)
          .get();

      List<MedicineModel> medicines = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        medicines.add(MedicineModel.fromJson(data));
      }

      return medicines;
    } catch (e) {
      print('Error getting medicines: $e');
      throw Exception('Failed to get medicines');
    }
  }

  // ============================================
  // GET ACTIVE MEDICINES
  // ============================================
  Future<List<MedicineModel>> getActiveMedicines(String userId) async {
    try {
      DateTime now = DateTime.now();

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .where('isActive', isEqualTo: true)
          .get();

      List<MedicineModel> medicines = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        MedicineModel medicine = MedicineModel.fromJson(data);

        // Check if medicine is still valid (not expired)
        if (medicine.endDate == null || medicine.endDate!.isAfter(now)) {
          medicines.add(medicine);
        }
      }

      return medicines;
    } catch (e) {
      print('Error getting active medicines: $e');
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
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return MedicineModel.fromJson(data);
      }

      return null;
    } catch (e) {
      print('Error getting medicine by ID: $e');
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

      // Log activity
      await _logActivity(
        userId: userId,
        activityType: 'medicineUpdated',
        activityDescription: 'Updated medicine',
        metadata: {'medicineId': medicineId},
      );
    } catch (e) {
      print('Error updating medicine: $e');
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

      // Log activity
      await _logActivity(
        userId: userId,
        activityType: 'medicineDeleted',
        activityDescription: 'Deleted medicine',
        metadata: {'medicineId': medicineId},
      );
    } catch (e) {
      print('Error deleting medicine: $e');
      throw Exception('Failed to delete medicine');
    }
  }

  // ============================================
  // GET TODAY'S MEDICINES
  // ============================================
  Future<List<MedicineModel>> getTodaysMedicines(String userId) async {
    try {
      DateTime now = DateTime.now();
      String currentHour = '${now.hour.toString().padLeft(2, '0')}:00';

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .where('isActive', isEqualTo: true)
          .get();

      List<MedicineModel> todaysMedicines = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        MedicineModel medicine = MedicineModel.fromJson(data);

        // Check if medicine should be taken today
        bool shouldTakeToday = _shouldTakeMedicineToday(medicine, now);

        if (shouldTakeToday) {
          todaysMedicines.add(medicine);
        }
      }

      return todaysMedicines;
    } catch (e) {
      print('Error getting today\'s medicines: $e');
      throw Exception('Failed to get today\'s medicines');
    }
  }

  // Helper: Check if medicine should be taken today
  bool _shouldTakeMedicineToday(MedicineModel medicine, DateTime today) {
    // Check if medicine is still valid
    if (medicine.endDate != null && medicine.endDate!.isBefore(today)) {
      return false;
    }

    // Check frequency
    switch (medicine.frequency.toLowerCase()) {
      case 'daily':
        return true;
      case 'weekly':
      // Check if today is the scheduled day (you can implement specific logic)
        return true;
      case 'asneeded':
        return false; // Only when user requests
      default:
        return true;
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
        'logId': _firestore
            .collection('users')
            .doc(userId)
            .collection('medicineLog')
            .doc()
            .id,
        'medicineId': medicineId,
        'medicineName': medicineName,
        'scheduledTime': Timestamp.fromDate(scheduledTime),
        'takenAt': FieldValue.serverTimestamp(),
        'status': 'taken',
        'notificationSent': true,
        'familyAlertSent': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Log activity
      await _logActivity(
        userId: userId,
        activityType: 'medicineTaken',
        activityDescription: 'Took medicine: $medicineName',
        metadata: {'medicineId': medicineId},
      );
    } catch (e) {
      print('Error logging medicine taken: $e');
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
        'logId': _firestore
            .collection('users')
            .doc(userId)
            .collection('medicineLog')
            .doc()
            .id,
        'medicineId': medicineId,
        'medicineName': medicineName,
        'scheduledTime': Timestamp.fromDate(scheduledTime),
        'takenAt': null,
        'status': 'skipped',
        'notificationSent': true,
        'familyAlertSent': true, // Alert family when skipped
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Send notification to family members
      await _notifyFamilyMedicineMissed(userId, medicineName);

      // Log activity
      await _logActivity(
        userId: userId,
        activityType: 'medicineSkipped',
        activityDescription: 'Skipped medicine: $medicineName',
        metadata: {'medicineId': medicineId},
      );
    } catch (e) {
      print('Error logging medicine skipped: $e');
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
        'logId': _firestore
            .collection('users')
            .doc(userId)
            .collection('medicineLog')
            .doc()
            .id,
        'medicineId': medicineId,
        'medicineName': medicineName,
        'scheduledTime': Timestamp.fromDate(scheduledTime),
        'takenAt': null,
        'status': 'missed',
        'notificationSent': true,
        'familyAlertSent': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Send notification to family members
      await _notifyFamilyMedicineMissed(userId, medicineName);
    } catch (e) {
      print('Error logging medicine missed: $e');
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

      if (limit != null) {
        query = query.limit(limit);
      }

      QuerySnapshot snapshot = await query.get();

      List<Map<String, dynamic>> logs = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        logs.add(data);
      }

      return logs;
    } catch (e) {
      print('Error getting medicine log: $e');
      throw Exception('Failed to get medicine log');
    }
  }

  // ============================================
  // GET MEDICINE ADHERENCE (Percentage)
  // ============================================
  Future<double> getMedicineAdherence({
    required String userId,
    int days = 7, // Last 7 days
  }) async {
    try {
      DateTime now = DateTime.now();
      DateTime startDate = now.subtract(Duration(days: days));

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicineLog')
          .where('scheduledTime', isGreaterThan: Timestamp.fromDate(startDate))
          .get();

      if (snapshot.docs.isEmpty) {
        return 100.0; // No scheduled medicines
      }

      int totalScheduled = snapshot.docs.length;
      int taken = 0;

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['status'] == 'taken') {
          taken++;
        }
      }

      double adherence = (taken / totalScheduled) * 100;
      return adherence;
    } catch (e) {
      print('Error calculating adherence: $e');
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
      DateTime now = DateTime.now();
      DateTime startDate = now.subtract(Duration(days: days));

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicineLog')
          .where('scheduledTime', isGreaterThan: Timestamp.fromDate(startDate))
          .where('status', isEqualTo: 'missed')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting missed medicines count: $e');
      return 0;
    }
  }

  // ============================================
  // NOTIFY FAMILY - MEDICINE MISSED
  // ============================================
  Future<void> _notifyFamilyMedicineMissed(
      String userId,
      String medicineName,
      ) async {
    try {
      // Get user data to find family members
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        List<String> familyMembers =
        List<String>.from(userData['familyLinks']?['linkedFamilyMembers'] ?? []);

        // Send notification to each family member
        for (String familyId in familyMembers) {
          await _firestore.collection('notifications').add({
            'notificationId': _firestore.collection('notifications').doc().id,
            'recipientId': familyId,
            'senderId': userId,
            'type': 'medicine',
            'title': 'Medicine Missed Alert',
            'body': 'Your loved one missed their medicine: $medicineName',
            'priority': 'high',
            'sentAt': FieldValue.serverTimestamp(),
            'readAt': null,
            'isRead': false,
            'actionUrl': null,
            'metadata': {
              'userId': userId,
              'medicineName': medicineName,
            },
          });
        }
      }
    } catch (e) {
      print('Error notifying family: $e');
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
        'activityId': _firestore
            .collection('users')
            .doc(userId)
            .collection('activityLog')
            .doc()
            .id,
        'activityType': activityType,
        'activityDescription': activityDescription,
        'timestamp': FieldValue.serverTimestamp(),
        'metadata': metadata ?? {},
        'duration': null,
      });
    } catch (e) {
      print('Error logging activity: $e');
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
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return MedicineModel.fromJson(data);
      }).toList();
    });
  }

  // ============================================
  // SEARCH MEDICINES
  // ============================================
  Future<List<MedicineModel>> searchMedicines({
    required String userId,
    required String query,
  }) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .where('isActive', isEqualTo: true)
          .get();

      List<MedicineModel> medicines = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        MedicineModel medicine = MedicineModel.fromJson(data);

        // Search in medicine name
        if (medicine.medicineName.toLowerCase().contains(query.toLowerCase())) {
          medicines.add(medicine);
        }
      }

      return medicines;
    } catch (e) {
      print('Error searching medicines: $e');
      throw Exception('Failed to search medicines');
    }
  }
}