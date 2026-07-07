import 'package:hive/hive.dart';
import 'package:study_flow/Core/Models/Study_Record_Model.dart';

class StudyCalendarRepository {
  static const String _boxName = 'study_calendar_box';

  Box get _box => Hive.box(_boxName);

  List<StudyRecordModel> getAllRecords() {
    final List<StudyRecordModel> records = [];
    for (var key in _box.keys) {
      final Map<dynamic, dynamic> map = _box.get(key) as Map<dynamic, dynamic>;
      records.add(StudyRecordModel.fromJson(map));
    }
    return records;
  }

  void saveRecord(StudyRecordModel record) {
    _box.put(record.id, record.toJson());
  }

  // Clear data for testing
  void clearAll() {
    _box.clear();
  }
}
