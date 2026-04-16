class SleepModel {
  final double totalHours;
  final double deepRatio;
  final double coreRatio;
  final double remRatio;
  final double awakeRatio;
  final String bedtime;
  final String wakeUp;
  final String sleepNote;

  const SleepModel({
    required this.totalHours,
    required this.deepRatio,
    required this.coreRatio,
    required this.remRatio,
    required this.awakeRatio,
    required this.bedtime,
    required this.wakeUp,
    required this.sleepNote,
  });
}