import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check location permission
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  // Update user location in Firestore
  Future<void> updateUserLocation(String userId) async {
    try {
      Position? position = await getCurrentLocation();
      if (position != null) {
        await _firestore.collection('users').doc(userId).update({
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'accuracy': position.accuracy,
            'timestamp': FieldValue.serverTimestamp(),
          }
        });
      }
    } catch (e) {
      throw Exception('Failed to update user location: $e');
    }
  }

  // Get distance between two coordinates (in kilometers)
  double getDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    ) /
        1000; // Convert meters to kilometers
  }

  // Track user location continuously
  Stream<Position> trackLocation() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );
    return Geolocator.getPositionStream(
      locationSettings: locationSettings,
    );
  }

  // Save location history
  Future<void> saveLocationHistory(
      String userId,
      double latitude,
      double longitude,
      ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('location_history')
          .add({
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save location history: $e');
    }
  }

  // Get location history
  Future<List<Map<String, dynamic>>> getLocationHistory(
      String userId, {
        DateTime? startDate,
        DateTime? endDate,
      }) async {
    try {
      Query query = _firestore
          .collection('users')
          .doc(userId)
          .collection('location_history')
          .orderBy('timestamp', descending: true);

      if (startDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to get location history: $e');
    }
  }

  // Calculate address from coordinates (requires geocoding package)
  Future<String> getAddressFromCoordinates(
      double latitude,
      double longitude,
      ) async {
    // This would require geocoding package
    // For now, returning coordinates as string
    return '$latitude, $longitude';
  }
}