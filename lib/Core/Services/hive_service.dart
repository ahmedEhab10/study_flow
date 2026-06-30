import 'package:hive/hive.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart';

class HiveService {
  static const String _boxName = 'subjects_box';
  static const String _subjectsInitializedKey = '__subjects_initialized__';

  Box get _box => Hive.box(_boxName);

  List<SubjectModel> getSubjects() {
    final List<SubjectModel> subjects = [];
    for (var key in _box.keys) {
      if (key == _subjectsInitializedKey) continue;

      final value = _box.get(key);
      if (value is Map<dynamic, dynamic>) {
        subjects.add(SubjectModel.fromJson(value));
      }
    }
    return subjects;
  }

  void saveSubject(SubjectModel subject) {
    _box.put(subject.name, subject.toJson());
  }

  Future<void> deleteSubject(String subjectName) async {
    await _box.delete(subjectName);
  }

  bool get hasInitializedSubjects {
    return _box.get(_subjectsInitializedKey, defaultValue: false) == true;
  }

  Future<void> markSubjectsInitialized() async {
    await _box.put(_subjectsInitializedKey, true);
  }
}
