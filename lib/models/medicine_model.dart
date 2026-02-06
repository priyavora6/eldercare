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
  final String notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicineModel({
    required this.medicineId,
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.scheduleTime,
    required this.startDate,
    this.endDate,
    required this.prescriptionImageUrl,
    required this.notes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      medicineId: json['medicineId'] ?? '',
      medicineName: json['medicineName'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      scheduleTime: List<String>.from(json['scheduleTime'] ?? []),
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] != null ? (json['endDate'] as Timestamp).toDate() : null,
      prescriptionImageUrl: json['prescriptionImageUrl'] ?? '',
      notes: json['notes'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
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
      'notes': notes,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}