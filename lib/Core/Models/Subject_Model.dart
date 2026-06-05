import 'dart:ui';
import 'package:study_flow/Core/Models/Pdf_Model.dart';
import 'package:study_flow/Core/Models/Note_Model.dart';

class SubjectModel {
  final String name;
  final String subtitle;
  final double progress;
  final Color accent;
  final Color iconBg;
  final SubjectIcon icon;
  final List<PdfModel> pdfs;
  final List<NoteModel> notes;

  const SubjectModel({
    required this.name,
    required this.subtitle,
    required this.progress,
    required this.accent,
    required this.iconBg,
    required this.icon,
    this.pdfs = const [],
    this.notes = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subtitle': subtitle,
      'progress': progress,
      'accent': accent.toARGB32(),
      'iconBg': iconBg.toARGB32(),
      'icon': icon.name,
      'pdfs': pdfs.map((pdf) => pdf.toJson()).toList(),
      'notes': notes.map((note) => note.toJson()).toList(),
    };
  }

  factory SubjectModel.fromJson(Map<dynamic, dynamic> json) {
    return SubjectModel(
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
      progress: (json['progress'] as num).toDouble(),
      accent: Color(json['accent'] as int),
      iconBg: Color(json['iconBg'] as int),
      icon: SubjectIcon.values.firstWhere(
        (e) => e.name == json['icon'],
        orElse: () => SubjectIcon.general,
      ),
      pdfs:
          (json['pdfs'] as List<dynamic>?)
              ?.map((pdf) => PdfModel.fromJson(pdf as Map))
              .toList() ??
          const [],
      notes:
          (json['notes'] as List<dynamic>?)
              ?.map((note) => NoteModel.fromJson(note as Map))
              .toList() ??
          const [],
    );
  }

  SubjectModel copyWith({
    String? name,
    String? subtitle,
    double? progress,
    Color? accent,
    Color? iconBg,
    SubjectIcon? icon,
    List<PdfModel>? pdfs,
    List<NoteModel>? notes,
  }) {
    return SubjectModel(
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      progress: progress ?? this.progress,
      accent: accent ?? this.accent,
      iconBg: iconBg ?? this.iconBg,
      icon: icon ?? this.icon,
      pdfs: pdfs ?? this.pdfs,
      notes: notes ?? this.notes,
    );
  }
}

enum SubjectIcon {
  general,
  biology,
  physics,
  history,
  mathematics,
  chemistry,
  literature,
  geography,
  computerScience,
}


