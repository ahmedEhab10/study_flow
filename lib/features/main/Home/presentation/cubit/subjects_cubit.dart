import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart';
import 'package:study_flow/Core/Models/Pdf_Model.dart';
import 'package:study_flow/Core/Models/Note_Model.dart';
import 'package:study_flow/Core/const/subject_list.dart' as const_list;
import 'package:study_flow/features/main/Home/presentation/cubit/subjects_state.dart';

class SubjectsCubit extends Cubit<SubjectsState> {
  static const String _boxName = 'subjects_box';

  SubjectsCubit() : super(const SubjectsInitial(subjects: [])) {
    loadSubjects();
  }

  void loadSubjects() {
    final box = Hive.box(_boxName);
    final List<SubjectModel> loadedSubjects = [];

    if (box.isEmpty) {
      // Seed initial subjects from subject_list.dart if database is empty
      final initialSubjects = const_list.subjects;
      for (var subject in initialSubjects) {
        box.put(subject.name, subject.toJson());
        loadedSubjects.add(subject);
      }
    } else {
      for (var key in box.keys) {
        final Map<dynamic, dynamic> map = box.get(key) as Map<dynamic, dynamic>;
        loadedSubjects.add(SubjectModel.fromJson(map));
      }
    }

    emit(SubjectsLoaded(subjects: loadedSubjects));
  }

  void addSubject(SubjectModel subject) {
    final box = Hive.box(_boxName);
    box.put(subject.name, subject.toJson());
    
    final updatedSubjects = List<SubjectModel>.from(state.subjects)..add(subject);
    emit(SubjectsLoaded(subjects: updatedSubjects));
  }

  void addPdfToSubject(String subjectName, PdfModel pdf) {
    final box = Hive.box(_boxName);
    final updatedSubjects = state.subjects.map((subject) {
      if (subject.name == subjectName) {
        final updatedPdfs = List<PdfModel>.from(subject.pdfs)..add(pdf);
        final updatedSubject = subject.copyWith(pdfs: updatedPdfs);
        box.put(subjectName, updatedSubject.toJson());
        return updatedSubject;
      }
      return subject;
    }).toList();
    
    emit(SubjectsLoaded(subjects: updatedSubjects));
  }

  void addNoteToSubject(String subjectName, NoteModel note) {
    final box = Hive.box(_boxName);
    final updatedSubjects = state.subjects.map((subject) {
      if (subject.name == subjectName) {
        final updatedNotes = List<NoteModel>.from(subject.notes)..add(note);
        final updatedSubject = subject.copyWith(notes: updatedNotes);
        box.put(subjectName, updatedSubject.toJson());
        return updatedSubject;
      }
      return subject;
    }).toList();
    
    emit(SubjectsLoaded(subjects: updatedSubjects));
  }

  void updateSubjectProgress(String subjectName, double progress) {
    final box = Hive.box(_boxName);
    final updatedSubjects = state.subjects.map((subject) {
      if (subject.name == subjectName) {
        final updatedSubject = subject.copyWith(progress: progress);
        box.put(subjectName, updatedSubject.toJson());
        return updatedSubject;
      }
      return subject;
    }).toList();
    
    emit(SubjectsLoaded(subjects: updatedSubjects));
  }
}
