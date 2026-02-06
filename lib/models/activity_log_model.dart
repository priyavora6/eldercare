class ActivityLog {
  final String id;
  final String userId;
  final String activityType; // health_checkin, medicine_taken, emergency_alert, chat, etc.
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata; // Additional data specific to activity type

  ActivityLog({
    required this.id,
    required this.userId,
    required this.activityType,
    required this.description,
    required this.timestamp,
    this.metadata,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'activityType': activityType,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  // Create from JSON
  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      activityType: json['activityType'] ?? '',
      description: json['description'] ?? '',
      timestamp: json['timestamp'] is String
          ? DateTime.parse(json['timestamp'])
          : (json['timestamp'] as dynamic).toDate(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  // Copy with method for updates
  ActivityLog copyWith({
    String? id,
    String? userId,
    String? activityType,
    String? description,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return ActivityLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      activityType: activityType ?? this.activityType,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  // Get activity icon based on type
  String get activityIcon {
    switch (activityType) {
      case 'health_checkin':
        return '🏥';
      case 'medicine_taken':
        return '💊';
      case 'medicine_missed':
        return '⚠️';
      case 'emergency_alert':
        return '🚨';
      case 'chat':
        return '💬';
      case 'login':
        return '🔐';
      case 'logout':
        return '👋';
      case 'profile_update':
        return '✏️';
      case 'family_linked':
        return '👨‍👩‍👧‍👦';
      case 'location_update':
        return '📍';
      default:
        return '📝';
    }
  }

  // Get activity color
  String get activityColor {
    switch (activityType) {
      case 'health_checkin':
        return '#4CAF50'; // Green
      case 'medicine_taken':
        return '#2196F3'; // Blue
      case 'medicine_missed':
        return '#FF9800'; // Orange
      case 'emergency_alert':
        return '#F44336'; // Red
      case 'chat':
        return '#9C27B0'; // Purple
      case 'login':
      case 'logout':
        return '#607D8B'; // Blue Gray
      case 'profile_update':
        return '#00BCD4'; // Cyan
      case 'family_linked':
        return '#FF5722'; // Deep Orange
      case 'location_update':
        return '#795548'; // Brown
      default:
        return '#9E9E9E'; // Gray
    }
  }

  // Get formatted time
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  // Get full formatted date time
  String get fullFormattedDateTime {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  // Check if activity is important
  bool get isImportant {
    return [
      'emergency_alert',
      'medicine_missed',
      'health_checkin',
    ].contains(activityType);
  }

  // Get priority level
  int get priority {
    switch (activityType) {
      case 'emergency_alert':
        return 5;
      case 'medicine_missed':
        return 4;
      case 'health_checkin':
        return 3;
      case 'medicine_taken':
        return 2;
      default:
        return 1;
    }
  }

  // Static method to create activity log for different types
  static ActivityLog createHealthCheckIn(String userId, String description) {
    return ActivityLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      activityType: 'health_checkin',
      description: description,
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog createMedicineTaken(
      String userId, String medicineName) {
    return ActivityLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      activityType: 'medicine_taken',
      description: 'Took $medicineName',
      timestamp: DateTime.now(),
      metadata: {'medicineName': medicineName},
    );
  }

  static ActivityLog createMedicineMissed(
      String userId, String medicineName) {
    return ActivityLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      activityType: 'medicine_missed',
      description: 'Missed $medicineName',
      timestamp: DateTime.now(),
      metadata: {'medicineName': medicineName},
    );
  }

  static ActivityLog createEmergencyAlert(String userId, String message) {
    return ActivityLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      activityType: 'emergency_alert',
      description: message,
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog createChatActivity(String userId, String chatSummary) {
    return ActivityLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      activityType: 'chat',
      description: chatSummary,
      timestamp: DateTime.now(),
    );
  }
}