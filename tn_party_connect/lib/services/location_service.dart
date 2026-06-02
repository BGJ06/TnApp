import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class LocationService {
  /// Fetches the user's current GPS location coordinates.
  /// Falls back to Chennai coordinates (13.0827, 80.2707) on error or mock mode.
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _mockPosition();
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _mockPosition();
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return _mockPosition();
      } 

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint("Error fetching location, falling back to mock coordinate: $e");
      return _mockPosition();
    }
  }

  Position _mockPosition() {
    return Position(
      longitude: 80.2707, // Chennai Central coordinates
      latitude: 13.0827,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }
}
