import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/My_Progress/data/services/progress_analytics_service.dart';
import 'package:study_flow/features/My_Progress/domain/models/progress_stats.dart';

class TimeSummaryWidget extends StatelessWidget {
  final ProgressStats stats;

  const TimeSummaryWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        children: [
          _TimeBlock(
            label: 'TODAY',
            value: formatStudyDuration(stats.todayStudyTime),
            valueStyle: GoogleFonts.inter(
              fontSize: 48.sp,
              fontWeight: FontWeight.w800,
              color: ColorsManager.primary,
              height: 1.1,
            ),
            labelColor: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
          SizedBox(height: 20.h),
          _TimeBlock(
            label: 'WEEKLY',
            value: formatStudyDuration(stats.weeklyStudyTime),
            valueStyle: GoogleFonts.inter(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
              height: 1.1,
            ),
            labelColor: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
          SizedBox(height: 16.h),
          _TimeBlock(
            label: 'MONTHLY',
            value: formatStudyDuration(stats.monthlyStudyTime),
            valueStyle: GoogleFonts.inter(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
              height: 1.1,
            ),
            labelColor: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle valueStyle;
  final Color labelColor;

  const _TimeBlock({
    required this.label,
    required this.value,
    required this.valueStyle,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: labelColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(value, style: valueStyle),
      ],
    );
  }
}
