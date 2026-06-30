import 'package:flutter/material.dart';

class SubjectTimeSlice {
  final String subjectName;
  final Duration duration;
  final Color color;

  const SubjectTimeSlice({
    required this.subjectName,
    required this.duration,
    required this.color,
  });
}

class ProgressStats {
  final Duration todayStudyTime;
  final Duration weeklyStudyTime;
  final Duration monthlyStudyTime;
  final int currentStreak;
  final int longestStreak;
  final int totalSessions;
  final Duration avgSessionDuration;
  final int pdfsRead;
  final List<double> weeklyFocusHours;
  final List<SubjectTimeSlice> subjectTimeSlices;
  final List<double> monthlyTrendHours;

  const ProgressStats({
    required this.todayStudyTime,
    required this.weeklyStudyTime,
    required this.monthlyStudyTime,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalSessions,
    required this.avgSessionDuration,
    required this.pdfsRead,
    required this.weeklyFocusHours,
    required this.subjectTimeSlices,
    required this.monthlyTrendHours,
  });

  static const empty = ProgressStats(
    todayStudyTime: Duration.zero,
    weeklyStudyTime: Duration.zero,
    monthlyStudyTime: Duration.zero,
    currentStreak: 0,
    longestStreak: 0,
    totalSessions: 0,
    avgSessionDuration: Duration.zero,
    pdfsRead: 0,
    weeklyFocusHours: [0, 0, 0, 0, 0, 0, 0],
    subjectTimeSlices: [],
    monthlyTrendHours: [0, 0, 0, 0],
  );
}
