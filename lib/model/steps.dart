class StepsModel {
  final int currentSteps;
  final int goalSteps;

  const StepsModel({required this.currentSteps, required this.goalSteps});

  double get progress => currentSteps / goalSteps;
}
