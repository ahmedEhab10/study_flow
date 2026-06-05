import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart';
import 'package:study_flow/Core/Models/Pdf_Model.dart';
import 'package:study_flow/Core/Models/Note_Model.dart';
import 'package:study_flow/features/main/Home/domain/repositories/subject_repository.dart';
import 'package:study_flow/features/main/Home/presentation/cubit/subjects_state.dart';

class SubjectsCubit extends Cubit<SubjectsState> {
  final SubjectRepository _subjectRepository;

  SubjectsCubit(this._subjectRepository) : super(const SubjectsInitial(subjects: [])) {
    loadSubjects();
  }

  Future<void> loadSubjects() async {
    final loadedSubjects = await _subjectRepository.getSubjects();
    emit(SubjectsLoaded(subjects: loadedSubjects));
  }

  Future<void> addSubject(SubjectModel subject) async {
    await _subjectRepository.addSubject(subject);
    final updatedSubjects = List<SubjectModel>.from(state.subjects)..add(subject);
    emit(SubjectsLoaded(subjects: updatedSubjects));
  }

  Future<void> addPdfToSubject(String subjectName, PdfModel pdf) async {
    await _subjectRepository.addPdfToSubject(subjectName, pdf);
    final updatedSubjects = state.subjects.map((subject) {
      if (subject.name == subjectName) {
        final updatedPdfs = List<PdfModel>.from(subject.pdfs)..add(pdf);
        return subject.copyWith(pdfs: updatedPdfs);
      }
      return subject;
    }).toList();
    emit(SubjectsLoaded(subjects: updatedSubjects));
  }

  Future<void> addNoteToSubject(String subjectName, NoteModel note) async {
    await _subjectRepository.addNoteToSubject(subjectName, note);
    final updatedSubjects = state.subjects.map((subject) {
      if (subject.name == subjectName) {
        final updatedNotes = List<NoteModel>.from(subject.notes)..add(note);
        return subject.copyWith(notes: updatedNotes);
      }
      return subject;
    }).toList();
    emit(SubjectsLoaded(subjects: updatedSubjects));
  }

  Future<void> updateSubjectProgress(String subjectName, double progress) async {
    await _subjectRepository.updateSubjectProgress(subjectName, progress);
    final updatedSubjects = state.subjects.map((subject) {
      if (subject.name == subjectName) {
        return subject.copyWith(progress: progress);
      }
      return subject;
    }).toList();
    emit(SubjectsLoaded(subjects: updatedSubjects));
  }

  /// Toggles the [isCompleted] flag on a specific PDF and recalculates progress.
  Future<void> updatePdfCompletion(
      String subjectName, String pdfId, bool isCompleted) async {
    await _subjectRepository.updatePdfCompletion(
      subjectName,
      pdfId,
      isCompleted,
    );

    final updatedSubjects = state.subjects.map((subject) {
      if (subject.name != subjectName) return subject;

      final updatedPdfs = subject.pdfs.map((pdf) {
        return pdf.id == pdfId ? pdf.copyWith(isCompleted: isCompleted) : pdf;
      }).toList();

      final newProgress = _computeProgress(updatedPdfs, subject.notes);
      return subject.copyWith(pdfs: updatedPdfs, progress: newProgress);
    }).toList();

    emit(SubjectsLoaded(subjects: updatedSubjects));
  }

  /// Toggles the [isCompleted] flag on a specific note and recalculates progress.
  Future<void> updateNoteCompletion(
      String subjectName, String noteId, bool isCompleted) async {
    await _subjectRepository.updateNoteCompletion(
      subjectName,
      noteId,
      isCompleted,
    );

    final updatedSubjects = state.subjects.map((subject) {
      if (subject.name != subjectName) return subject;

      final updatedNotes = subject.notes.map((note) {
        return note.id == noteId ? note.copyWith(isCompleted: isCompleted) : note;
      }).toList();

      final newProgress = _computeProgress(subject.pdfs, updatedNotes);
      return subject.copyWith(notes: updatedNotes, progress: newProgress);
    }).toList();

    emit(SubjectsLoaded(subjects: updatedSubjects));
  }

  /// Computes progress as (completedPdfs + completedNotes) / totalItems.
  double _computeProgress(List<PdfModel> pdfs, List<NoteModel> notes) {
    final total = pdfs.length + notes.length;
    if (total == 0) return 0.0;
    final completed =
        pdfs.where((p) => p.isCompleted).length +
        notes.where((n) => n.isCompleted).length;
    return completed / total;
  }
}
