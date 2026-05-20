import 'dart:ui';
import 'package:study_flow/Core/Models/Subject_Model.dart';
import 'package:study_flow/Core/Models/Pdf_Model.dart';
import 'package:study_flow/Core/Models/Note_Model.dart';

final List<SubjectModel> subjects = [
  SubjectModel(
    name: 'Modern History',
    subtitle: '24 PDFs • 2 Quizzes',
    progress: 0.85,
    accent: const Color(0xFFF59E0B),
    iconBg: const Color(0xFFFFF7ED),
    icon: SubjectIcon.history,
    pdfs: [
      const PdfModel(
        title: 'World War I Summary.pdf',
        subjectName: 'Modern History',
        timeAgo: 'Opened 4 hours ago',
      ),
      const PdfModel(
        title: 'Industrial Revolution.pdf',
        subjectName: 'Modern History',
        timeAgo: 'Opened 2 days ago',
      ),
    ],
    notes: [
      NoteModel(
        title: 'Causes of WWI',
        content:
            'Militarism, Alliances, Imperialism, and Nationalism (M-A-I-N). Sparked by the assassination of Archduke Franz Ferdinand.',
        dateCreated: DateTime.now(),
      ),
    ],
  ),
  SubjectModel(
    name: 'Mathematics',
    subtitle: '16 PDFs • 9 Quizzes',
    progress: 0.55,
    accent: const Color(0xFFEF4444),
    iconBg: const Color(0xFFFEF2F2),
    icon: SubjectIcon.mathematics,
    pdfs: [
      const PdfModel(
        title: 'Calculus Limits.pdf',
        subjectName: 'Mathematics',
        timeAgo: 'Opened 5 hours ago',
      ),
      const PdfModel(
        title: 'Linear Algebra Basics.pdf',
        subjectName: 'Mathematics',
        timeAgo: 'Opened 1 week ago',
      ),
    ],
    notes: [
      NoteModel(
        title: 'Derivative Definition',
        content:
            'The derivative of a function is the limit as h approaches 0 of [f(x+h) - f(x)] / h.',
        dateCreated: DateTime.now(),
      ),
    ],
  ),
  SubjectModel(
    name: 'Chemistry',
    subtitle: '10 PDFs • 5 Quizzes',
    progress: 0.72,
    accent: const Color(0xFF06B6D4),
    iconBg: const Color(0xFFECFEFF),
    icon: SubjectIcon.chemistry,
    pdfs: [
      const PdfModel(
        title: 'Organic Chemistry Intro.pdf',
        subjectName: 'Chemistry',
        timeAgo: 'Opened 3 hours ago',
      ),
      const PdfModel(
        title: 'Periodic Table Guide.pdf',
        subjectName: 'Chemistry',
        timeAgo: 'Opened 1 day ago',
      ),
    ],
    notes: [
      NoteModel(
        title: 'Covalent Bonding',
        content:
            'Sharing of electron pairs between atoms. Usually happens between nonmetals.',
        dateCreated: DateTime.now(),
      ),
    ],
  ),
  SubjectModel(
    name: 'Literature',
    subtitle: '20 PDFs • 3 Quizzes',
    progress: 0.30,
    accent: const Color(0xFFEC4899),
    iconBg: const Color(0xFFFDF2F8),
    icon: SubjectIcon.literature,
    pdfs: [
      const PdfModel(
        title: 'Shakespeare Hamlet Analysis.pdf',
        subjectName: 'Literature',
        timeAgo: 'Opened 6 days ago',
      ),
    ],
    notes: [
      NoteModel(
        title: 'Hamlet Themes',
        content:
            'Revenge, mortality, madness, action vs. inaction, state corruption.',
        dateCreated: DateTime.now(),
      ),
    ],
  ),
  SubjectModel(
    name: 'Geography',
    subtitle: '14 PDFs • 7 Quizzes',
    progress: 0.60,
    accent: const Color(0xFF10B981),
    iconBg: const Color(0xFFECFDF5),
    icon: SubjectIcon.geography,
    pdfs: [
      const PdfModel(
        title: 'Tectonic Plates Map.pdf',
        subjectName: 'Geography',
        timeAgo: 'Opened 2 weeks ago',
      ),
    ],
    notes: [
      NoteModel(
        title: 'Plate Boundaries',
        content:
            'Divergent (moving apart), Convergent (colliding), Transform (sliding past).',
        dateCreated: DateTime.now(),
      ),
    ],
  ),
  SubjectModel(
    name: 'Computer Science',
    subtitle: '18 PDFs • 11 Quizzes',
    progress: 0.88,
    accent: const Color(0xFF8B5CF6),
    iconBg: const Color(0xFFF5F3FF),
    icon: SubjectIcon.computerScience,
    pdfs: [
      const PdfModel(
        title: 'Dart Cheat Sheet.pdf',
        subjectName: 'Computer Science',
        timeAgo: 'Opened 1 hour ago',
      ),
      const PdfModel(
        title: 'Flutter Design Patterns.pdf',
        subjectName: 'Computer Science',
        timeAgo: 'Opened 2 hours ago',
      ),
    ],
    notes: [
      NoteModel(
        title: 'State Management in Flutter',
        content:
            'Provider, Bloc/Cubit, Riverpod, and InheritedWidgets are common ways to handle reactive states.',
        dateCreated: DateTime.now(),
      ),
    ],
  ),
  SubjectModel(
    name: 'Biology',
    subtitle: '12 PDFs • 4 Quizzes',
    progress: 0.65,
    accent: const Color(0xFF22C55E),
    iconBg: const Color(0xFFDCFCE7),
    icon: SubjectIcon.biology,
    pdfs: [
      const PdfModel(
        title: 'Cellular Structure.pdf',
        subjectName: 'Biology',
        timeAgo: 'Opened 2 hours ago',
      ),
      const PdfModel(
        title: 'Genetic Code & RNA.pdf',
        subjectName: 'Biology',
        timeAgo: 'Opened 5 hours ago',
      ),
    ],
    notes: [
      NoteModel(
        title: 'Mitochondria functions',
        content:
            'Powerhouse of the cell. Generates most of the chemical energy needed to power the cell\'s metabolic reactions.',
        dateCreated: DateTime.now(),
      ),
      NoteModel(
        title: 'Photosynthesis Overview',
        content:
            'Process used by plants to convert light energy into chemical energy (glucose) using water and carbon dioxide.',
        dateCreated: DateTime.now(),
      ),
    ],
  ),
  SubjectModel(
    name: 'Physics',
    subtitle: '8 PDFs •  Quizzes',
    progress: 0.40,
    accent: const Color(0xFF6366F1),
    iconBg: const Color(0xFFEEF2FF),
    icon: SubjectIcon.physics,
    pdfs: [
      const PdfModel(
        title: 'Kinematics Formulas.pdf',
        subjectName: 'Physics',
        timeAgo: 'Opened 1 day ago',
      ),
      const PdfModel(
        title: 'Newtonian Mechanics.pdf',
        subjectName: 'Physics',
        timeAgo: 'Opened 3 days ago',
      ),
    ],
    notes: [
      NoteModel(
        title: 'Newton\'s Second Law',
        content:
            'Force equals mass times acceleration (F = ma). Valid in inertial reference frames.',
        dateCreated: DateTime.now(),
      ),
    ],
  ),
];
