import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Link family member to elderly user
  Future<void> linkFamilyMember({
    required String elderlyUserId,
    required String familyUserId,
    required String relationship,
  }) async {
    try {
      // Add family member to elderly user's family list
      await _firestore
          .collection('users')
          .doc(elderlyUserId)
          .collection('family_members')
          .doc(familyUserId)
          .set({
        'userId': familyUserId,
        'relationship': relationship,
        'linkedAt': FieldValue.serverTimestamp(),
        'permissions': {
          'viewHealth': true,
          'viewLocation': true,
          'viewMedicines': true,
          'viewActivity': true,
        },
      });

      // Add elderly user to family member's linked users
      await _firestore
          .collection('users')
          .doc(familyUserId)
          .collection('linked_elderly')
          .doc(elderlyUserId)
          .set({
        'userId': elderlyUserId,
        'relationship': relationship,
        'linkedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to link family member: $e');
    }
  }

  // Unlink family member
  Future<void> unlinkFamilyMember({
    required String elderlyUserId,
    required String familyUserId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(elderlyUserId)
          .collection('family_members')
          .doc(familyUserId)
          .delete();

      await _firestore
          .collection('users')
          .doc(familyUserId)
          .collection('linked_elderly')
          .doc(elderlyUserId)
          .delete();
    } catch (e) {
      throw Exception('Failed to unlink family member: $e');
    }
  }

  // Get family members for elderly user
  Stream<List<Map<String, dynamic>>> getFamilyMembers(String elderlyUserId) {
    return _firestore
        .collection('users')
        .doc(elderlyUserId)
        .collection('family_members')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> familyMembers = [];

      for (var doc in snapshot.docs) {
        final familyData = doc.data();
        final userId = familyData['userId'];

        // Get user details
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          familyMembers.add({
            ...familyData,
            'name': userDoc.data()?['name'] ?? 'Unknown',
            'email': userDoc.data()?['email'] ?? '',
            'phone': userDoc.data()?['phone'] ?? '',
            'photoUrl': userDoc.data()?['photoUrl'],
          });
        }
      }

      return familyMembers;
    });
  }

  // Get linked elderly users for family member
  Stream<List<Map<String, dynamic>>> getLinkedElderlyUsers(
      String familyUserId) {
    return _firestore
        .collection('users')
        .doc(familyUserId)
        .collection('linked_elderly')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> elderlyUsers = [];

      for (var doc in snapshot.docs) {
        final linkedData = doc.data();
        final userId = linkedData['userId'];

        // Get user details
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          elderlyUsers.add({
            ...linkedData,
            'name': userDoc.data()?['name'] ?? 'Unknown',
            'email': userDoc.data()?['email'] ?? '',
            'phone': userDoc.data()?['phone'] ?? '',
            'photoUrl': userDoc.data()?['photoUrl'],
            'location': userDoc.data()?['location'],
            'inEmergency': userDoc.data()?['inEmergency'] ?? false,
          });
        }
      }

      return elderlyUsers;
    });
  }

  // Update family member permissions
  Future<void> updateFamilyPermissions({
    required String elderlyUserId,
    required String familyUserId,
    required Map<String, bool> permissions,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(elderlyUserId)
          .collection('family_members')
          .doc(familyUserId)
          .update({
        'permissions': permissions,
        'permissionsUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update permissions: $e');
    }
  }

  // Get elderly user's activity logs (for family members)
  Future<List<Map<String, dynamic>>> getElderlyActivityLogs(
      String elderlyUserId, {
        int limit = 50,
      }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(elderlyUserId)
          .collection('activity_logs')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to get activity logs: $e');
    }
  }

  // Get elderly user's health summary (for family members)
  Future<Map<String, dynamic>> getElderlyHealthSummary(
      String elderlyUserId) async {
    try {
      // Get latest health check-in
      final healthSnapshot = await _firestore
          .collection('users')
          .doc(elderlyUserId)
          .collection('health_checkins')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      // Get medicine compliance
      final medicineSnapshot = await _firestore
          .collection('users')
          .doc(elderlyUserId)
          .collection('medicines')
          .where('isActive', isEqualTo: true)
          .get();

      // Get recent activity count
      final activitySnapshot = await _firestore
          .collection('users')
          .doc(elderlyUserId)
          .collection('activity_logs')
          .where('timestamp',
          isGreaterThan: DateTime.now().subtract(Duration(days: 7)))
          .get();

      return {
        'latestHealthCheckIn': healthSnapshot.docs.isNotEmpty
            ? healthSnapshot.docs.first.data()
            : null,
        'activeMedicines': medicineSnapshot.docs.length,
        'recentActivityCount': activitySnapshot.docs.length,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw Exception('Failed to get health summary: $e');
    }
  }

  // Send notification to family members
  Future<void> notifyFamilyMembers({
    required String elderlyUserId,
    required String title,
    required String message,
    String? type,
  }) async {
    try {
      final familySnapshot = await _firestore
          .collection('users')
          .doc(elderlyUserId)
          .collection('family_members')
          .get();

      for (var doc in familySnapshot.docs) {
        final familyUserId = doc.data()['userId'];

        // Create notification in family member's notifications collection
        await _firestore
            .collection('users')
            .doc(familyUserId)
            .collection('notifications')
            .add({
          'title': title,
          'message': message,
          'type': type ?? 'general',
          'elderlyUserId': elderlyUserId,
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }
    } catch (e) {
      throw Exception('Failed to notify family members: $e');
    }
  }

  // Generate family access code for linking
  Future<String> generateFamilyAccessCode(String elderlyUserId) async {
    try {
      // Generate 6-digit code
      final code = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000))
          .toString();

      await _firestore.collection('family_access_codes').doc(code).set({
        'elderlyUserId': elderlyUserId,
        'code': code,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': DateTime.now().add(Duration(hours: 24)),
        'isUsed': false,
      });

      return code;
    } catch (e) {
      throw Exception('Failed to generate access code: $e');
    }
  }

  // Validate and use family access code
  Future<String?> validateFamilyAccessCode(String code) async {
    try {
      final codeDoc =
      await _firestore.collection('family_access_codes').doc(code).get();

      if (!codeDoc.exists) return null;

      final data = codeDoc.data()!;
      final expiresAt = (data['expiresAt'] as Timestamp).toDate();
      final isUsed = data['isUsed'] as bool;

      if (isUsed || DateTime.now().isAfter(expiresAt)) {
        return null;
      }

      // Mark code as used
      await _firestore.collection('family_access_codes').doc(code).update({
        'isUsed': true,
        'usedAt': FieldValue.serverTimestamp(),
      });

      return data['elderlyUserId'];
    } catch (e) {
      throw Exception('Failed to validate access code: $e');
    }
  }
}