import 'package:flutter/material.dart';
import '../services/medicine_service.dart';
import '../models/medicine_model.dart';

class MedicineProvider extends ChangeNotifier {
  final MedicineService _medicineService = MedicineService();

  List<MedicineModel> _medicines = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MedicineModel> get medicines => _medicines;
  List<MedicineModel> get activeMedicines =>
      _medicines.where((m) => m.isActive).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMedicines(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _medicines = await _medicineService.getUserMedicines(userId);
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addMedicine({
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
    _isLoading = true;
    notifyListeners();

    try {
      await _medicineService.addMedicine(
        userId: userId,
        medicineName: medicineName,
        dosage: dosage,
        frequency: frequency,
        scheduleTime: scheduleTime,
        startDate: startDate,
        endDate: endDate,
        prescriptionImageUrl: prescriptionImageUrl,
        notes: notes,
      );

      await loadMedicines(userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateMedicine({
    required String userId,
    required String medicineId,
    required Map<String, dynamic> updates,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _medicineService.updateMedicine(
        userId: userId,
        medicineId: medicineId,
        updates: updates,
      );

      await loadMedicines(userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteMedicine(String userId, String medicineId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _medicineService.deleteMedicine(userId, medicineId);
      await loadMedicines(userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> markMedicineTaken({
    required String userId,
    required String medicineId,
    required String medicineName,
    required DateTime scheduledTime,
  }) async {
    try {
      await _medicineService.logMedicineTaken(
        userId: userId,
        medicineId: medicineId,
        medicineName: medicineName,
        scheduledTime: scheduledTime,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}