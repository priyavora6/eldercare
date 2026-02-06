class HealthCheckIn {
  final String id;
  final String userId;
  final DateTime timestamp;
  final double? bloodPressureSystolic;
  final double? bloodPressureDiastolic;
  final double? heartRate;
  final double? temperature;
  final double? bloodSugar;
  final String mood; // happy, okay, sad, worried, sick
  final String? notes;

  HealthCheckIn({
    required this.id,
    required this.userId,
    required this.timestamp,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.heartRate,
    this.temperature,
    this.bloodSugar,
    required this.mood,
    this.notes,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'bloodPressureSystolic': bloodPressureSystolic,
      'bloodPressureDiastolic': bloodPressureDiastolic,
      'heartRate': heartRate,
      'temperature': temperature,
      'bloodSugar': bloodSugar,
      'mood': mood,
      'notes': notes,
    };
  }

  // Create from JSON
  factory HealthCheckIn.fromJson(Map<String, dynamic> json) {
    return HealthCheckIn(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      timestamp: json['timestamp'] is String
          ? DateTime.parse(json['timestamp'])
          : (json['timestamp'] as dynamic).toDate(),
      bloodPressureSystolic: json['bloodPressureSystolic']?.toDouble(),
      bloodPressureDiastolic: json['bloodPressureDiastolic']?.toDouble(),
      heartRate: json['heartRate']?.toDouble(),
      temperature: json['temperature']?.toDouble(),
      bloodSugar: json['bloodSugar']?.toDouble(),
      mood: json['mood'] ?? 'okay',
      notes: json['notes'],
    );
  }

  // Copy with method for updates
  HealthCheckIn copyWith({
    String? id,
    String? userId,
    DateTime? timestamp,
    double? bloodPressureSystolic,
    double? bloodPressureDiastolic,
    double? heartRate,
    double? temperature,
    double? bloodSugar,
    String? mood,
    String? notes,
  }) {
    return HealthCheckIn(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      bloodPressureSystolic:
      bloodPressureSystolic ?? this.bloodPressureSystolic,
      bloodPressureDiastolic:
      bloodPressureDiastolic ?? this.bloodPressureDiastolic,
      heartRate: heartRate ?? this.heartRate,
      temperature: temperature ?? this.temperature,
      bloodSugar: bloodSugar ?? this.bloodSugar,
      mood: mood ?? this.mood,
      notes: notes ?? this.notes,
    );
  }

  // Get blood pressure as string
  String get bloodPressureString {
    if (bloodPressureSystolic == null || bloodPressureDiastolic == null) {
      return 'Not recorded';
    }
    return '${bloodPressureSystolic!.toInt()}/${bloodPressureDiastolic!.toInt()} mmHg';
  }

  // Check if blood pressure is normal
  bool get isBloodPressureNormal {
    if (bloodPressureSystolic == null || bloodPressureDiastolic == null) {
      return true;
    }
    return bloodPressureSystolic! < 140 && bloodPressureDiastolic! < 90;
  }

  // Check if heart rate is normal
  bool get isHeartRateNormal {
    if (heartRate == null) return true;
    return heartRate! >= 60 && heartRate! <= 100;
  }

  // Check if temperature is normal
  bool get isTemperatureNormal {
    if (temperature == null) return true;
    return temperature! >= 36.1 && temperature! <= 37.2;
  }

  // Check if blood sugar is normal (fasting)
  bool get isBloodSugarNormal {
    if (bloodSugar == null) return true;
    return bloodSugar! >= 70 && bloodSugar! <= 100;
  }

  // Get overall health status
  String get overallStatus {
    List<bool> checks = [
      isBloodPressureNormal,
      isHeartRateNormal,
      isTemperatureNormal,
      isBloodSugarNormal,
    ];

    int abnormalCount = checks.where((check) => !check).length;

    if (abnormalCount == 0) return 'Good';
    if (abnormalCount == 1) return 'Fair';
    return 'Needs Attention';
  }
}