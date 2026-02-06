class EmergencyContact {
  final String id;
  final String userId;
  final String name;
  final String phoneNumber;
  final String relationship; // son, daughter, spouse, friend, neighbor, etc.
  final bool isPrimary; // Primary contact gets notified first
  final DateTime createdAt;
  final DateTime? updatedAt;

  EmergencyContact({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    this.isPrimary = false,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
      'isPrimary': isPrimary,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create from JSON
  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      relationship: json['relationship'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'])
          : (json['createdAt'] as dynamic).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is String
          ? DateTime.parse(json['updatedAt'])
          : (json['updatedAt'] as dynamic).toDate())
          : null,
    );
  }

  // Copy with method for updates
  EmergencyContact copyWith({
    String? id,
    String? userId,
    String? name,
    String? phoneNumber,
    String? relationship,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      relationship: relationship ?? this.relationship,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get formatted phone number
  String get formattedPhoneNumber {
    // Basic formatting - can be enhanced based on region
    if (phoneNumber.length == 10) {
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    }
    return phoneNumber;
  }

  // Get relationship icon
  String get relationshipIcon {
    switch (relationship.toLowerCase()) {
      case 'son':
        return '👨';
      case 'daughter':
        return '👩';
      case 'spouse':
        return '💑';
      case 'friend':
        return '👥';
      case 'neighbor':
        return '🏘️';
      case 'doctor':
        return '👨‍⚕️';
      default:
        return '👤';
    }
  }
}