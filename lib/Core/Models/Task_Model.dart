class TaskModel {
  final String id;
  final String title;
  final String subjectName;
  final String? pdfTitle;
  final bool isCompleted;
  final String dueCategory; // 'today', 'tomorrow'
  final String? taskTime; // e.g. '9:00 AM'

  const TaskModel({
    required this.id,
    required this.title,
    required this.subjectName,
    this.pdfTitle,
    required this.isCompleted,
    required this.dueCategory,
    this.taskTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subjectName': subjectName,
      'pdfTitle': pdfTitle,
      'isCompleted': isCompleted,
      'dueCategory': dueCategory,
      'taskTime': taskTime,
    };
  }

  factory TaskModel.fromJson(Map<dynamic, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subjectName: json['subjectName'] as String,
      pdfTitle: json['pdfTitle'] as String?,
      isCompleted: json['isCompleted'] as bool,
      dueCategory: json['dueCategory'] as String,
      taskTime: json['taskTime'] as String?,
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? subjectName,
    String? pdfTitle,
    bool? isCompleted,
    String? dueCategory,
    String? taskTime,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subjectName: subjectName ?? this.subjectName,
      pdfTitle: pdfTitle ?? this.pdfTitle,
      isCompleted: isCompleted ?? this.isCompleted,
      dueCategory: dueCategory ?? this.dueCategory,
      taskTime: taskTime ?? this.taskTime,
    );
  }
}
