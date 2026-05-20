class NoteModel {
  final String title;
  final String content;
  final DateTime dateCreated;

  const NoteModel({
    required this.title,
    required this.content,
    required this.dateCreated,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'dateCreated': dateCreated.toIso8601String(),
    };
  }

  factory NoteModel.fromJson(Map<dynamic, dynamic> json) {
    return NoteModel(
      title: json['title'] as String,
      content: json['content'] as String,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
    );
  }
}
