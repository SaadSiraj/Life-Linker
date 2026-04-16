class DashboardModel {
  final String patientName;
  final bool isSafe;
  final String locationLabel;
  final String locationSub;
  final String medicationLabel;
  final String medicationSub;
  final int knownPeopleCount;
  final String knownPeopleSub;
  final String healthLabel;
  final String healthSub;

  const DashboardModel({
    required this.patientName,
    required this.isSafe,
    required this.locationLabel,
    required this.locationSub,
    required this.medicationLabel,
    required this.medicationSub,
    required this.knownPeopleCount,
    required this.knownPeopleSub,
    required this.healthLabel,
    required this.healthSub,
  });
}