import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/features/My_Progress/data/services/progress_analytics_service.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/information_item.dart';
import 'package:study_flow/features/subject_details/presentation/widgets/analytics_item.dart';

class SubjectAnalyticsSection extends StatefulWidget {
  final String subjectName;

  const SubjectAnalyticsSection({super.key, required this.subjectName});

  @override
  State<SubjectAnalyticsSection> createState() =>
      _SubjectAnalyticsSectionState();
}

class _SubjectAnalyticsSectionState extends State<SubjectAnalyticsSection> {
  final _analyticsService = ProgressAnalyticsService();

  late String _streakInfo;
  late String _totalStudyTime;
  late double _weeklyProgressPercent;
  late bool _isWeeklyProgressPositive;
  late bool _hasWeeklyComparison;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  @override
  void activate() {
    super.activate();
    _loadAnalytics();
  }

  void _loadAnalytics() {
    final analytics = _analyticsService.calculateForSubject(widget.subjectName);
    setState(() {
      _streakInfo = formatStreakDays(analytics.currentStreak);
      _totalStudyTime = formatDetailedStudyDuration(analytics.totalStudyTime);
      _weeklyProgressPercent = analytics.weeklyProgressPercent;
      _isWeeklyProgressPositive = analytics.isWeeklyProgressPositive;
      _hasWeeklyComparison = analytics.hasWeeklyComparison;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics',
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        AnalyticsItem(
          weeklyProgressPercent: _weeklyProgressPercent,
          isPositive: _isWeeklyProgressPositive,
          hasComparison: _hasWeeklyComparison,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: InformationItem(
                title: 'DAY STREAK',
                icon: Assets.svgsStreak,
                theinfo: _streakInfo,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: InformationItem(
                title: 'TOTAL STUDY TIME',
                icon: Assets.svgsTime,
                theinfo: _totalStudyTime,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
