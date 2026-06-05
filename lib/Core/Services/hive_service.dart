import 'package:hive/hive.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart';

class HiveService {
  static const String _boxName = 'subjects_box';

  Box get _box => Hive.box(_boxName);

  List<SubjectModel> getSubjects() {
    final List<SubjectModel> subjects = [];
    if (_box.isEmpty) {
      return [];
    }
    for (var key in _box.keys) {
      final Map<dynamic, dynamic> map = _box.get(key) as Map<dynamic, dynamic>;
      subjects.add(SubjectModel.fromJson(map));
    }
    return subjects;
  }

  void saveSubject(SubjectModel subject) {
    _box.put(subject.name, subject.toJson());
  }

  bool isBoxEmpty() {
    return _box.isEmpty;
  }
}
