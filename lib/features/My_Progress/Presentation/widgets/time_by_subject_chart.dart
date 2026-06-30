import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/features/My_Progress/Presentation/widgets/progress_chart_card.dart';
import 'package:study_flow/features/My_Progress/domain/models/progress_stats.dart';

class TimeBySubjectChart extends StatelessWidget {
  final ProgressStats stats;

  const TimeBySubjectChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final slices = stats.subjectTimeSlices;

    if (slices.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ProgressChartCard(
          title: 'Time by Subject',
          child: SizedBox(
            height: 160.h,
            child: Center(
              child: Text(
                'No study sessions recorded yet.',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ProgressChartCard(
        title: 'Time by Subject',
        child: SizedBox(
          height: 180.h,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 42.r,
                    startDegreeOffset: -90,
                    sections: slices.map((slice) {
                      return PieChartSectionData(
                        value: slice.duration.inSeconds.toDouble(),
                        color: slice.color,
                        radius: 36.r,
                        showTitle: false,
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: slices.take(4).map((slice) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        children: [
                          Container(
                            width: 10.r,
                            height: 10.r,
                            decoration: BoxDecoration(
                              color: slice.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              slice.subjectName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
