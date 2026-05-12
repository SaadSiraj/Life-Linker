import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifelinker/model/dite_plan.dart';

class DietPlanRepository {
  static final _db = FirebaseFirestore.instance;
  static const String _col = 'diet_plans';

  static Future<DietPlanModel> addPlan(DietPlanModel plan) async {
    final ref = _db.collection(_col).doc();
    final newPlan = DietPlanModel(
      id: ref.id,
      patientId: plan.patientId,
      caregiverId: plan.caregiverId,
      title: plan.title,
      description: plan.description,
      meals: plan.meals,
      totalDailyCalories: plan.totalDailyCalories,
      isActive: true,
      createdAt: DateTime.now(),
    );
    await ref.set(newPlan.toMap());
    return newPlan;
  }

  static Future<void> updatePlan(DietPlanModel plan) async {
    await _db.collection(_col).doc(plan.id).update({
      'title': plan.title,
      'description': plan.description,
      'meals': plan.meals.map((e) => e.toMap()).toList(),
      'totalDailyCalories': plan.totalDailyCalories,
    });
  }

  static Future<void> deletePlan(String planId) async {
    await _db.collection(_col).doc(planId).update({'isActive': false});
  }

  static Stream<List<DietPlanModel>> listenToPlans(String patientId) {
    return _db
        .collection(_col)
        .where('patientId', isEqualTo: patientId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (s) =>
              s.docs.map((d) => DietPlanModel.fromMap(d.data(), d.id)).toList(),
        );
  }
}
