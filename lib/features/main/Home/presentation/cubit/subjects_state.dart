import 'package:study_flow/Core/Models/Subject_Model.dart';

abstract class SubjectsState {
  final List<SubjectModel> subjects;
  const SubjectsState({required this.subjects});
}

class SubjectsInitial extends SubjectsState {
  const SubjectsInitial({required super.subjects});
}

class SubjectsLoaded extends SubjectsState {
  const SubjectsLoaded({required super.subjects});
}
