import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineModel {
  final String medicineId;
  final String medicineName;
  final String dosage;
  final String frequency;
  final List<String> scheduleTime;
  final DateTime startDate;
  final DateTime? endDate;
  final String prescriptionImageUrl;
  final String? notes;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // FIX: Added isTaken — tracks if taken today (not stored in Firestore, computed at runtime)
  bool? isTaken;

  MedicineModel({
    required this.medicineId,
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.scheduleTime,
    required this.startDate,
    this.endDate,
    required this.prescriptionImageUrl,
    this.notes,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.isTaken = false,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      medicineId: json['medicineId'] ?? '',
      medicineName: json['medicineName'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      scheduleTime: List<String>.from(json['scheduleTime'] ?? []),

      // FIX: safe timestamp parsing — won't crash if null
      startDate: json['startDate'] != null
          ? (json['startDate'] as Timestamp).toDate()
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? (json['endDate'] as Timestamp).toDate()
          : null,

      prescriptionImageUrl: json['prescriptionImageUrl'] ?? '',
      notes: json['notes'] ?? '',
      isActive: json['isActive'] ?? true,

      // FIX: createdAt/updatedAt can be null right after serverTimestamp() write
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,

      isTaken: json['isTaken'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineId': medicineId,
      'medicineName': medicineName,
      'dosage': dosage,
      'frequency': frequency,
      'scheduleTime': scheduleTime,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'prescriptionImageUrl': prescriptionImageUrl,
      'notes': notes ?? '',
      'isActive': isActive,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isTaken': isTaken ?? false,
    };
  }
}