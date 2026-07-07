class SubjectAnalytics {
  final int currentStreak;
  final Duration totalStudyTime;
  final double weeklyProgressPercent;
  final bool hasWeeklyComparison;

  const SubjectAnalytics({
    required this.currentStreak,
    required this.totalStudyTime,
    required this.weeklyProgressPercent,
    required this.hasWeeklyComparison,
  });

  static const empty = SubjectAnalytics(
    currentStreak: 0,
    totalStudyTime: Duration.zero,
    weeklyProgressPercent: 0,
    hasWeeklyComparison: false,
  );

  bool get isWeeklyProgressPositive => weeklyProgressPercent >= 0;
}
