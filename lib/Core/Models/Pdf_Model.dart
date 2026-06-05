class PdfModel {
  final String id;
  final String title;
  final String subjectName;
  final String timeAgo;
  final String? filePath;
  final bool isCompleted;

  PdfModel({
    String? id,
    required this.title,
    required this.subjectName,
    required this.timeAgo,
    this.filePath,
    this.isCompleted = false,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subjectName': subjectName,
      'timeAgo': timeAgo,
      'filePath': filePath,
      'isCompleted': isCompleted,
    };
  }

  factory PdfModel.fromJson(Map<dynamic, dynamic> json) {
    return PdfModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      subjectName: json['subjectName'] as String,
      timeAgo: json['timeAgo'] as String,
      filePath: json['filePath'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  PdfModel copyWith({
    String? id,
    String? title,
    String? subjectName,
    String? timeAgo,
    String? filePath,
    bool? isCompleted,
  }) {
    return PdfModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subjectName: subjectName ?? this.subjectName,
      timeAgo: timeAgo ?? this.timeAgo,
      filePath: filePath ?? this.filePath,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
