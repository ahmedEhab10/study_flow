import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/My_Progress/data/services/progress_analytics_service.dart';

class AnalyticsItem extends StatelessWidget {
  final double weeklyProgressPercent;
  final bool isPositive;
  final bool hasComparison;

  const AnalyticsItem({
    super.key,
    required this.weeklyProgressPercent,
    this.isPositive = true,
    this.hasComparison = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressLabel = hasComparison
        ? formatWeeklyProgressPercent(weeklyProgressPercent)
        : '0%';
    final comparisonColor = !hasComparison
        ? theme.colorScheme.onSurface.withValues(alpha: 0.45)
        : isPositive
            ? ColorsManager.tartar
            : ColorsManager.error;

    return Container(
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1.5, color: Color(0x19717783)),
          borderRadius: BorderRadius.circular(24.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            right: 0,
            top: 0,
            child: Image.asset(
              'assets/Images/completion_background.png',
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WEEKLY PROGRESS',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      progressLabel,
                      style: GoogleFonts.inter(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'vs last week',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: comparisonColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/Images/analytics_background.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
