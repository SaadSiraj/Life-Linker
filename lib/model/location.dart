class LocationModel {
  final String patientName;
  final String patientStatus;
  final String lastSeen;
  final bool isInSafeZone;
  final int steps;
  final int heartRate;
  final int calories;

  const LocationModel({
    required this.patientName,
    required this.patientStatus,
    required this.lastSeen,
    required this.isInSafeZone,
    required this.steps,
    required this.heartRate,
    required this.calories,
  });
}
