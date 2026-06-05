import 'package:study_flow/Core/Models/Subject_Model.dart';
import 'package:study_flow/Core/Models/Pdf_Model.dart';
import 'package:study_flow/Core/Models/Note_Model.dart';

abstract class SubjectRepository {
  Future<List<SubjectModel>> getSubjects();
  Future<void> addSubject(SubjectModel subject);
  Future<void> addPdfToSubject(String subjectName, PdfModel pdf);
  Future<void> addNoteToSubject(String subjectName, NoteModel note);
  Future<void> updateSubjectProgress(String subjectName, double progress);
  Future<void> updatePdfCompletion(
      String subjectName, String pdfId, bool isCompleted);
  Future<void> updateNoteCompletion(
      String subjectName, String noteId, bool isCompleted);
}
