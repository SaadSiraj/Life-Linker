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
