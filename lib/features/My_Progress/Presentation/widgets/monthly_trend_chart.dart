import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/My_Progress/Presentation/widgets/progress_chart_card.dart';
import 'package:study_flow/features/My_Progress/domain/models/progress_stats.dart';

class MonthlyTrendChart extends StatelessWidget {
  final ProgressStats stats;

  const MonthlyTrendChart({super.key, required this.stats});

  static const _weekLabels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxHours = stats.monthlyTrendHours.fold<double>(
      0,
      (max, h) => h > max ? h : max,
    );
    final chartMaxY = maxHours <= 0 ? 30.0 : (maxHours * 1.15).ceilToDouble();
    final yInterval = chartMaxY <= 10 ? 2.0 : 5.0;

    final spots = List.generate(
      stats.monthlyTrendHours.length,
      (index) => FlSpot(index.toDouble(), stats.monthlyTrendHours[index]),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ProgressChartCard(
        title: 'Monthly Trend',
        child: SizedBox(
          height: 220.h,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 3,
              minY: 0,
              maxY: chartMaxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: yInterval,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32.w,
                    interval: yInterval,
                    getTitlesWidget: (value, meta) {
                      if (value % yInterval != 0) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        value.toInt().toString(),
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28.h,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= _weekLabels.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          _weekLabels[index],
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.45),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: ColorsManager.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) {
                      return FlDotCirclePainter(
                        radius: 4.r,
                        color: ColorsManager.primary,
                        strokeWidth: 2,
                        strokeColor: theme.colorScheme.surface,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorsManager.primary.withValues(alpha: 0.25),
                        ColorsManager.primary.withValues(alpha: 0.02),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
