import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../services/location_service.dart';

class SOSAlert {
  final String id;
  final String memberUid;
  final String memberName;
  final String contactNumber;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String status; // active, acknowledged, resolved

  SOSAlert({
    required this.id,
    required this.memberUid,
    required this.memberName,
    required this.contactNumber,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.status,
  });

  SOSAlert copyWith({String? status}) {
    return SOSAlert(
      id: id,
      memberUid: memberUid,
      memberName: memberName,
      contactNumber: contactNumber,
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
      status: status ?? this.status,
    );
  }
}

class SOSNotifier extends StateNotifier<List<SOSAlert>> {
  final _locationService = LocationService();

  SOSNotifier()
      : super([
          // Prefill a mock active alert for display in leadership dashboards
          SOSAlert(
            id: 'mock-sos-1',
            memberUid: 'member_demo_uid',
            memberName: 'Arun Mozhi',
            contactNumber: '+919876543210',
            latitude: 13.0827,
            longitude: 80.2707,
            timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
            status: 'active',
          ),
        ]);

  /// Trigger emergency SOS alert
  Future<void> raiseSOS(
      String memberUid, String memberName, String phone) async {
    final position = await _locationService.getCurrentLocation();

    final newAlert = SOSAlert(
      id: const Uuid().v4(),
      memberUid: memberUid,
      memberName: memberName,
      contactNumber: phone,
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      status: 'active',
    );

    state = [newAlert, ...state];
  }

  /// Update the status of an emergency alert (Acknowledge / Resolve)
  void updateAlertStatus(String alertId, String newStatus) {
    state = state.map((alert) {
      if (alert.id == alertId) {
        return alert.copyWith(status: newStatus);
      }
      return alert;
    }).toList();
  }
}

final sosProvider = StateNotifierProvider<SOSNotifier, List<SOSAlert>>((ref) {
  return SOSNotifier();
});
