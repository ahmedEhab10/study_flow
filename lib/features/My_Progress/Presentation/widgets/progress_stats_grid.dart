import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/My_Progress/data/services/progress_analytics_service.dart';
import 'package:study_flow/features/My_Progress/domain/models/progress_stats.dart';

class ProgressStatsGrid extends StatelessWidget {
  final ProgressStats stats;

  const ProgressStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.55,
        children: [
          _StatTile(
            icon: Icons.local_fire_department_rounded,
            iconColor: ColorsManager.accentOrange,
            value: '${stats.longestStreak} days',
            label: 'Longest Streak',
          ),
          _StatTile(
            icon: Icons.timer_outlined,
            iconColor: ColorsManager.primary,
            value: '${stats.totalSessions}',
            label: 'Total Sessions',
          ),
          _StatTile(
            icon: Icons.hourglass_bottom_rounded,
            iconColor: ColorsManager.textSecondaryLight,
            value: formatAvgSession(stats.avgSessionDuration),
            label: 'Avg. Session',
          ),
          _StatTile(
            icon: Icons.menu_book_rounded,
            iconColor: const Color(0xFFB45309),
            value: '${stats.pdfsRead}',
            label: 'PDFs Read',
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ColorsManager.primary.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 22.r),
          SizedBox(height: 10.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
