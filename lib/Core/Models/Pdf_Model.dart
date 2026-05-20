class PdfModel {
  final String title;
  final String subjectName;
  final String timeAgo;
  final String? filePath;

  const PdfModel({
    required this.title,
    required this.subjectName,
    required this.timeAgo,
    this.filePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subjectName': subjectName,
      'timeAgo': timeAgo,
      'filePath': filePath,
    };
  }

  factory PdfModel.fromJson(Map<dynamic, dynamic> json) {
    return PdfModel(
      title: json['title'] as String,
      subjectName: json['subjectName'] as String,
      timeAgo: json['timeAgo'] as String,
      filePath: json['filePath'] as String?,
    );
  }
}
