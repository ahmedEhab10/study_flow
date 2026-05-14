import 'dart:ui';

import 'package:study_flow/Core/Models/Subject_Model.dart';

const subjects = [
  SubjectModel(
    name: 'Physics',
    subtitle: '8 PDFs • 6 Quizzes',
    progress: 0.40,
    accent: Color(0xFF6366F1),
    iconBg: Color(0xFFEEF2FF),
    icon: SubjectIcon.physics,
  ),
  SubjectModel(
    name: 'Modern History',
    subtitle: '24 PDFs • 2 Quizzes',
    progress: 0.85,
    accent: Color(0xFFF59E0B),
    iconBg: Color(0xFFFFF7ED),
    icon: SubjectIcon.history,
  ),
  SubjectModel(
    name: 'Mathematics',
    subtitle: '16 PDFs • 9 Quizzes',
    progress: 0.55,
    accent: Color(0xFFEF4444),
    iconBg: Color(0xFFFEF2F2),
    icon: SubjectIcon.mathematics,
  ),
  SubjectModel(
    name: 'Chemistry',
    subtitle: '10 PDFs • 5 Quizzes',
    progress: 0.72,
    accent: Color(0xFF06B6D4),
    iconBg: Color(0xFFECFEFF),
    icon: SubjectIcon.chemistry,
  ),
  SubjectModel(
    name: 'Literature',
    subtitle: '20 PDFs • 3 Quizzes',
    progress: 0.30,
    accent: Color(0xFFEC4899),
    iconBg: Color(0xFFFDF2F8),
    icon: SubjectIcon.literature,
  ),
  SubjectModel(
    name: 'Geography',
    subtitle: '14 PDFs • 7 Quizzes',
    progress: 0.60,
    accent: Color(0xFF10B981),
    iconBg: Color(0xFFECFDF5),
    icon: SubjectIcon.geography,
  ),
  SubjectModel(
    name: 'Computer Science',
    subtitle: '18 PDFs • 11 Quizzes',
    progress: 0.88,
    accent: Color(0xFF8B5CF6),
    iconBg: Color(0xFFF5F3FF),
    icon: SubjectIcon.computerScience,
  ),
  SubjectModel(
    name: 'Biology',
    subtitle: '12 PDFs • 4 Quizzes',
    progress: 0.65,
    accent: Color(0xFF22C55E),
    iconBg: Color(0xFFDCFCE7),
    icon: SubjectIcon.biology,
  ),
];
