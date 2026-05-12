import 'package:cloud_firestore/cloud_firestore.dart';

enum MealType { breakfast, lunch, dinner, snack }

class DietMealItem {
  final String name;
  final String quantity;
  final int calories;

  const DietMealItem({
    required this.name,
    required this.quantity,
    required this.calories,
  });

  factory DietMealItem.fromMap(Map<String, dynamic> map) {
    return DietMealItem(
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? '',
      calories: map['calories'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'quantity': quantity,
    'calories': calories,
  };
}

class DietMeal {
  final MealType type;
  final String time;
  final List<DietMealItem> items;

  const DietMeal({required this.type, required this.time, required this.items});

  factory DietMeal.fromMap(Map<String, dynamic> map) {
    return DietMeal(
      type: _parseMealType(map['type']),
      time: map['time'] ?? '',
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => DietMealItem.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'type': _mealTypeString(type),
    'time': time,
    'items': items.map((e) => e.toMap()).toList(),
  };

  static MealType _parseMealType(String? value) {
    switch (value) {
      case 'lunch':
        return MealType.lunch;
      case 'dinner':
        return MealType.dinner;
      case 'snack':
        return MealType.snack;
      default:
        return MealType.breakfast;
    }
  }

  static String _mealTypeString(MealType type) {
    switch (type) {
      case MealType.lunch:
        return 'lunch';
      case MealType.dinner:
        return 'dinner';
      case MealType.snack:
        return 'snack';
      case MealType.breakfast:
        return 'breakfast';
    }
  }

  String get typeLabel {
    switch (type) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
    }
  }

  int get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
}

class DietPlanModel {
  final String id;
  final String patientId;
  final String caregiverId;
  final String title;
  final String? description;
  final List<DietMeal> meals;
  final int totalDailyCalories;
  final bool isActive;
  final DateTime createdAt;

  const DietPlanModel({
    required this.id,
    required this.patientId,
    required this.caregiverId,
    required this.title,
    this.description,
    required this.meals,
    required this.totalDailyCalories,
    required this.isActive,
    required this.createdAt,
  });

  factory DietPlanModel.fromMap(Map<String, dynamic> map, String id) {
    return DietPlanModel(
      id: id,
      patientId: map['patientId'] ?? '',
      caregiverId: map['caregiverId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      meals: (map['meals'] as List<dynamic>? ?? [])
          .map((e) => DietMeal.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      totalDailyCalories: map['totalDailyCalories'] ?? 0,
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'patientId': patientId,
    'caregiverId': caregiverId,
    'title': title,
    'description': description,
    'meals': meals.map((e) => e.toMap()).toList(),
    'totalDailyCalories': totalDailyCalories,
    'isActive': isActive,
    'createdAt': FieldValue.serverTimestamp(),
  };

  DietPlanModel copyWith({
    String? title,
    String? description,
    List<DietMeal>? meals,
    int? totalDailyCalories,
    bool? isActive,
  }) {
    return DietPlanModel(
      id: id,
      patientId: patientId,
      caregiverId: caregiverId,
      title: title ?? this.title,
      description: description ?? this.description,
      meals: meals ?? this.meals,
      totalDailyCalories: totalDailyCalories ?? this.totalDailyCalories,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }
}
