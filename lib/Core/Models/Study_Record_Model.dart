class StudyRecordModel {
  final String id;
  final DateTime date;
  final String subjectName;
  final int durationSeconds;
  final int pdfsCount;
  final int tasksCount;
  final List<String> notes;

  const StudyRecordModel({
    required this.id,
    required this.date,
    required this.subjectName,
    required this.durationSeconds,
    required this.pdfsCount,
    required this.tasksCount,
    this.notes = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'subjectName': subjectName,
      'durationSeconds': durationSeconds,
      'pdfsCount': pdfsCount,
      'tasksCount': tasksCount,
      'notes': notes,
    };
  }

  factory StudyRecordModel.fromJson(Map<dynamic, dynamic> json) {
    return StudyRecordModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      subjectName: json['subjectName'] as String,
      durationSeconds: json['durationSeconds'] as int,
      pdfsCount: json['pdfsCount'] as int,
      tasksCount: json['tasksCount'] as int,
      notes: (json['notes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  StudyRecordModel copyWith({
    String? id,
    DateTime? date,
    String? subjectName,
    int? durationSeconds,
    int? pdfsCount,
    int? tasksCount,
    List<String>? notes,
  }) {
    return StudyRecordModel(
      id: id ?? this.id,
      date: date ?? this.date,
      subjectName: subjectName ?? this.subjectName,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      pdfsCount: pdfsCount ?? this.pdfsCount,
      tasksCount: tasksCount ?? this.tasksCount,
      notes: notes ?? this.notes,
    );
  }
}
