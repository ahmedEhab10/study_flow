import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:study_flow/Core/Models/Study_Record_Model.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class StudyHeatmapCalendar extends StatelessWidget {
  final List<StudyRecordModel> records;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime currentMonth;
  final ValueChanged<DateTime> onMonthChanged;

  const StudyHeatmapCalendar({
    super.key,
    required this.records,
    required this.selectedDate,
    required this.onDateSelected,
    required this.currentMonth,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Calendar generation details
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekdayOffset = firstDayOfMonth.weekday % 7; // Sunday is 0, Monday is 1, etc.

    // Weekday labels
    final weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    // Map to quickly find total study duration for a day
    final Map<String, int> dailyDuration = {};
    for (var r in records) {
      final key = DateFormat('yyyy-MM-dd').format(r.date);
      dailyDuration[key] = (dailyDuration[key] ?? 0) + r.durationSeconds;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.dividerTheme.color ?? ColorsManager.primary.withValues(alpha: 0.08),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: October 2023 with Navigation Arrows
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(currentMonth),
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left_rounded, size: 22.r),
                      onPressed: () {
                        onMonthChanged(DateTime(currentMonth.year, currentMonth.month - 1, 1));
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(width: 12.w),
                    IconButton(
                      icon: Icon(Icons.chevron_right_rounded, size: 22.r),
                      onPressed: () {
                        onMonthChanged(DateTime(currentMonth.year, currentMonth.month + 1, 1));
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                // Weekday Row (S M T W T F S)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: weekdays.map((day) {
                    return SizedBox(
                      width: 36.w,
                      child: Center(
                        child: Text(
                          day,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12.h),

                // Days Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                  ),
                  itemCount: daysInMonth + startWeekdayOffset,
                  itemBuilder: (context, index) {
                    if (index < startWeekdayOffset) {
                      // Empty cells for weekday padding
                      return const SizedBox.shrink();
                    }

                    final dayNum = index - startWeekdayOffset + 1;
                    final cellDate = DateTime(currentMonth.year, currentMonth.month, dayNum);
                    final dateKey = DateFormat('yyyy-MM-dd').format(cellDate);
                    final isSelected = cellDate.year == selectedDate.year &&
                        cellDate.month == selectedDate.month &&
                        cellDate.day == selectedDate.day;

                    final duration = dailyDuration[dateKey] ?? 0;

                    // Color based on study duration intensity (Heatmap logic)
                    Color cellColor;
                    if (duration == 0) {
                      cellColor = isDark 
                          ? ColorsManager.darkSurfaceVariant.withValues(alpha: 0.4)
                          : ColorsManager.primary.withValues(alpha: 0.05);
                    } else if (duration < 3600) {
                      // < 1 hour
                      cellColor = ColorsManager.primary.withValues(alpha: 0.25);
                    } else if (duration < 7200) {
                      // 1 - 2 hours
                      cellColor = ColorsManager.primary.withValues(alpha: 0.60);
                    } else {
                      // >= 2 hours
                      cellColor = ColorsManager.primaryDark;
                    }

                    return GestureDetector(
                      onTap: () => onDateSelected(cellDate),
                      child: Container(
                        decoration: BoxDecoration(
                          color: cellColor,
                          borderRadius: BorderRadius.circular(8.r),
                          border: isSelected
                              ? Border.all(
                                  color: ColorsManager.primaryDark,
                                  width: 2.r,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '$dayNum',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected 
                                  ? ColorsManager.primaryDark 
                                  : (duration >= 7200 
                                      ? Colors.white 
                                      : theme.colorScheme.onSurface.withValues(alpha: duration > 0 ? 0.9 : 0.6)),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
