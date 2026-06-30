import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/My_Progress/Presentation/widgets/progress_chart_card.dart';
import 'package:study_flow/features/My_Progress/domain/models/progress_stats.dart';

class WeeklyFocusChart extends StatelessWidget {
  final ProgressStats stats;

  const WeeklyFocusChart({super.key, required this.stats});

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxHours = stats.weeklyFocusHours.fold<double>(
      0,
      (max, h) => h > max ? h : max,
    );
    final chartMaxY = maxHours <= 0 ? 4.0 : (maxHours * 1.2).ceilToDouble();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ProgressChartCard(
        title: 'Weekly Focus',
        child: SizedBox(
          height: 180.h,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: chartMaxY,
              minY: 0,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= _dayLabels.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          _dayLabels[index],
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.45),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(7, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: stats.weeklyFocusHours[index],
                      color: ColorsManager.primary,
                      width: 22.w,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(6.r),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
