import 'dart:ui';

class SubjectModel {
  final String name;
  final String subtitle;
  final double progress;
  final Color accent;
  final Color iconBg;
  final SubjectIcon icon;

  const SubjectModel({
    required this.name,
    required this.subtitle,
    required this.progress,
    required this.accent,
    required this.iconBg,
    required this.icon,
  });
}

enum SubjectIcon {
  biology,
  physics,
  history,
  mathematics,
  chemistry,
  literature,
  geography,
  computerScience,
}
