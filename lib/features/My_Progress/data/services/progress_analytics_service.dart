import 'package:flutter/material.dart';
import 'package:study_flow/Core/Models/Study_Record_Model.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/My_Progress/domain/models/progress_stats.dart';
import 'package:study_flow/features/My_Progress/domain/models/subject_analytics.dart';
import 'package:study_flow/features/Study_calendar/data/repositories/study_calendar_repository.dart';

class ProgressAnalyticsService {
  final StudyCalendarRepository _repository;

  ProgressAnalyticsService({StudyCalendarRepository? repository})
      : _repository = repository ?? StudyCalendarRepository();

  ProgressStats calculate() {
    final records = _repository.getAllRecords();
    if (records.isEmpty) return ProgressStats.empty;

    final now = DateTime.now();
    final today = _dateOnly(now);
    final weekStart = _dateOnly(now.subtract(Duration(days: now.weekday - 1)));
    final monthStart = DateTime(now.year, now.month, 1);

    final todayStudyTime = _sumDuration(
      records.where((r) => _dateOnly(r.date) == today),
    );

    final weeklyStudyTime = _sumDuration(
      records.where((r) {
        final d = _dateOnly(r.date);
        return !d.isBefore(weekStart) && d.isBefore(weekStart.add(const Duration(days: 7)));
      }),
    );

    final monthlyStudyTime = _sumDuration(
      records.where((r) {
        final d = _dateOnly(r.date);
        return d.year == monthStart.year && d.month == monthStart.month;
      }),
    );

    final streaks = _calculateStreaks(records);
    final totalSessions = records.length;
    final totalDuration = _sumDuration(records);
    final avgSessionDuration = totalSessions > 0
        ? Duration(seconds: totalDuration.inSeconds ~/ totalSessions)
        : Duration.zero;
    final pdfsRead = records.fold<int>(0, (sum, r) => sum + r.pdfsCount);

    final weeklyFocusHours = List<double>.generate(7, (index) {
      final day = weekStart.add(Duration(days: index));
      final daySeconds = records
          .where((r) => _dateOnly(r.date) == day)
          .fold<int>(0, (sum, r) => sum + r.durationSeconds);
      return daySeconds / 3600.0;
    });

    final subjectDurations = <String, int>{};
    for (final record in records) {
      subjectDurations[record.subjectName] =
          (subjectDurations[record.subjectName] ?? 0) + record.durationSeconds;
    }

    final sortedSubjects = subjectDurations.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final palette = [
      ColorsManager.primary,
      const Color(0xFF374151),
      ColorsManager.accentOrange,
      ColorsManager.accentPurple,
      ColorsManager.accentGreen,
      ColorsManager.warning,
    ];

    final subjectTimeSlices = sortedSubjects.asMap().entries.map((entry) {
      return SubjectTimeSlice(
        subjectName: entry.value.key,
        duration: Duration(seconds: entry.value.value),
        color: palette[entry.key % palette.length],
      );
    }).toList();

    final monthlyTrendHours = List<double>.generate(4, (weekIndex) {
      final weekStartDay = 1 + weekIndex * 7;
      final weekEndDay = (weekIndex == 3)
          ? _daysInMonth(now.year, now.month)
          : weekStartDay + 6;

      final weekSeconds = records.where((r) {
        final d = _dateOnly(r.date);
        if (d.year != now.year || d.month != now.month) return false;
        return d.day >= weekStartDay && d.day <= weekEndDay;
      }).fold<int>(0, (sum, r) => sum + r.durationSeconds);

      return weekSeconds / 3600.0;
    });

    return ProgressStats(
      todayStudyTime: todayStudyTime,
      weeklyStudyTime: weeklyStudyTime,
      monthlyStudyTime: monthlyStudyTime,
      currentStreak: streaks.currentStreak,
      longestStreak: streaks.longestStreak,
      totalSessions: totalSessions,
      avgSessionDuration: avgSessionDuration,
      pdfsRead: pdfsRead,
      weeklyFocusHours: weeklyFocusHours,
      subjectTimeSlices: subjectTimeSlices,
      monthlyTrendHours: monthlyTrendHours,
    );
  }

  int get currentStreak => calculate().currentStreak;

  SubjectAnalytics calculateForSubject(String subjectName) {
    final records = _repository
        .getAllRecords()
        .where((r) => r.subjectName == subjectName)
        .toList();

    if (records.isEmpty) return SubjectAnalytics.empty;

    final now = DateTime.now();
    final weekStart = _dateOnly(now.subtract(Duration(days: now.weekday - 1)));
    final lastWeekStart = weekStart.subtract(const Duration(days: 7));

    final thisWeekTime = _sumDuration(
      records.where((r) {
        final d = _dateOnly(r.date);
        return !d.isBefore(weekStart) &&
            d.isBefore(weekStart.add(const Duration(days: 7)));
      }),
    );

    final lastWeekTime = _sumDuration(
      records.where((r) {
        final d = _dateOnly(r.date);
        return !d.isBefore(lastWeekStart) && d.isBefore(weekStart);
      }),
    );

    final streaks = _calculateStreaks(records);

    return SubjectAnalytics(
      currentStreak: streaks.currentStreak,
      totalStudyTime: _sumDuration(records),
      weeklyProgressPercent: _weeklyProgressPercent(thisWeekTime, lastWeekTime),
      hasWeeklyComparison: lastWeekTime.inSeconds > 0 || thisWeekTime.inSeconds > 0,
    );
  }

  double _weeklyProgressPercent(Duration thisWeek, Duration lastWeek) {
    if (lastWeek.inSeconds == 0) {
      return thisWeek.inSeconds > 0 ? 100.0 : 0.0;
    }
    return ((thisWeek.inSeconds - lastWeek.inSeconds) / lastWeek.inSeconds) *
        100;
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Duration _sumDuration(Iterable<StudyRecordModel> records) {
    final seconds = records.fold<int>(0, (sum, r) => sum + r.durationSeconds);
    return Duration(seconds: seconds);
  }

  int _daysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  _StreakResult _calculateStreaks(List<StudyRecordModel> records) {
    final uniqueDates = records
        .map((r) => _dateOnly(r.date))
        .toSet()
        .toList()
      ..sort();

    if (uniqueDates.isEmpty) {
      return const _StreakResult(currentStreak: 0, longestStreak: 0);
    }

    int longestStreak = 1;
    int tempStreak = 1;

    for (int i = 1; i < uniqueDates.length; i++) {
      final diff = uniqueDates[i].difference(uniqueDates[i - 1]).inDays;
      if (diff == 1) {
        tempStreak++;
      } else if (diff > 1) {
        if (tempStreak > longestStreak) longestStreak = tempStreak;
        tempStreak = 1;
      }
    }
    if (tempStreak > longestStreak) longestStreak = tempStreak;

    final today = _dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));
    final hasToday = uniqueDates.contains(today);
    final hasYesterday = uniqueDates.contains(yesterday);

    int currentStreak = 0;
    if (hasToday || hasYesterday) {
      var checkDate = hasToday ? today : yesterday;
      while (uniqueDates.contains(checkDate)) {
        currentStreak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
    }

    return _StreakResult(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
    );
  }
}

class _StreakResult {
  final int currentStreak;
  final int longestStreak;

  const _StreakResult({
    required this.currentStreak,
    required this.longestStreak,
  });
}

String formatStudyDuration(Duration duration) {
  final totalMinutes = duration.inMinutes;
  if (totalMinutes >= 60) {
    final hours = totalMinutes / 60.0;
    if (hours == hours.roundToDouble()) {
      return '${hours.round()}h';
    }
    return '${hours.toStringAsFixed(1)}h';
  }
  if (totalMinutes > 0) return '${totalMinutes}m';
  return '0h';
}

String formatAvgSession(Duration duration) {
  final minutes = duration.inMinutes;
  if (minutes <= 0) return '0 m';
  return '$minutes m';
}

String formatDetailedStudyDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours > 0 && minutes > 0) return '${hours}h ${minutes}m';
  if (hours > 0) return '${hours}h';
  if (minutes > 0) return '${minutes}m';
  return '0m';
}

String formatStreakDays(int days) {
  if (days == 1) return '1 day';
  return '$days days';
}

String formatWeeklyProgressPercent(double percent) {
  final rounded = percent.round();
  if (rounded > 0) return '+$rounded%';
  if (rounded < 0) return '$rounded%';
  return '0%';
}
