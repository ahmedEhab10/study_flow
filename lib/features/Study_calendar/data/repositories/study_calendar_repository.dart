import 'package:hive/hive.dart';
import 'package:study_flow/Core/Models/Study_Record_Model.dart';

class StudyCalendarRepository {
  static const String _boxName = 'study_calendar_box';

  Box get _box => Hive.box(_boxName);

  List<StudyRecordModel> getAllRecords() {
    if (_box.isEmpty) {
      // Populate with realistic mock data to match the screenshot
      _populateMockData();
    }

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

  void _populateMockData() {
    final now = DateTime.now();
    final List<StudyRecordModel> mockRecords = [];

    // Let's create realistic logs for the last 30 days.
    // We want:
    // - 22 study days
    // - Current streak: 5 days (e.g. today and the last 4 days)
    // - Longest streak: 12 days (some weeks ago)
    // - Completion: 85%

    // Create 12 days streak (e.g. from 24 days ago to 13 days ago)
    for (int i = 13; i <= 24; i++) {
      final date = now.subtract(Duration(days: i));
      mockRecords.add(
        StudyRecordModel(
          id: 'mock_$i',
          date: date,
          subjectName: i % 2 == 0 ? 'Bio' : 'Physics',
          durationSeconds: (i % 3 + 1) * 3600, // 1h, 2h, 3h
          pdfsCount: i % 2 + 1,
          tasksCount: i % 3 + 2,
          notes: [
            'Reviewed cellular division chapters.',
            'Practiced kinematics problems and formulas.'
          ],
        ),
      );
    }

    // Create 5 days streak (e.g. from today to 4 days ago)
    for (int i = 0; i <= 4; i++) {
      final date = now.subtract(Duration(days: i));
      mockRecords.add(
        StudyRecordModel(
          id: 'mock_streak_$i',
          date: date,
          subjectName: i % 2 == 0 ? 'Chemistry' : 'Bio, Physics',
          durationSeconds: (i == 0) ? 7200 : (i % 2 + 1) * 3600 + 1800, // 2h, 1.5h, 2.5h
          pdfsCount: i % 2 + 2,
          tasksCount: i % 2 + 3,
          notes: [
            'Studied molecular structures and organic bonds.',
            'Read 3 reference papers.'
          ],
        ),
      );
    }

    // Create some individual study days to reach 22 total study days
    // Currently we have 12 + 5 = 17 days. We need 5 more days.
    final List<int> individualOffsets = [7, 9, 27, 29, 30];
    for (int offset in individualOffsets) {
      final date = now.subtract(Duration(days: offset));
      mockRecords.add(
        StudyRecordModel(
          id: 'mock_indiv_$offset',
          date: date,
          subjectName: offset % 2 == 0 ? 'Mathematics' : 'Literature',
          durationSeconds: (offset % 2 + 1) * 3600,
          pdfsCount: 1,
          tasksCount: 2,
          notes: ['Completed algebra exercises.'],
        ),
      );
    }

    for (var record in mockRecords) {
      _box.put(record.id, record.toJson());
    }
  }

  // Clear data for testing
  void clearAll() {
    _box.clear();
  }
}
