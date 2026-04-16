import 'package:lifelinker/model/medication.dart';

class MedHistoryItemModel {
  final String name;
  final String time;
  final MedStatus status;

  const MedHistoryItemModel({
    required this.name,
    required this.time,
    required this.status,
  });
}

class MedHistoryGroupModel {
  final String dateLabel;
  final List<MedHistoryItemModel> items;

  const MedHistoryGroupModel({required this.dateLabel, required this.items});
}
