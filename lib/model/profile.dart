/// JUNIOR DEVLOPER MISS MODELS WORING IN 1 FILE

class UserProfileModel {
  final String caregiverName;
  final String caregiverEmail;
  final String caregiverPhone;
  final String patientName;
  final int patientAge;
  final String patientCondition;
  final String patientBloodGroup;
  final String patientEmergencyContact;

  const UserProfileModel({
    required this.caregiverName,
    required this.caregiverEmail,
    required this.caregiverPhone,
    required this.patientName,
    required this.patientAge,
    required this.patientCondition,
    required this.patientBloodGroup,
    required this.patientEmergencyContact,
  });

  UserProfileModel copyWith({
    String? caregiverName,
    String? caregiverEmail,
    String? caregiverPhone,
    String? patientName,
    int? patientAge,
    String? patientCondition,
    String? patientBloodGroup,
    String? patientEmergencyContact,
  }) {
    return UserProfileModel(
      caregiverName: caregiverName ?? this.caregiverName,
      caregiverEmail: caregiverEmail ?? this.caregiverEmail,
      caregiverPhone: caregiverPhone ?? this.caregiverPhone,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientCondition: patientCondition ?? this.patientCondition,
      patientBloodGroup: patientBloodGroup ?? this.patientBloodGroup,
      patientEmergencyContact:
          patientEmergencyContact ?? this.patientEmergencyContact,
    );
  }
}

class SafeZoneModel {
  final bool enabled;
  final double radiusMeters;
  final String centerLabel;

  const SafeZoneModel({
    required this.enabled,
    required this.radiusMeters,
    required this.centerLabel,
  });

  SafeZoneModel copyWith({
    bool? enabled,
    double? radiusMeters,
    String? centerLabel,
  }) {
    return SafeZoneModel(
      enabled: enabled ?? this.enabled,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      centerLabel: centerLabel ?? this.centerLabel,
    );
  }
}

class NotificationSettingsModel {
  final bool sosAlerts;
  final bool geofenceBreaches;
  final bool medicationReminders;
  final bool dailyHealthSummary;
  final bool lowBattery;

  const NotificationSettingsModel({
    required this.sosAlerts,
    required this.geofenceBreaches,
    required this.medicationReminders,
    required this.dailyHealthSummary,
    required this.lowBattery,
  });

  NotificationSettingsModel copyWith({
    bool? sosAlerts,
    bool? geofenceBreaches,
    bool? medicationReminders,
    bool? dailyHealthSummary,
    bool? lowBattery,
  }) {
    return NotificationSettingsModel(
      sosAlerts: sosAlerts ?? this.sosAlerts,
      geofenceBreaches: geofenceBreaches ?? this.geofenceBreaches,
      medicationReminders: medicationReminders ?? this.medicationReminders,
      dailyHealthSummary: dailyHealthSummary ?? this.dailyHealthSummary,
      lowBattery: lowBattery ?? this.lowBattery,
    );
  }
}