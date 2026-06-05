class NoteModel {
  final String id;
  final String title;
  final String content;
  final DateTime dateCreated;
  final bool isCompleted;

  NoteModel({
    String? id,
    required this.title,
    required this.content,
    required this.dateCreated,
    this.isCompleted = false,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateCreated': dateCreated.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory NoteModel.fromJson(Map<dynamic, dynamic> json) {
    return NoteModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      dateCreated: DateTime.tryParse(json['dateCreated'] as String? ?? '') ??
          DateTime.now(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? dateCreated,
    bool? isCompleted,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      dateCreated: dateCreated ?? this.dateCreated,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
