class NotificationModel {
  final bool sosAlerts;
  final bool geofenceBreaches;
  final bool medicationReminders;
  final bool dailyHealthSummary;
  final bool lowBattery;

  const NotificationModel({
    required this.sosAlerts,
    required this.geofenceBreaches,
    required this.medicationReminders,
    required this.dailyHealthSummary,
    required this.lowBattery,
  });

  NotificationModel copyWith({
    bool? sosAlerts,
    bool? geofenceBreaches,
    bool? medicationReminders,
    bool? dailyHealthSummary,
    bool? lowBattery,
  }) {
    return NotificationModel(
      sosAlerts: sosAlerts ?? this.sosAlerts,
      geofenceBreaches: geofenceBreaches ?? this.geofenceBreaches,
      medicationReminders: medicationReminders ?? this.medicationReminders,
      dailyHealthSummary: dailyHealthSummary ?? this.dailyHealthSummary,
      lowBattery: lowBattery ?? this.lowBattery,
    );
  }
}
