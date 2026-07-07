import 'package:study_flow/Core/Models/Subject_Model.dart';
import 'package:study_flow/Core/Models/Pdf_Model.dart';
import 'package:study_flow/Core/Models/Note_Model.dart';
import 'package:study_flow/Core/Services/hive_service.dart';
import 'package:study_flow/features/main/Home/domain/repositories/subject_repository.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final HiveService _hiveService;

  SubjectRepositoryImpl(this._hiveService);

  @override
  Future<List<SubjectModel>> getSubjects() async {
    return _hiveService.getSubjects();
  }

  @override
  Future<void> addSubject(SubjectModel subject) async {
    _hiveService.saveSubject(subject);
  }

  @override
  Future<void> deleteSubject(String subjectName) async {
    await _hiveService.deleteSubject(subjectName);
  }

  @override
  Future<void> addPdfToSubject(String subjectName, PdfModel pdf) async {
    final subjects = _hiveService.getSubjects();
    for (var subject in subjects) {
      if (subject.name == subjectName) {
        final updatedPdfs = List<PdfModel>.from(subject.pdfs)..add(pdf);
        final updatedSubject = subject.copyWith(pdfs: updatedPdfs);
        _hiveService.saveSubject(updatedSubject);
        break;
      }
    }
  }

  @override
  Future<void> addNoteToSubject(String subjectName, NoteModel note) async {
    final subjects = _hiveService.getSubjects();
    for (var subject in subjects) {
      if (subject.name == subjectName) {
        final updatedNotes = List<NoteModel>.from(subject.notes)..add(note);
        final updatedSubject = subject.copyWith(notes: updatedNotes);
        _hiveService.saveSubject(updatedSubject);
        break;
      }
    }
  }

  @override
  Future<void> updateSubjectProgress(
    String subjectName,
    double progress,
  ) async {
    final subjects = _hiveService.getSubjects();
    for (var subject in subjects) {
      if (subject.name == subjectName) {
        final updatedSubject = subject.copyWith(progress: progress);
        _hiveService.saveSubject(updatedSubject);
        break;
      }
    }
  }

  @override
  Future<void> updatePdfCompletion(
    String subjectName,
    String pdfId,
    bool isCompleted,
  ) async {
    final subjects = _hiveService.getSubjects();
    for (var subject in subjects) {
      if (subject.name == subjectName) {
        final updatedPdfs = subject.pdfs.map((pdf) {
          return pdf.id == pdfId ? pdf.copyWith(isCompleted: isCompleted) : pdf;
        }).toList();
        final progress = _computeProgress(updatedPdfs, subject.notes);
        _hiveService.saveSubject(
          subject.copyWith(pdfs: updatedPdfs, progress: progress),
        );
        break;
      }
    }
  }

  @override
  Future<void> updateNoteCompletion(
    String subjectName,
    String noteId,
    bool isCompleted,
  ) async {
    final subjects = _hiveService.getSubjects();
    for (var subject in subjects) {
      if (subject.name == subjectName) {
        final updatedNotes = subject.notes.map((note) {
          return note.id == noteId
              ? note.copyWith(isCompleted: isCompleted)
              : note;
        }).toList();
        final progress = _computeProgress(subject.pdfs, updatedNotes);
        _hiveService.saveSubject(
          subject.copyWith(notes: updatedNotes, progress: progress),
        );
        break;
      }
    }
  }

  double _computeProgress(List<PdfModel> pdfs, List<NoteModel> notes) {
    final total = pdfs.length + notes.length;
    if (total == 0) return 0.0;
    final completed =
        pdfs.where((p) => p.isCompleted).length +
        notes.where((n) => n.isCompleted).length;
    return completed / total;
  }
}
