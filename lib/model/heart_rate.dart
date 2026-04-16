class HeartRateModel {
  final List<double> bpmPoints;
  final int currentBpm;
  final int minBpm;
  final int avgBpm;
  final int maxBpm;
  final String lastReadingTime;

  const HeartRateModel({
    required this.bpmPoints,
    required this.currentBpm,
    required this.minBpm,
    required this.avgBpm,
    required this.maxBpm,
    required this.lastReadingTime,
  });
}