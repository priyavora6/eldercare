class EmergencyAlert {
  final String id;
  final String userId;
  final String userName;
  final double latitude;
  final double longitude;
  final String message;
  final DateTime timestamp;
  final bool isResolved;
  final DateTime? resolvedAt;
  final String? resolvedBy;
  final String? resolverNotes;

  EmergencyAlert({
    required this.id,
    required this.userId,
    required this.userName,
    required this.latitude,
    required this.longitude,
    required this.message,
    required this.timestamp,
    this.isResolved = false,
    this.resolvedAt,
    this.resolvedBy,
    this.resolverNotes,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'latitude': latitude,
      'longitude': longitude,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isResolved': isResolved,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'resolvedBy': resolvedBy,
      'resolverNotes': resolverNotes,
    };
  }

  // Create from JSON
  factory EmergencyAlert.fromJson(Map<String, dynamic> json) {
    return EmergencyAlert(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      message: json['message'] ?? '',
      timestamp: json['timestamp'] is String
          ? DateTime.parse(json['timestamp'])
          : (json['timestamp'] as dynamic).toDate(),
      isResolved: json['isResolved'] ?? false,
      resolvedAt: json['resolvedAt'] != null
          ? (json['resolvedAt'] is String
          ? DateTime.parse(json['resolvedAt'])
          : (json['resolvedAt'] as dynamic).toDate())
          : null,
      resolvedBy: json['resolvedBy'],
      resolverNotes: json['resolverNotes'],
    );
  }

  // Copy with method for updates
  EmergencyAlert copyWith({
    String? id,
    String? userId,
    String? userName,
    double? latitude,
    double? longitude,
    String? message,
    DateTime? timestamp,
    bool? isResolved,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolverNotes,
  }) {
    return EmergencyAlert(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isResolved: isResolved ?? this.isResolved,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolverNotes: resolverNotes ?? this.resolverNotes,
    );
  }

  // Get location as string
  String get locationString {
    return '$latitude, $longitude';
  }

  // Get Google Maps URL
  String get googleMapsUrl {
    return 'https://www.google.com/maps?q=$latitude,$longitude';
  }

  // Get time since alert
  String get timeSinceAlert {
    final duration = DateTime.now().difference(timestamp);

    if (duration.inMinutes < 1) {
      return 'Just now';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} minutes ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} hours ago';
    } else {
      return '${duration.inDays} days ago';
    }
  }

  // Get alert severity based on time
  String get severity {
    if (isResolved) return 'Resolved';

    final duration = DateTime.now().difference(timestamp);

    if (duration.inMinutes < 5) {
      return 'Critical';
    } else if (duration.inMinutes < 30) {
      return 'High';
    } else if (duration.inHours < 2) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }

  // Get severity color
  String get severityColor {
    switch (severity) {
      case 'Critical':
        return '#D32F2F'; // Red
      case 'High':
        return '#F57C00'; // Orange
      case 'Medium':
        return '#FBC02D'; // Yellow
      case 'Low':
        return '#388E3C'; // Green
      case 'Resolved':
        return '#757575'; // Gray
      default:
        return '#9E9E9E';
    }
  }

  // Get resolution duration
  String? get resolutionDuration {
    if (!isResolved || resolvedAt == null) return null;

    final duration = resolvedAt!.difference(timestamp);

    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} minutes';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} hours';
    } else {
      return '${duration.inDays} days';
    }
  }
}