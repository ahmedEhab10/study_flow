import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:study_flow/Core/Models/Study_Record_Model.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class StudyDayDetailsCard extends StatelessWidget {
  final DateTime selectedDate;
  final List<StudyRecordModel> records;

  const StudyDayDetailsCard({
    super.key,
    required this.selectedDate,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter records for the selected day
    final dayRecords = records.where((r) {
      return r.date.year == selectedDate.year &&
          r.date.month == selectedDate.month &&
          r.date.day == selectedDate.day;
    }).toList();

    // Aggregate stats
    final bool hasData = dayRecords.isNotEmpty;
    final String subjects = hasData
        ? dayRecords.map((r) => r.subjectName).toSet().join(', ')
        : 'No study session';
    final int totalSeconds = hasData
        ? dayRecords.fold(0, (sum, r) => sum + r.durationSeconds)
        : 0;
    final int pdfsCount = hasData
        ? dayRecords.fold(0, (sum, r) => sum + r.pdfsCount)
        : 0;
    final int tasksCount = hasData
        ? dayRecords.fold(0, (sum, r) => sum + r.tasksCount)
        : 0;

    // Format duration: e.g. 3600s -> "1h", 5400s -> "1.5h", 90s -> "1.5m"
    String durationText = '0h';
    if (totalSeconds > 0) {
      final hours = totalSeconds / 3600;
      if (hours >= 0.1) {
        // Show as e.g. "1.5h" or "1h"
        durationText = hours % 1 == 0 ? '${hours.toInt()}h' : '${hours.toStringAsFixed(1)}h';
      } else {
        final mins = totalSeconds ~/ 60;
        durationText = '${mins}m';
      }
    }

    // Format Selected Date: "Oct 4th Details"
    final String formattedDate = _formatSelectedDate(selectedDate);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.r),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: e.g. "Oct 4th Details"
          Text(
            formattedDate,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          const Divider(height: 1),
          SizedBox(height: 16.h),

          // 1. Subjects Row
          _buildDetailRow(
            context: context,
            icon: Icons.menu_book_rounded,
            label: 'Subjects',
            value: subjects,
            theme: theme,
          ),
          SizedBox(height: 12.h),

          // 2. Duration Row
          _buildDetailRow(
            context: context,
            icon: Icons.watch_later_outlined,
            label: 'Duration',
            value: durationText,
            theme: theme,
          ),
          SizedBox(height: 12.h),

          // 3. PDFs Row
          _buildDetailRow(
            context: context,
            icon: Icons.description_outlined,
            label: 'PDFs',
            value: '$pdfsCount',
            theme: theme,
          ),
          SizedBox(height: 12.h),

          // 4. Tasks Row
          _buildDetailRow(
            context: context,
            icon: Icons.check_circle_outline_rounded,
            label: 'Tasks',
            value: '$tasksCount',
            theme: theme,
          ),

          SizedBox(height: 20.h),

          // Button: View Session Notes
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
                disabledBackgroundColor: ColorsManager.primaryDark.withValues(alpha: 0.5),
              ),
              onPressed: hasData 
                  ? () => _showNotesSheet(context, dayRecords) 
                  : null,
              child: Text(
                'View Session Notes',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.r,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
        ),
        SizedBox(width: 10.w),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _formatSelectedDate(DateTime date) {
    final day = date.day;
    String suffix = 'th';
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }
    return '${DateFormat('MMM d').format(date)}$suffix Details';
  }

  void _showNotesSheet(BuildContext context, List<StudyRecordModel> dayRecords) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Gather all unique notes
    final List<String> allNotes = [];
    for (var r in dayRecords) {
      if (r.notes.isNotEmpty) {
        allNotes.addAll(r.notes);
      }
    }

    if (allNotes.isEmpty) {
      allNotes.add('No specific notes saved for this session.');
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? ColorsManager.darkSurface : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pull Bar
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Session Notes',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 16.h),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 280.h),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: allNotes.length,
                  separatorBuilder: (_, _) => SizedBox(height: 10.h),
                  itemBuilder: (context, idx) {
                    return Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Icon(
                              Icons.edit_note_rounded,
                              color: ColorsManager.primaryDark,
                              size: 18.r,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              allNotes[idx],
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: theme.colorScheme.onSurface,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
